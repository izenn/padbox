#!/usr/bin/env python -O

__doc__ = """
Simple proxy to intercept Puzzle & Dragon account data and sync with PADHerder.
Based on 'Tiny HTTP Proxy' by SUZUKI Hisao (http://www.oki-osk.jp/esc/python/proxy/)
"""
__version__ = "0.3.0"

import BaseHTTPServer, dnsproxy, gzip, os, select, socket, SocketServer, sys, thread, time, urlparse, cStringIO

class ProxyHandler (BaseHTTPServer.BaseHTTPRequestHandler):
    __base = BaseHTTPServer.BaseHTTPRequestHandler
    __base_handle = __base.handle

    #server_version = "TinyHTTPProxy/" + __version__
    rbufsize = 0                        # self.rfile Be unbuffered

    def handle(self):
        self.__base_handle()

    def _connect_to(self, netloc, soc):
        i = netloc.find(':')
        if i >= 0:
            host_port = netloc[:i], int(netloc[i+1:])
        else:
            host_port = netloc, 80
        try: soc.connect(host_port)
        except socket.error, arg:
            try: msg = arg[1]
            except: msg = arg
            self.send_error(404, msg)
            return 0
        return 1

    def do_CONNECT(self):
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            if self._connect_to(self.path, soc):
                self.log_request(200)
                self.wfile.write("%s 200 Connection established\r\n" % (self.protocol_version))
                #self.wfile.write("Proxy-agent: %s\r\n" % (self.version_string()))
                self.wfile.write("\r\n")
                self._read_write(soc, False, 300)
            else:
                self.log_request(900)
        finally:
            self.log_request(901)
            soc.close()
            self.connection.close()

    def do_GET(self):
        if 'api' in self.d:
            self.path = 'http://%s%s' % (self.d['api'], self.path)
        (scm, netloc, path, params, query, fragment) = urlparse.urlparse(self.path, 'http')
        if scm != 'http' or fragment or not netloc:
            self.log_request(899)
            self.send_error(400, "bad url %s" % self.path)
            return

        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            if self._connect_to(netloc, soc):
                self.log_request()
                soc.send("%s %s %s\r\n" % (
                    self.command,
                    urlparse.urlunparse(('', '', path, params, query, '')),
                    self.request_version)
                )
                self.headers['Connection'] = 'close'
                del self.headers['Proxy-Connection']
                for key_val in self.headers.items():
                    soc.send("%s: %s\r\n" % key_val)
                soc.send("\r\n")
                if netloc.startswith('api-') and netloc.endswith('padsv.gungho.jp') and 'action=get_player_data' in query:
                    self._read_write(soc, True)
                else:
                    self._read_write(soc)
            else:
                self.log_request(950)
        finally:
            self.log_request(951)
            soc.close()
            self.connection.close()

    def _read_write(self, soc, capture=False, max_idling=20):
        iw = [self.connection, soc]
        ow = []
        count = 0
        all_data = []
        while 1:
            count += 1
            (ins, _, exs) = select.select(iw, ow, iw, 3)
            if exs:
                break

            if ins:
                for i in ins:
                    if i is soc:
                        out = self.connection
                    else:
                        out = soc
                    data = i.recv(8192)
                    if data:
                        all_data.append(data)
                        out.send(data)
                        count = 0
            if count == max_idling: break

        if capture:
            self.save_capture(''.join(all_data))

    def save_capture(self, content):
        f = 'capture.%d' % (time.time())
        open(os.path.join(os.path.dirname(__file__), f), 'wb').write(self.parse_content(content))
        self.log_message('-- CAPTURED BOX DATA -- %s', f)

    def parse_content(self, content):
        header_chunk, data = content.split('\r\n\r\n', 1)
        is_chunked = False
        is_gzip = False
        for header in header_chunk.splitlines():
            try:
                k, v = header.strip().lower().split(':', 1)
            except ValueError:
                continue
            else:
                if k == 'content-encoding' and 'gzip' in v:
                    is_gzip = True
                elif k == 'transfer-encoding' and 'chunked' in v:
                    is_chunked = True
        if is_chunked:
            temp = data
            chunks = []
            while temp:
                size, temp = temp.split('\r\n', 1)
                if size:
                    isize = int(size, 16)
                    chunks.append(temp[:isize])
                    temp = temp[isize:]
            data = ''.join(chunks)
        if is_gzip:
            try:
                text = gzip.GzipFile(fileobj=cStringIO.StringIO(data)).read()
            except Exception, msg:
                self.log_error('gunzip failed: %s', msg)
                text = ''
        else:
            text = data
        return text

    do_HEAD = do_GET
    do_POST = do_GET
    do_PUT  = do_GET
    do_DELETE=do_GET

class ThreadingHTTPServer (SocketServer.ThreadingMixIn, BaseHTTPServer.HTTPServer):
    pass

def serve(HandlerClass, ServerClass, d):
    if len(sys.argv) >= 2:
        port = int(sys.argv[1])
    else:
        port = 8000
    if len(sys.argv) >= 3:
        host = sys.argv[2]
    else:
        host = ''
    server_address = (host, port)

    HandlerClass.d = d
    HandlerClass.protocol_version = 'HTTP/1.0'
    httpd = ServerClass(server_address, HandlerClass)

    sa = httpd.socket.getsockname()
    print "Serving HTTP on", sa[0], "port", sa[1], "..."
    httpd.serve_forever()

if __name__ == '__main__':
    d = {}
    if len(sys.argv) >= 2 and sys.argv[1] in ('-h', '--help'):
        print sys.argv[0], "[port] [ip]"
    else:
        thread.start_new_thread(serve, (ProxyHandler, ThreadingHTTPServer, d))
        if len(sys.argv) >= 3:
            thread.start_new_thread(dnsproxy.serveDNS, (d,))
        while True:
            time.sleep(0.1)
