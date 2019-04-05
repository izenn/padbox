"""http://code.activestate.com/recipes/491264-mini-fake-dns-server/"""
import socket, sys, re

class DNSQuery:
    def __init__(self, data, d):
        self.data=data
        self.d=d
        self.domain=''
        self.localRegex = re.compile('(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})|(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^local.*)|localhost|(^http)|(^https)')
        tipo = (ord(data[2]) >> 3) & 15   # Opcode bits
        if tipo == 0:                     # Standard query
            ini=12
            lon=ord(data[ini])
            while lon != 0:
                self.domain+=data[ini+1:ini+lon+1]+'.'
                ini+=lon+1
                lon=ord(data[ini])

    def response(self, ip):
        packet=''
        if self.domain:
            packet+=self.data[:2] + "\x81\x80"
            packet+=self.data[4:6] + self.data[4:6] + '\x00\x00\x00\x00'   # Questions and Answers Counts
            packet+=self.data[12:]                                         # Original Domain Name Question
            packet+='\xc0\x0c'                                             # Pointer to domain name
            packet+='\x00\x01\x00\x01\x00\x00\x00\x3c\x00\x04'             # Response type, ttl and resource data length -> 4 bytes
            if self.domain.startswith('api-') and self.domain.endswith('padsv.gungho.jp.'):
                replyip = ip
                self.d['api'] = self.domain[:-1]
            elif self.localRegex.match(self.domain):
                return packet
            else:
                print "DOMAIN ", self.domain
                replyip = socket.gethostbyname(self.domain)
                self.d['api'] = ''
            #packet+=str.join('',map(lambda x: chr(int(x)), .split('.'))) # 4bytes of IP
            packet+=''.join(chr(int(x)) for x in replyip.split('.'))
            print 'DNS reply: %s -> %s' % (self.domain, replyip)

        return packet

def serveDNS(d):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((sys.argv[2], 53))
    sa = sock.getsockname()
    print "Serving DNS on", sa[0], "port", sa[1], "..."
    try:
        while True:
            data, addr = sock.recvfrom(1024)
            p = DNSQuery(data, d)
            sock.sendto(p.response(sys.argv[2]), addr)
            print sys.argv[2], " ", addr
    except KeyboardInterrupt:
        sock.close()

# if __name__ == '__main__':
#   ip='192.168.1.1'
#   print 'pyminifakeDNS:: dom.query. 60 IN A %s' % ip

#   udps = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#   udps.bind(('',53))

#   try:
#     while 1:
#       data, addr = udps.recvfrom(1024)
#       p=DNSQuery(data)
#       udps.sendto(p.respuesta(ip), addr)
#       print 'Respuesta: %s -> %s' % (p.dominio, ip)
#   except KeyboardInterrupt:
#     print 'Finalizando'
#     udps.close()
