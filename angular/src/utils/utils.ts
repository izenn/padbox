export interface CardImg {
  frame: string,
  sub: string,
  src: string,
  name: string
}

export interface TeamData {
  number: string,
  leader: CardImg,
  sub1: CardImg,
  sub2: CardImg,
  sub3: CardImg,
  sub4: CardImg,
  helper: CardImg,
  badge: string
}

export interface UserData {
  id: string;
  name: string;
  level: string,
  active: string,
  slot1: string,
  slot2: string
}

export interface RemData {
  id?: string,
  img?: string,
  name?: string,
  rarity?: string,
  level?: string,
  type?: string[],
  evo?: string,
  skillLevel?: string,
  skillMax?: string,
  awokenLevel?: string,
  awokenMax?: string,
  latent?: string[],
  hp?: string,
  atk?: string,
  rcv?: string,
  mp?: string
}

export function getCardData(id: string|number) {
  const req = fetch(`https://padbox-237005.appspot.com/cards/${id}`).then(r =>{
    return r.json().then(data => data[0]);
  });
  req.catch(err => {
    console.error(`Failed to get card data: ${err}`);
  });
  return req;
}

export const latentMap = {
  "0000010": { type: 'imphp', text: 'Imp. HP' },
  "0000100": { type: 'impatk', text: 'Imp. ATK' },
  "0000110": { type: 'imprcv', text: 'Imp. RCV' },
  "0001010": { type: 'autoheal', text: 'Auto-Heal' },
  "0001000": { type: 'exttime', text: 'Ext. Move Time' },
  "0001100": { type: 'firedr', text: 'Fire Dmg. Red.' },
  "0001110": { type: 'waterdr', text: 'Water Dmg. Red.' },
  "0010000": { type: 'wooddr', text: 'Wood Dmg. Red.' },
  "0010010": { type: 'lightdr', text: 'Light Dmg. Red.' },
  "0010100": { type: 'darkdr', text: 'Dark Dmg. Red.' },
  "0010110": { type: 'sdr', text: 'Skill Delay Resist.' },
  "0011000": { type: 'impall', text: 'Imp. All Stats' },
  "0101000": { type: 'godkiller', text: 'God Killer' },
  "0101010": { type: 'dragonkiller', text: 'Dragon Killer' },
  "1000000": { type: 'devilkiller', text: 'Devil Killer' },
  "0101110": { type: 'machinekiller', text: 'Machine Killer' },
  "0110000": { type: 'balancedkiller', text: 'Balanced Killer' },
  "0110010": { type: 'attackerkiller', text: 'Attacker Killer' },
  "0110100": { type: 'physicalkiller', text: 'Physical Killer' },
  "0110110": { type: 'healerkiller', text: 'Healer Killer' },
  "0111000": { type: 'imphpplus', text: 'Imp. HP+' },
  "0111010": { type: 'impatkplus', text: 'Imp. ATK+' },
  "0111100": { type: 'imprcvplus', text: 'Imp. RCV+' },
  "0111110": { type: 'exttimeplus', text: 'Ext. Move Time+' },
  "0100000": { type: 'evokiller', text: 'Evo Material Killer' },
  "0100010": { type: 'awokenkiller', text: 'Awoken Material Killer' },
  "0100100": { type: 'enhancedkiller', text: 'Enhanced Material Killer' },
  "0100110": { type: 'redeemablekiller', text: 'Redeemable Material Killer' },
  "0101100": { type: 'firedrplus', text: 'Fire Dmg. Red.+' },
  "1000010": { type: 'waterdrplus', text: 'Water Dmg. Red.+' },
  "1000100": { type: 'wooddrplus', text: 'Wood Dmg. Red.+' },
  "1000110": { type: 'lightdrplus', text: 'Light Dmg. Red.+' },
  "1001000": { type: 'darkdrplus', text: 'Dark Dmg. Red.+' },
}