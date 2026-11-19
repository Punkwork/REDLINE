// Generates the HALCYON CAPTCHA encounter mockups (static markup) for preview + .dc.html
import fs from 'fs';
import path from 'path';

const OUT = process.argv[2] || '/home/claude/enc/out';
fs.mkdirSync(path.join(OUT, 'project'), { recursive: true });

// ---------- tokens ----------
const T = {
  bake: 'linear-gradient(180deg,#5a3f2a 0%,#3e2b1d 40%,#2e2016 100%)',
  cream: '#efe6d2',
  creamGrad: 'linear-gradient(180deg,#f4ecda,#dccfb2)',
  amber: '#ffb85a',
  ink: '#2a1d0e',
  glass: '#0a0908',
  chrome: 'linear-gradient(180deg,#fbfcfc 0%,#c9cfd1 38%,#eef1f1 52%,#9aa2a4 100%)',
  chromeSide: 'linear-gradient(90deg,#9aa2a4,#f4f6f6 30%,#c9cfd1 60%,#8b9395)',
  mint: 'linear-gradient(180deg,#d8efe6 0%,#b9e0d1 42%,#a2d3c1 100%)',
  mintDeep: '#3f7f70',
  red: '#d8321f',
};
const F = { cond: "'Barlow Condensed','Arial Narrow',sans-serif", sans: "'DM Sans',system-ui,sans-serif", mono: "'Space Mono',monospace", deco: "'Poiret One',serif" };

const flipBg = 'linear-gradient(180deg,#3d3d3d 0,#262626 47%,#050505 47%,#050505 53%,#1c1c1c 53%,#0d0d0d 100%)';
function tile(c, o = {}) {
  const w = o.w ?? 24, h = o.h ?? 40, fs = o.fs ?? 28, col = o.color ?? '#f8f5ee';
  const pinTop = Math.round(h / 2 - h * 0.125), pinH = Math.max(6, Math.round(h * 0.25));
  return `<span style="position: relative; display: block; width: ${w}px; height: ${h}px; line-height: ${h}px; text-align: center; font-size: ${fs}px; font-weight: 700; color: ${col}; border-radius: ${Math.round(w / 5)}px; background: ${flipBg}; box-shadow: inset 0 1px 0 rgba(255,255,255,0.18), inset 0 0 0 1px rgba(0,0,0,0.6), 0 2px 3px rgba(0,0,0,0.85); overflow: hidden${o.dim ? '; opacity: 0.35' : ''}">${c === ' ' ? '&nbsp;' : esc(c)}<span aria-hidden="true" style="position: absolute; left: 1px; top: ${pinTop}px; width: 2px; height: ${pinH}px; border-radius: 1px; background: linear-gradient(90deg,#6d6d6d,#e2e2e2 50%,#555)"></span><span aria-hidden="true" style="position: absolute; right: 1px; top: ${pinTop}px; width: 2px; height: ${pinH}px; border-radius: 1px; background: linear-gradient(90deg,#6d6d6d,#e2e2e2 50%,#555)"></span></span>`;
}
function tiles(str, o = {}, gap = 3) {
  return `<div style="display: flex; gap: ${gap}px">${str.split('').map((c) => tile(c, o)).join('')}</div>`;
}
function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
function lamp(color, on, size = 9, extra = '') {
  return `<span aria-hidden="true" style="display: block; flex: 0 0 auto; width: ${size}px; height: ${size}px; border-radius: 50%; ${on ? `background: radial-gradient(circle at 35% 35%,#fff 0,${color} 45%,#1a0d05 100%); box-shadow: 0 0 ${size * 0.8}px ${color}, 0 0 0 1px rgba(0,0,0,0.7)` : 'background: radial-gradient(circle at 35% 35%,#55504a,#141210); box-shadow: inset 0 1px 1px #000, 0 0 0 1px rgba(0,0,0,0.6)'}${extra}"></span>`;
}
function screw(pos) {
  return `<span aria-hidden="true" style="position: absolute; ${pos}; width: 7px; height: 7px; border-radius: 50%; background: radial-gradient(circle at 35% 35%,#e4e4de,#5c5c56); box-shadow: 0 0 0 1px rgba(0,0,0,0.5)"><span style="position: absolute; left: 1px; right: 1px; top: 3px; height: 1px; background: rgba(0,0,0,0.55); transform: rotate(35deg)"></span></span>`;
}
// Dymo embossed tape
function dymo(text, v = 'black', o = {}) {
  const bg = v === 'red' ? 'linear-gradient(180deg,#e0402c,#b8261a 55%,#9c1f15)' : v === 'amber' ? 'linear-gradient(180deg,#f2b54a,#d48d22 55%,#b97516)' : 'linear-gradient(180deg,#2a2a2a,#151515 55%,#0b0b0b)';
  const fg = v === 'amber' ? '#2a1606' : '#fbf7ef';
  const shadow = v === 'amber' ? '0 1px 0 rgba(255,240,200,0.6)' : '0 -1px 0 rgba(0,0,0,0.65), 0 1px 0 rgba(255,255,255,0.28)';
  return `<span style="display: inline-flex; align-items: center; height: ${o.h ?? 26}px; padding: 0 ${o.px ?? 10}px; border-radius: 3px; background: ${bg}; box-shadow: 0 1px 2px rgba(0,0,0,0.45), inset 0 1px 0 rgba(255,255,255,0.18); font-family: ${F.cond}; font-weight: 700; font-size: ${o.fs ?? 17}px; letter-spacing: 0.14em; color: ${fg}; text-shadow: ${shadow}; white-space: nowrap${o.strike ? '; text-decoration: line-through; text-decoration-thickness: 2px; opacity: 0.5' : ''}">${esc(text)}</span>`;
}

// ---------- HUD (port of Main.dc.html at given values) ----------
function hud(s) {
  const W = 13;
  const name = s.programs[s.cur].name.toUpperCase().padEnd(W, ' ').slice(0, W);
  const n = s.programs.length;
  const prev = s.programs[(s.cur - 1 + n) % n].name.toUpperCase();
  const next = s.programs[(s.cur + 1) % n].name.toUpperCase();
  const e = s.programs[s.cur];
  const hasStat = e.val != null;
  const pipsLit = hasStat ? Math.round(Math.min(1, e.val / 10) * 10) : 0;
  const statText = hasStat ? String(e.val).padStart(2, '0') : '--';
  const pips = Array.from({ length: 10 }, (_, j) => `<span aria-hidden="true" style="display: block; width: 9px; height: ${(12 + j * 1.4).toFixed(1)}px; border-radius: 1px; ${j < pipsLit ? 'background: linear-gradient(180deg,#ffe0a0,#ff9a20); box-shadow: 0 0 6px rgba(255,150,40,0.8)' : 'background: #1e1b17; box-shadow: inset 0 1px 1px #000'}"></span>`).join('');
  // trace gauge
  const cx = 100, cy = 112;
  const pt = (deg, r) => { const a = deg * Math.PI / 180; return (cx + r * Math.sin(a)).toFixed(1) + ' ' + (cy - r * Math.cos(a)).toFixed(1); };
  let ticks = '';
  for (let i = 0; i <= 20; i++) { const d = -50 + i * 5; ticks += 'M' + pt(d, 88) + 'L' + pt(d, i % 5 === 0 ? 76 : 82); }
  const tFrac = Math.min(1, s.trace / 40);
  const red = 'M' + pt(28, 85) + 'A85 85 0 0 1 ' + pt(50, 85);
  const half = 'M' + pt(0, 90) + 'L' + pt(0, 70);
  const lampSty = (c, on, pos) => `<span aria-hidden="true" style="position: absolute; ${pos}">${lamp(c, on, 8)}</span>`;
  const nixie = (v, size, w) => {
    const str = String(v).padStart(3, '0');
    const first = v === 0 ? 2 : str.search(/[1-9]/);
    return str.split('').map((c, j) => `<span style="display: block; width: ${w}px; text-align: center; font-size: ${size}px; line-height: ${size + 4}px; font-weight: 500; ${j >= first ? 'color: #ffc27a; text-shadow: 0 0 3px #ff8a2a, 0 0 8px #ff5a00, 0 0 16px rgba(255,80,0,0.6)' : 'color: rgba(255,150,80,0.12)'}">${c}</span>`).join('');
  };
  const bandLit = s.bw > 0 ? Math.max(1, Math.round(s.bw / s.bwMax * 10)) : 0;
  const bars = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0].map((i) => { const col = i >= 8 ? '#ff3a2a' : i >= 6 ? '#ffb020' : '#4dff6e'; return `<span aria-hidden="true" style="display: block; width: 30px; height: 5px; border-radius: 1px; ${i < bandLit ? `background: ${col}; box-shadow: 0 0 5px ${col}` : 'background: #222; box-shadow: inset 0 1px 1px #000'}"></span>`; }).join('');
  const sLit = Math.min(12, s.shield);
  const ring = Array.from({ length: 12 }, (_, i) => { const a = (i / 12) * Math.PI * 2; const x = 52 + 46 * Math.sin(a) - 5, y = 52 - 46 * Math.cos(a) - 5; return `<span aria-hidden="true" style="position: absolute; left: ${x.toFixed(1)}px; top: ${y.toFixed(1)}px; width: 10px; height: 10px; border-radius: 50%; ${i < sLit ? 'background: radial-gradient(circle at 35% 35%,#fff 0,#66c6ff 45%,#0a3a66 100%); box-shadow: 0 0 7px #66c6ff' : 'background: radial-gradient(circle at 35% 35%,#2a3a4a,#0a121a); box-shadow: inset 0 1px 1px #000'}"></span>`; }).join('');
  const smallTile = (d, col) => `<span style="display: block; width: 12px; height: 18px; line-height: 18px; text-align: center; font-size: 14px; font-weight: 600; color: ${col}; border-radius: 2px; background: linear-gradient(180deg,#232323 0,#1a1a1a 49%,#000 49%,#000 53%,#121212 53%,#0c0c0c 100%)">${d}</span>`;
  const idx = String(s.cur + 1).padStart(2, '0'), tot = String(n).padStart(2, '0');
  const lowV = s.vitae <= 8, lowB = s.bw <= 1, lowS = s.shield === 0, hiT = s.trace >= 30, lowP = false;

  return `
<div style="width: 424px; box-sizing: border-box; padding: 18px 16px 16px; border-radius: 14px; background: ${T.bake}; border: 1px solid #1a110a; box-shadow: inset 0 1px 0 rgba(255,220,180,0.25), inset 0 -3px 6px rgba(0,0,0,0.5), 0 18px 40px rgba(0,0,0,0.55), 0 4px 10px rgba(0,0,0,0.4); display: flex; flex-direction: column; gap: 14px; font-family: ${F.cond}">
  <div style="display: flex; justify-content: space-between; align-items: baseline">
    <span style="font-size: 13px; font-weight: 700; letter-spacing: 0.32em; color: #e9963f">PROGRAM</span>
    <div role="img" aria-label="Program ${s.cur + 1} of ${n}" style="display: flex; align-items: center; gap: 3px">${idx.split('').map((d) => smallTile(d, '#f4efe4')).join('')}<span style="font-size: 13px; color: #c9b796; padding: 0 3px">of</span>${tot.split('').map((d) => smallTile(d, '#c9b796')).join('')}</div>
  </div>
  <div style="display: flex; gap: 10px; align-items: stretch">
    <div style="flex: 1; min-width: 0; position: relative; border-radius: 6px; padding: 6px 6px; background: ${T.glass}; box-shadow: inset 0 3px 8px rgba(0,0,0,0.95), 0 1px 0 rgba(255,220,180,0.2); border: 2px solid #e6dcc6; overflow: hidden">
      <div style="height: 26px; line-height: 26px; text-align: center; font-size: 15px; font-weight: 500; letter-spacing: 0.22em; color: #8d8578">${esc(prev)}</div>
      <div role="img" aria-label="Current program: ${esc(s.programs[s.cur].name)}" style="display: flex; justify-content: center; padding: 6px 0; border-top: 1px solid #2a2622; border-bottom: 1px solid #2a2622">${tiles(name, { w: 21, h: 40, fs: 26 }, 3)}</div>
      <div style="height: 26px; line-height: 26px; text-align: center; font-size: 15px; font-weight: 500; letter-spacing: 0.22em; color: #8d8578">${esc(next)}</div>
      <div aria-hidden="true" style="position: absolute; inset: 0; pointer-events: none; background: linear-gradient(180deg,rgba(10,9,8,0.92) 0%,rgba(10,9,8,0) 30%,rgba(10,9,8,0) 70%,rgba(10,9,8,0.92) 100%)"></div>
      <div aria-hidden="true" style="position: absolute; inset: 0; pointer-events: none; background: linear-gradient(115deg,rgba(255,255,255,0.10) 0%,rgba(255,255,255,0.02) 38%,rgba(255,255,255,0) 40%)"></div>
    </div>
    <div style="width: 44px; display: flex; flex-direction: column; border-radius: 6px; overflow: hidden; border: 1px solid #120c07; box-shadow: 0 2px 4px rgba(0,0,0,0.6)">
      <button type="button" aria-label="Previous program" style="flex: 1; min-height: 44px; border: 0; cursor: pointer; display: flex; align-items: center; justify-content: center; color: #2b1d12; background: linear-gradient(180deg,#f1e9d6,#d9cdb1); border-bottom: 1px solid #8f7f62"><svg aria-hidden="true" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M6 15l6-6 6 6"></path></svg></button>
      <button type="button" aria-label="Next program" style="flex: 1; min-height: 44px; border: 0; cursor: pointer; display: flex; align-items: center; justify-content: center; color: #2b1d12; background: linear-gradient(180deg,#d9cdb1,#c2b391)"><svg aria-hidden="true" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"></path></svg></button>
    </div>
  </div>
  <div role="img" aria-label="${hasStat ? esc(e.stat) + ' ' + e.val : 'No rating'}" style="display: flex; align-items: center; gap: 10px; padding: 8px 10px; border-radius: 6px; background: ${T.glass}; border: 2px solid #e6dcc6; box-shadow: inset 0 3px 8px rgba(0,0,0,0.95)">
    <span style="flex: 0 0 auto; max-width: 130px; white-space: nowrap; font-size: 16px; font-weight: 700; letter-spacing: 0.18em; ${hasStat ? 'color: #ffb85a; text-shadow: 0 0 6px rgba(255,140,40,0.55)' : 'color: #8d8578'}">${hasStat ? esc(e.stat.toUpperCase()) : 'NO RATING'}</span>
    <div style="flex: 1; min-width: 0; display: flex; gap: 3px; align-items: center; justify-content: center">${pips}</div>
    ${tiles(statText, { color: hasStat ? '#ffd08a' : '#8d8578' })}
  </div>
  <div aria-hidden="true" style="height: 2px; border-radius: 1px; background: linear-gradient(90deg,rgba(233,150,63,0),#e9963f 20%,#e9963f 80%,rgba(233,150,63,0))"></div>
  <div style="position: relative; padding: 14px 12px 12px; border-radius: 8px; background: linear-gradient(180deg,#2b2b29 0%,#1e1e1c 100%); border: 1px solid #0c0c0b; box-shadow: inset 0 1px 0 rgba(255,255,255,0.08), inset 0 -2px 4px rgba(0,0,0,0.6); display: flex; flex-direction: column; gap: 10px">
    ${screw('top: 4px; left: 4px')}${screw('top: 4px; right: 4px')}${screw('bottom: 4px; left: 4px')}${screw('bottom: 4px; right: 4px')}
    <div style="display: flex; gap: 10px; align-items: stretch">
      <div role="img" aria-label="Trace ${s.trace} of 40" style="position: relative; width: 212px; box-sizing: border-box; padding: 6px; display: flex; flex-direction: column; border-radius: 6px; background: linear-gradient(160deg,#cfcdc6,#8e8c85 45%,#b7b5ae 70%,#77756f); box-shadow: inset 0 1px 0 rgba(255,255,255,0.6), 0 2px 3px rgba(0,0,0,0.7)">
        <div style="position: relative; flex: 1; min-height: 112px; border-radius: 4px; overflow: hidden; background: radial-gradient(ellipse at 50% 100%,#fff3c9 0%,#f3d98f 45%,#c99a45 100%); box-shadow: inset 0 2px 6px rgba(0,0,0,0.55)">
          <svg aria-hidden="true" width="200" height="112" viewBox="0 0 200 112" style="position: absolute; left: 0; bottom: 0"><path d="${red}" fill="none" stroke="#b3261a" stroke-width="6"></path><path d="${ticks}" fill="none" stroke="#2a1d0e" stroke-width="1.4" stroke-linecap="round"></path><path d="${half}" stroke="#b3261a" stroke-width="2"></path><text x="22" y="62" font-size="9" fill="#2a1d0e" font-weight="700" font-family="Barlow Condensed">0</text><text x="170" y="62" font-size="9" fill="#8a1d12" font-weight="700" font-family="Barlow Condensed">40</text></svg>
          <span style="position: absolute; left: 10px; bottom: 6px; font-size: 13px; font-weight: 700; letter-spacing: 0.24em; color: #2a1d0e">TRACE</span>
          <span aria-hidden="true" style="position: absolute; left: 99px; bottom: 0; width: 2px; height: 92px; background: #1a1a1a; transform-origin: 1px 92px; transform: rotate(${(-50 + tFrac * 100).toFixed(1)}deg); box-shadow: 1px 1px 1px rgba(0,0,0,0.3)"></span>
          <span aria-hidden="true" style="position: absolute; left: 93px; bottom: -7px; width: 14px; height: 14px; border-radius: 50%; background: radial-gradient(circle at 35% 35%,#555,#0d0d0d)"></span>
          <div style="position: absolute; right: 8px; bottom: 5px; display: flex; gap: 1px; padding: 2px; border-radius: 2px; background: #0d0b08">${String(s.trace).padStart(3, '0').split('').map((d) => `<span style="display: block; width: 12px; height: 18px; line-height: 18px; text-align: center; font-size: 15px; font-weight: 600; color: #f6f1e6; background: linear-gradient(180deg,#000 0%,#2f2f2f 35%,#3a3a3a 50%,#2f2f2f 65%,#000 100%)">${d}</span>`).join('')}</div>
          <span aria-hidden="true" style="position: absolute; inset: 0; background: linear-gradient(120deg,rgba(255,255,255,0.35) 0%,rgba(255,255,255,0) 30%)"></span>
        </div>
        ${lampSty('#ff3a2a', hiT, 'top: 2px; right: 2px')}
      </div>
      <div role="img" aria-label="Vitae ${s.vitae} of 30" style="position: relative; width: 58px; box-sizing: border-box; padding: 6px 4px; border-radius: 6px; background: linear-gradient(180deg,#3a1c14,#1f0e09); box-shadow: inset 0 1px 0 rgba(255,200,170,0.15), 0 2px 3px rgba(0,0,0,0.7); display: flex; flex-direction: column; align-items: center; gap: 5px">
        <div style="display: flex; padding: 1px 3px; border-radius: 6px 6px 2px 2px; background: radial-gradient(ellipse at 50% 35%,#2a1710,#0b0604 75%); border: 1px solid #4b3d2c">${nixie(s.vitae, 13, 9)}</div>
        <div style="position: relative; width: 22px; height: 74px; border-radius: 4px 4px 11px 11px; background: rgba(255,255,255,0.07); border: 1.5px solid rgba(235,225,210,0.55); overflow: hidden; box-shadow: inset 0 0 4px rgba(0,0,0,0.8)">
          <span aria-hidden="true" style="position: absolute; left: 0; right: 0; bottom: 0; height: ${Math.round(s.vitae / 30 * 100)}%; background: linear-gradient(180deg,#ff6a5a 0,#d4180c 18%,#7a0804 100%); box-shadow: 0 0 10px rgba(255,40,20,0.8), inset 0 2px 0 rgba(255,190,170,0.7)"></span>
          <span aria-hidden="true" style="position: absolute; left: 3px; top: 0; bottom: 0; width: 3px; background: linear-gradient(180deg,rgba(255,255,255,0.45),rgba(255,255,255,0.1))"></span>
          <span aria-hidden="true" style="position: absolute; right: 0; top: 0; bottom: 0; width: 5px; background: repeating-linear-gradient(180deg,rgba(240,230,210,0.7) 0 1px,rgba(0,0,0,0) 1px 9px)"></span>
        </div>
        <span aria-hidden="true" style="color: #f0b8a8"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3.5c-2.5 4-5 6.7-5 9.8a5 5 0 0 0 10 0c0-3.1-2.5-5.8-5-9.8z"></path></svg></span>
        <span style="font-size: 10px; font-weight: 700; letter-spacing: 0.12em; color: #2a160c; padding: 1px 4px; border-radius: 2px; background: linear-gradient(180deg,#e6c47a,#b38a3c)">VITAE</span>
        ${lampSty('#ff3a2a', lowV, 'top: 4px; right: 4px')}
      </div>
      <div role="img" aria-label="Bandwidth ${s.bw} of ${s.bwMax}" style="position: relative; flex: 1; min-width: 0; box-sizing: border-box; padding: 6px 5px; border-radius: 6px; background: linear-gradient(180deg,#161616,#0b0b0b); border: 1px solid #000; box-shadow: inset 0 1px 0 rgba(255,255,255,0.08), 0 2px 3px rgba(0,0,0,0.7); display: flex; flex-direction: column; align-items: center; gap: 5px">
        <div style="padding: 1px 4px; border-radius: 2px; background: #2a0606; box-shadow: inset 0 1px 3px #000; font-size: 18px; line-height: 22px; font-weight: 600; letter-spacing: 0.08em; color: #ff4a3a; text-shadow: 0 0 4px #ff2a1a, 0 0 9px rgba(255,30,10,0.6)">${s.bw}/${s.bwMax}</div>
        <div style="display: flex; flex-direction: column; gap: 2px">${bars}</div>
        <span style="font-size: 10px; font-weight: 700; letter-spacing: 0.1em; color: #f2f2f2; margin-top: auto">BANDW</span>
        ${lampSty('#4dff6e', lowB, 'top: 4px; right: 4px')}
      </div>
    </div>
    <div style="display: flex; gap: 10px; align-items: stretch">
      <div role="img" aria-label="Shield ${s.shield}" style="position: relative; width: 150px; box-sizing: border-box; padding: 8px; border-radius: 6px; background: radial-gradient(circle at 50% 40%,#1d2a3d,#0d1520); border: 1px solid #05080d; box-shadow: inset 0 1px 0 rgba(180,210,255,0.12), 0 2px 3px rgba(0,0,0,0.7); display: flex; flex-direction: column; align-items: center; gap: 6px">
        <div style="position: relative; width: 104px; height: 104px">${ring}
          <div style="position: absolute; left: 24px; top: 24px; width: 56px; height: 56px; border-radius: 50%; box-sizing: border-box; padding: 3px; background: linear-gradient(145deg,#e9e6dc,#75736b 55%,#c8c5ba)">
            <div style="width: 50px; height: 50px; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 1px; background: radial-gradient(circle at 45% 35%,#0f1d2a,#050a10)">
              <span aria-hidden="true" style="color: #9fdcff"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2.5l8 3v6c0 5-3.5 8.5-8 10-4.5-1.5-8-5-8-10v-6z"></path></svg></span>
              <span style="font-size: 15px; line-height: 15px; font-weight: 600; color: #8ffff0; text-shadow: 0 0 4px #2affe0, 0 0 8px rgba(40,255,220,0.5)">${s.shield}</span>
            </div>
          </div>
        </div>
        <span style="font-size: 10px; font-weight: 700; letter-spacing: 0.2em; color: #0d1520; padding: 1px 6px; border-radius: 8px; background: #cfe3f2">SHIELD</span>
        ${lampSty('#66c6ff', lowS, 'top: 4px; right: 4px')}
      </div>
      <div role="img" aria-label="Incoming pulp ${s.pulp}" style="position: relative; flex: 1; min-width: 0; box-sizing: border-box; padding: 10px 10px 8px; border-radius: 6px; background: linear-gradient(170deg,#4a2c18,#2a170c); border: 1px solid #140a04; box-shadow: inset 0 1px 0 rgba(255,210,170,0.15), 0 2px 3px rgba(0,0,0,0.7); display: flex; flex-direction: column; gap: 8px">
        <div style="display: flex; gap: 5px; justify-content: center">${String(s.pulp).padStart(3, '0').split('').map((c, j, arr) => { const first = s.pulp === 0 ? 2 : arr.join('').search(/[1-9]/); return `<div style="position: relative; width: 38px; height: 58px; border-radius: 16px 16px 4px 4px; background: radial-gradient(ellipse at 50% 40%,#2c1810 0%,#0a0503 80%); border: 1px solid rgba(220,200,170,0.35); box-shadow: inset 0 0 8px rgba(255,110,30,0.2), 0 2px 3px rgba(0,0,0,0.7); display: flex; align-items: center; justify-content: center; overflow: hidden"><span style="font-size: 40px; line-height: 44px; font-weight: 500; ${j >= first ? 'color: #ffc27a; text-shadow: 0 0 3px #ff8a2a, 0 0 8px #ff5a00, 0 0 16px rgba(255,80,0,0.6)' : 'color: rgba(255,150,80,0.12)'}">${c}</span><span aria-hidden="true" style="position: absolute; inset: 0; background: repeating-linear-gradient(60deg,rgba(255,255,255,0.05) 0 1px,rgba(0,0,0,0) 1px 4px),repeating-linear-gradient(-60deg,rgba(255,255,255,0.05) 0 1px,rgba(0,0,0,0) 1px 4px),linear-gradient(105deg,rgba(255,255,255,0.18) 0%,rgba(255,255,255,0) 30%)"></span></div>`; }).join('')}</div>
        <div style="display: flex; align-items: center; gap: 8px">
          <div style="width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #f3e4c6; background: radial-gradient(circle at 40% 35%,#5a3a24,#1a0d06); box-shadow: 0 0 0 2px #0f0804, 0 0 0 3px rgba(230,190,140,0.35), 0 2px 3px rgba(0,0,0,0.7)"><svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><circle cx="12" cy="12" r="3.6" fill="currentColor"></circle><path d="M14.8 9.2L21 3M15.4 13.2l7 2.6M10.4 15.3L5 22M8.6 10.7L1.8 7.6M12 15.6V22.5M12.6 8.4L13.6 1.5"></path></svg></div>
          <svg aria-hidden="true" width="64" height="12" viewBox="0 0 64 12"><path d="M0 6h64" stroke="#b9b2a3" stroke-width="1.2"></path><rect x="18" y="1.5" width="28" height="9" rx="4.5" fill="#d9c39a"></rect><rect x="22" y="1.5" width="2.5" height="9" fill="#e07a10"></rect><rect x="27" y="1.5" width="2.5" height="9" fill="#111"></rect><rect x="32" y="1.5" width="2.5" height="9" fill="#7a4a1a"></rect><rect x="39" y="1.5" width="2.5" height="9" fill="#c9a23a"></rect></svg>
          <span style="margin-left: auto; text-align: right; line-height: 1.05"><span style="display: block; font-size: 12px; font-weight: 700; letter-spacing: 0.24em; color: #f0dcb8">PULP</span><span style="display: block; font-size: 10px; font-weight: 600; letter-spacing: 0.18em; color: #b8957a">INCOMING</span></span>
        </div>
        ${lampSty('#ff8a2a', lowP, 'top: 4px; right: 4px')}
      </div>
    </div>
  </div>
</div>`;
}

// ---------- backdrop ----------
function backdrop(hostile) {
  const sky = hostile ? 'radial-gradient(120% 80% at 50% 38%,#4a1814 0%,#260b09 55%,#120504 100%)' : 'radial-gradient(120% 80% at 50% 38%,#f6fbf7 0%,#d6eee4 40%,#a9d6c6 75%,#7fb8a6 100%)';
  const sun = hostile ? 'repeating-conic-gradient(from 0deg at 50% 46%, rgba(255,70,40,0.22) 0deg 3deg, rgba(0,0,0,0) 3deg 12deg)' : 'repeating-conic-gradient(from 0deg at 50% 46%, rgba(255,255,255,0.55) 0deg 3deg, rgba(255,255,255,0) 3deg 12deg)';
  const tileBg = hostile ? '#2a0d0a' : '#ffffff';
  const tileInk = hostile ? '#ff6a50' : '#2f5d52';
  const tileSub = hostile ? '#ffb4a4' : '#6c8f86';
  const t = hostile
    ? [['LIVING ROOM', '31°', 'Do not adjust'], ['FRONT DOOR', 'Sealed', 'Doors will not open'], ['DOORBELL', '1 VISITOR', 'YOU'], ['LIGHTS', 'ALL ON', 'Stay where we can see you'], ['HOMESENSE™', '1 intruder', 'Someone is home']]
    : [['LIVING ROOM', '21°', 'Comfort Score™ 96'], ['FRONT DOOR', 'Locked', 'HALCYON Welcome™'], ['DOORBELL', 'No visitors', 'today'], ['LIGHTS', '6 on', 'Evening scene'], ['HOMESENSE™', 'Everyone', 'is home']];
  const pos = [[150, 330], [150, 520], [1290, 300], [1290, 490], [1290, 680]];
  const cards = t.map(([a, b, c], i) => `<div style="position: absolute; left: ${pos[i][0]}px; top: ${pos[i][1]}px; width: 200px; height: 150px; box-sizing: border-box; padding: 18px; border-radius: 26px; background: ${tileBg}; box-shadow: 0 10px 30px rgba(0,0,0,0.15)"><div style="font-family: ${F.sans}; font-size: 13px; letter-spacing: 0.12em; color: ${tileSub}">${a}</div><div style="font-family: ${F.deco}; font-size: 44px; color: ${tileInk}; margin-top: 8px">${b}</div><div style="font-family: ${F.sans}; font-size: 14px; color: ${tileSub}">${c}</div></div>`).join('');
  return `
  <div style="position: absolute; inset: 0; background: ${sky}"></div>
  <div style="position: absolute; inset: 0; background: ${sun}"></div>
  <div style="position: absolute; left: 610px; top: 150px; width: 380px; height: 560px; border-radius: 190px 190px 0 0; background: ${hostile ? 'linear-gradient(180deg,#5a1a12,#1a0605)' : 'linear-gradient(180deg,#ffffff,#cfe9df)'}; box-shadow: 0 0 0 14px ${hostile ? '#6a2a20' : '#e9f4f0'}, 0 0 0 18px ${hostile ? '#a3392a' : '#b9cfc8'}"></div>
  <div style="position: absolute; left: 700px; top: 290px; width: 200px; height: 420px; border-radius: 100px 100px 0 0; background: ${hostile ? '#0c0202' : 'linear-gradient(180deg,#9fd1c1,#6ea898)'}"></div>
  <div style="position: absolute; left: 0; right: 0; top: 0; text-align: center; padding-top: 70px; font-family: ${F.deco}; font-size: 96px; color: ${hostile ? '#ff5a3c' : '#2f5d52'}">${hostile ? 'We see you.' : 'Good morning.'}</div>
  <div style="position: absolute; left: 0; right: 0; top: 200px; text-align: center; font-family: ${F.deco}; font-size: 36px; letter-spacing: 0.1em; color: ${hostile ? '#c24030' : '#4f8f7f'}">halcyon home</div>
  ${cards}
  <div style="position: absolute; left: 0; right: 0; bottom: 0; height: 330px; background: ${hostile ? 'linear-gradient(180deg,#2a0a07,#0c0302)' : 'linear-gradient(180deg,#cfe6dc,#9cc6b7)'}"></div>
  <div style="position: absolute; left: 0; right: 0; bottom: 0; height: 330px; background: repeating-linear-gradient(90deg, rgba(255,255,255,0.18) 0 2px, rgba(0,0,0,0) 2px 120px); transform: perspective(500px) rotateX(55deg); transform-origin: 50% 0"></div>`;
}

// ---------- mascots (svg art; text kept out) ----------
function captchaArt(mood) {
  const lethal = mood === 'lethal';
  const body = lethal ? '#111' : '#ffffff';
  const edge = lethal ? '#d8321f' : '#c9ddd6';
  const box = lethal ? '#1b1b1b' : '#e9f6f1';
  const eye = lethal
    ? `<ellipse cx="62" cy="84" rx="24" ry="24" fill="#2a0604"></ellipse><ellipse cx="62" cy="84" rx="20" ry="5" fill="#ff3a22"></ellipse><ellipse cx="62" cy="84" rx="3" ry="4.5" fill="#160000"></ellipse>`
    : `<ellipse cx="62" cy="84" rx="22" ry="22" fill="#fff"></ellipse><circle cx="65" cy="86" r="12" fill="#4fae96"></circle><circle cx="66" cy="87" r="6" fill="#123a32"></circle><circle cx="61" cy="81" r="3.5" fill="#fff"></circle>`;
  return `<svg aria-hidden="true" width="200" height="170" viewBox="0 0 200 170">
    ${lethal ? '<rect x="14" y="40" width="172" height="96" rx="18" fill="#ff2a12" opacity="0.35" filter="blur(8px)"></rect>' : ''}
    <ellipse cx="100" cy="156" rx="70" ry="8" fill="rgba(0,0,0,0.18)"></ellipse>
    <rect x="20" y="44" width="164" height="88" rx="16" fill="${body}" stroke="${edge}" stroke-width="3"></rect>
    <rect x="34" y="56" width="56" height="56" rx="10" fill="${box}" stroke="${lethal ? '#d8321f' : '#9fd1c1'}" stroke-width="3"></rect>
    ${eye}
    ${lethal ? '<path d="M38 64l18 8M86 64l-18 8" stroke="#ff3a22" stroke-width="4" stroke-linecap="round"></path>' : '<path d="M44 60q18-10 36 0" stroke="#4f8f7f" stroke-width="3" fill="none" stroke-linecap="round"></path>'}
    <rect x="102" y="66" width="62" height="7" rx="3.5" fill="${lethal ? '#3a3a3a' : '#dbe9e4'}"></rect>
    <rect x="102" y="80" width="46" height="7" rx="3.5" fill="${lethal ? '#3a3a3a' : '#dbe9e4'}"></rect>
    <circle cx="160" cy="112" r="9" fill="none" stroke="${lethal ? '#d8321f' : '#9fd1c1'}" stroke-width="3"></circle><path d="M160 103a9 9 0 0 1 9 9" stroke="${lethal ? '#ff6a50' : '#4fae96'}" stroke-width="3" fill="none"></path>
    ${lethal ? '' : '<circle cx="44" cy="106" r="5" fill="#ffb3a6" opacity="0.7"></circle><circle cx="80" cy="106" r="5" fill="#ffb3a6" opacity="0.7"></circle>'}
    <path d="M70 132l-10 18M130 132l10 18" stroke="${lethal ? '#555' : '#b9c0c2'}" stroke-width="5" stroke-linecap="round"></path>
  </svg>`;
}
function autoRenewArt(mood) {
  const wary = mood === 'wary';
  return `<svg aria-hidden="true" width="200" height="170" viewBox="0 0 200 170">
    <ellipse cx="100" cy="158" rx="66" ry="8" fill="rgba(0,0,0,0.18)"></ellipse>
    <rect x="38" y="30" width="124" height="124" rx="16" fill="#ffffff" stroke="#c9ddd6" stroke-width="3"></rect>
    <rect x="38" y="30" width="124" height="34" rx="16" fill="#e46a55"></rect><rect x="38" y="50" width="124" height="14" fill="#e46a55"></rect>
    <rect x="62" y="20" width="10" height="24" rx="5" fill="#b9c0c2"></rect><rect x="128" y="20" width="10" height="24" rx="5" fill="#b9c0c2"></rect>
    <circle cx="80" cy="96" r="${wary ? 6 : 7}" fill="#173b33"></circle><circle cx="120" cy="96" r="${wary ? 6 : 7}" fill="#173b33"></circle>
    ${wary ? '<path d="M68 84l20 5M132 84l-20 5" stroke="#173b33" stroke-width="4" stroke-linecap="round"></path><path d="M84 126h32" stroke="#173b33" stroke-width="4" stroke-linecap="round"></path>' : '<circle cx="82" cy="94" r="2.4" fill="#fff"></circle><circle cx="122" cy="94" r="2.4" fill="#fff"></circle><path d="M80 118q20 18 40 0" stroke="#173b33" stroke-width="4" fill="none" stroke-linecap="round"></path><circle cx="66" cy="114" r="6" fill="#ffb3a6" opacity="0.7"></circle><circle cx="134" cy="114" r="6" fill="#ffb3a6" opacity="0.7"></circle>'}
    <path d="M150 140a22 22 0 1 0-6 10" stroke="#4fae96" stroke-width="5" fill="none" stroke-linecap="round"></path><path d="M152 132l-6 12 12 0z" fill="#4fae96"></path>
  </svg>`;
}

// ---------- ICE console ----------
function breakKey(cost, disabled) {
  return `<button type="button" aria-label="Break, ${cost}" style="flex: 0 0 auto; display: flex; flex-direction: column; align-items: center; justify-content: center; width: 54px; height: 40px; border: 0; padding: 0; border-radius: 7px; cursor: pointer; font-family: ${F.cond}; color: #3a2a18; background: ${T.creamGrad}; box-shadow: inset 0 1px 0 rgba(255,255,255,0.9), 0 3px 0 #a8987a, 0 4px 6px rgba(0,0,0,0.35)${disabled ? '; opacity: 0.35' : ''}"><span style="font-size: 12px; font-weight: 700; letter-spacing: 0.16em; line-height: 13px">BREAK</span><span style="font-size: 11px; font-weight: 600; letter-spacing: 0.08em; color: #7a6040; line-height: 12px">${cost}</span></button>`;
}
function deadlockButton(broken) {
  const cap = broken ? 'radial-gradient(circle at 40% 30%,#9ee6b8,#3c9a62 60%,#1c5a36)' : 'radial-gradient(circle at 40% 30%,#ff8a6a,#d8321f 55%,#7a1208)';
  return `<button type="button" aria-label="${broken ? 'Deadlock broken' : 'Deadlock'}" style="flex: 0 0 auto; position: relative; width: 54px; height: 54px; border: 0; padding: 0; border-radius: 50%; cursor: pointer; background: ${T.chrome}; box-shadow: 0 3px 6px rgba(0,0,0,0.4), inset 0 1px 0 #fff">
    <span aria-hidden="true" style="position: absolute; left: 6px; top: ${broken ? 9 : 5}px; width: 42px; height: 42px; border-radius: 50%; background: ${cap}; box-shadow: ${broken ? 'inset 0 2px 4px rgba(0,0,0,0.5)' : '0 4px 0 #6a1006, 0 6px 8px rgba(0,0,0,0.4), inset 0 2px 2px rgba(255,255,255,0.5)'}; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,0.92)">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="11" width="14" height="10" rx="2"></rect><path d="${broken ? 'M8 11V7a4 4 0 0 1 7.5-2' : 'M8 11V7a4 4 0 0 1 8 0v4'}"></path></svg>
    </span></button>`;
}
function subRow(r) {
  // r: {slot, text, caption, kind: 'normal'|'deadlock'|'broken'|'big', cost}
  const lampColor = r.kind === 'big' ? '#ff3a2a' : r.kind === 'deadlock' ? '#ffb020' : '#4dff6e';
  const lampOn = r.kind !== 'broken';
  const tape = r.kind === 'deadlock' ? dymo(r.text, 'red') : r.kind === 'broken' ? dymo(r.text, 'black', { strike: true }) : r.kind === 'big' ? dymo(r.text, 'red') : dymo(r.text, 'black');
  return `<div style="display: flex; align-items: center; gap: 10px; min-height: 44px">
    <span style="flex: 0 0 auto; width: 26px; font-family: ${F.cond}; font-size: 12px; font-weight: 700; letter-spacing: 0.12em; color: #2f5d52">${r.slot}</span>
    ${lamp(r.kind === 'big' ? '#ff3a2a' : lampColor, lampOn && r.kind !== 'normal' ? true : r.kind === 'normal', 10)}
    <div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 3px; align-items: flex-start">${tape}${r.caption ? `<span style="font-family: ${F.sans}; font-size: 12px; color: #2f5d52${r.kind === 'broken' ? '; opacity: 0.6' : ''}">${esc(r.caption)}</span>` : ''}</div>
    ${r.kind === 'deadlock' ? deadlockButton(false) : r.kind === 'broken' ? `<span style="flex: 0 0 auto; width: 54px; text-align: center; font-family: ${F.cond}; font-size: 12px; font-weight: 700; letter-spacing: 0.16em; color: #2f5d52">BROKEN</span>` : breakKey(r.cost ?? '1 BW')}
  </div>`;
}
function plate(text) {
  return `<div style="align-self: center; padding: 3px 10px; border-radius: 3px; background: linear-gradient(180deg,#e9ecec,#b9c0c2); box-shadow: inset 0 1px 0 #fff, 0 1px 2px rgba(0,0,0,0.3); font-family: ${F.sans}; font-size: 9px; letter-spacing: 0.12em; color: #4a5355; white-space: nowrap">${esc(text)}</div>`;
}
function iceConsole(o) {
  // o: {name, role, type, str, strDelta, art, bubble, mood, rows (html), passive:{name, rule, on}, plateText, lever, pixel, deadlocks}
  const lethal = o.mood === 'lethal';
  const strCol = o.strDelta && o.strDelta.startsWith('↓') ? '#8ffff0' : o.strDelta ? '#ffd08a' : '#f8f5ee';
  return `
<div style="position: relative; width: 490px; box-sizing: border-box; padding: 4px; border-radius: 34px 34px 18px 18px; background: ${T.chrome}; box-shadow: 0 22px 44px rgba(0,0,0,0.38), 0 6px 12px rgba(0,0,0,0.2)${lethal ? ', 0 0 40px rgba(255,40,20,0.55)' : ''}">
  <div style="position: relative; box-sizing: border-box; height: 100%; padding: 18px 20px 14px; border-radius: 30px 30px 14px 14px; background: ${T.mint}; box-shadow: inset 0 2px 0 rgba(255,255,255,0.7), inset 0 -4px 10px rgba(30,80,70,0.25); display: flex; flex-direction: column; gap: 12px">
    <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px">
      <div style="padding: 5px; border-radius: 8px; background: ${T.glass}; box-shadow: inset 0 2px 5px #000, 0 1px 0 rgba(255,255,255,0.6)">${tiles(o.name, { w: 22, h: 34, fs: 24 }, 2)}</div>
      <div role="img" aria-label="Strength ${o.str}" style="display: flex; align-items: center; gap: 6px; padding: 5px 6px 5px 10px; border-radius: 8px; background: ${T.glass}; box-shadow: inset 0 2px 5px #000, 0 1px 0 rgba(255,255,255,0.6)">
        <span style="font-family: ${F.cond}; font-size: 13px; font-weight: 700; letter-spacing: 0.22em; color: #e9963f">STR</span>
        ${tiles(String(o.str).padStart(2, '0'), { w: 22, h: 34, fs: 24, color: strCol }, 2)}
        ${o.strDelta ? `<span style="font-family: ${F.cond}; font-size: 15px; font-weight: 700; color: ${strCol}; padding-left: 2px">${o.strDelta}</span>` : ''}
      </div>
    </div>
    <div style="display: flex; align-items: center; justify-content: space-between">
      <span style="font-family: ${F.cond}; font-size: 14px; font-weight: 700; letter-spacing: 0.26em; color: #2f5d52">${o.type}</span>
      <span style="font-family: ${F.cond}; font-size: 11px; font-weight: 700; letter-spacing: 0.24em; color: #eaf6f1; padding: 3px 9px; border-radius: 10px; background: #3f7f70">${o.role}</span>
    </div>
    <div style="display: flex; gap: 16px; align-items: stretch">
      <div style="position: relative; flex: 0 0 auto; width: 190px">
        <div style="position: relative; width: 190px; height: 190px; box-sizing: border-box; border-radius: 50%; padding: 6px; background: ${T.chrome}; box-shadow: 0 4px 10px rgba(0,0,0,0.25)">
          <div style="position: relative; width: 178px; height: 178px; border-radius: 50%; overflow: hidden; background: ${lethal ? 'radial-gradient(circle at 50% 40%,#3a0c08,#0c0202)' : 'radial-gradient(circle at 50% 40%,#fbfffd,#cfe9df 70%,#a9d6c6)'}; box-shadow: inset 0 4px 14px rgba(0,0,0,0.35)">
            <div style="position: absolute; left: -11px; top: 4px; ${o.pixel ? 'filter: url(#px3)' : ''}">${o.art}${o.pixel ? ditherOverlay(200, 170) : ''}</div>
            <span aria-hidden="true" style="position: absolute; inset: 0; border-radius: 50%; background: linear-gradient(135deg,rgba(255,255,255,0.55) 0%,rgba(255,255,255,0) 35%)"></span>
          </div>
        </div>
        <div style="position: absolute; left: 8px; top: 8px; width: 174px; box-sizing: border-box; text-align: center; padding: 7px 10px; border-radius: 14px 14px 14px 4px; background: ${lethal ? '#111' : '#fff'}; box-shadow: 0 6px 14px rgba(0,0,0,0.22); font-family: ${F.sans}; font-size: 13px; line-height: 17px; font-weight: ${lethal ? 700 : 500}; color: ${lethal ? '#ff5a3c' : '#24463e'}; letter-spacing: ${lethal ? '0.06em' : '0'}">${esc(o.bubble)}</div>
        ${o.sticker ? `<div style="position: absolute; left: 4px; bottom: 6px; padding: 5px 9px; border-radius: 12px; transform: rotate(-8deg); background: #ffd34d; box-shadow: 0 2px 4px rgba(0,0,0,0.25); font-family: ${F.sans}; font-size: 11px; font-weight: 700; color: #3a2a06">${esc(o.sticker)}</div>` : ''}
      </div>
      <div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px; justify-content: center">${o.rows}</div>
    </div>
    <div style="display: flex; align-items: center; gap: 10px; padding: 9px 12px; border-radius: 10px; background: rgba(255,255,255,0.45); box-shadow: inset 0 1px 2px rgba(30,80,70,0.25)">
      ${lamp('#ffb020', o.passive.on, 12)}
      <span style="font-family: ${F.cond}; font-size: 15px; font-weight: 700; letter-spacing: 0.2em; color: #24463e">${o.passive.name}</span>
      <span style="font-family: ${F.sans}; font-size: 13px; color: #2f5d52">${esc(o.passive.rule)}</span>
      ${o.deadlocks ? `<span style="margin-left: auto; display: flex; align-items: center; gap: 5px; font-family: ${F.cond}; font-size: 11px; font-weight: 700; letter-spacing: 0.16em; color: #2f5d52">LOCKS ${o.deadlocks.map((d) => lamp(d ? '#4dff6e' : '#ff3a2a', true, 9)).join('')}</span>` : ''}
    </div>
    ${plate(o.plateText)}
  </div>
  ${o.lever ? `<div aria-hidden="true" style="position: absolute; right: -22px; top: 170px; width: 22px; height: 70px; border-radius: 0 10px 10px 0; background: ${T.chromeSide}; box-shadow: 2px 3px 6px rgba(0,0,0,0.3)"></div><div aria-hidden="true" style="position: absolute; right: -14px; top: 92px; width: 7px; height: 100px; border-radius: 4px; background: ${T.chromeSide}"></div><div aria-hidden="true" style="position: absolute; right: -22px; top: 74px; width: 24px; height: 24px; border-radius: 50%; background: radial-gradient(circle at 35% 35%,#ff9a80,#d8321f 55%,#7a1208); box-shadow: 0 3px 6px rgba(0,0,0,0.4)"></div>` : ''}
</div>`;
}
// Tumbler reel bank: pool above/below dim, active slots bright
function tumblerBank(above, slots, below) {
  const dimRow = (t) => `<div style="height: 22px; display: flex; align-items: center; padding-left: 36px; font-family: ${F.cond}; font-size: 14px; font-weight: 600; letter-spacing: 0.2em; color: #6f8a83">${esc(t)}</div>`;
  return `<div style="position: relative; border-radius: 10px; padding: 4px 10px; background: rgba(255,255,255,0.5); box-shadow: inset 0 2px 6px rgba(30,80,70,0.35); overflow: hidden">
    ${dimRow(above)}
    <div style="border-top: 1px solid rgba(47,93,82,0.25); border-bottom: 1px solid rgba(47,93,82,0.25); padding: 4px 0; display: flex; flex-direction: column; gap: 4px">${slots.map(subRow).join('')}</div>
    ${dimRow(below)}
    <div aria-hidden="true" style="position: absolute; inset: 0; pointer-events: none; background: linear-gradient(180deg,rgba(185,224,209,0.9) 0%,rgba(185,224,209,0) 22%,rgba(185,224,209,0) 78%,rgba(185,224,209,0.9) 100%)"></div>
  </div>`;
}
function ditherOverlay(w, h) {
  return `<svg aria-hidden="true" width="${w}" height="${h}" style="position: absolute; left: 0; top: 0; pointer-events: none"><rect width="${w}" height="${h}" fill="url(#bayer)"></rect></svg>`;
}

// ---------- cards ----------
const typeFace = { SCRIPT: ['#7a5536', '#3e2a1a'], PROGRAM: ['#6e7238', '#3a3d1c'], PROTOCOL: ['#2f6f6a', '#163b38'] };
function card(c) {
  const [a, b] = typeFace[c.kind];
  return `<div style="position: relative; width: 204px; height: 300px; box-sizing: border-box; border-radius: 16px 16px 8px 8px; padding: 10px; background: linear-gradient(180deg,${a},${b}); box-shadow: inset 0 1px 0 rgba(255,255,255,0.25), inset 0 -2px 0 rgba(0,0,0,0.4), 0 10px 22px rgba(0,0,0,0.45); display: flex; flex-direction: column; gap: 8px; font-family: ${F.cond}">
    <div aria-hidden="true" style="position: absolute; left: 60px; right: 60px; top: 6px; height: 10px; border-radius: 3px; background: repeating-linear-gradient(90deg,rgba(0,0,0,0.35) 0 2px,rgba(255,255,255,0.12) 2px 5px)"></div>
    <div style="display: flex; justify-content: space-between; align-items: flex-start; padding-top: 8px">
      <div role="img" aria-label="Cost ${c.bw} BW" style="width: 42px; height: 42px; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; background: ${T.chrome}; box-shadow: 0 2px 4px rgba(0,0,0,0.5), inset 0 1px 0 #fff"><span style="font-size: 22px; line-height: 20px; font-weight: 700; color: #1f1a14">${c.bw}</span><span style="font-size: 9px; font-weight: 700; letter-spacing: 0.14em; color: #5a5048">BW</span></div>
      <div style="display: flex; gap: 4px">${(c.icons || []).map((ic) => `<span style="height: 20px; padding: 0 6px; display: flex; align-items: center; border-radius: 10px; background: rgba(0,0,0,0.35); font-size: 11px; font-weight: 700; letter-spacing: 0.12em; color: #efe6d2">${ic}</span>`).join('')}</div>
    </div>
    ${cardGlyph(c.glyph)}
    <div style="flex: 1; display: flex; flex-direction: column; gap: 4px; padding: 10px 11px; border-radius: 6px; background: linear-gradient(180deg,#f6efdf,#e6dac0); box-shadow: inset 0 1px 0 #fff, 0 1px 2px rgba(0,0,0,0.4)">
      <span style="font-size: 21px; line-height: 22px; font-weight: 700; letter-spacing: 0.04em; color: #1f1a14">${esc(c.name)}</span>
      <span style="font-size: 11px; font-weight: 700; letter-spacing: 0.16em; color: #7a6040">${esc(c.type)}</span>
      <span style="font-family: ${F.sans}; font-size: 13px; line-height: 17px; color: #2a2118; margin-top: 4px">${esc(c.text)}</span>
    </div>
    <div aria-hidden="true" style="height: 12px; margin: 0 14px; border-radius: 2px; background: repeating-linear-gradient(90deg,#e6c06a 0 7px,rgba(0,0,0,0) 7px 11px)"></div>
  </div>`;
}
function hand(cards, overlapPct, hovered, cx) {
  const n = cards.length, w = 204;
  const step = w * (1 - overlapPct);
  const total = step * (n - 1) + w;
  const left0 = cx - total / 2;
  const span = Math.min(20, 4 * (n - 1));
  return cards.map((c, i) => {
    const ang = n > 1 ? -span / 2 + (span * i) / (n - 1) : 0;
    const lift = i === hovered ? -40 : Math.abs(ang) * 2.2;
    return `<div style="position: absolute; left: ${(left0 + i * step).toFixed(0)}px; top: ${(696 + lift).toFixed(0)}px; transform: rotate(${i === hovered ? 0 : ang.toFixed(1)}deg); transform-origin: 50% 120%; z-index: ${i === hovered ? 30 : 10 + i}">${card(c)}</div>`;
  }).join('');
}

// ---------- top bar, response board, end turn, note ----------
function topBar(s) {
  const strikes = [0, 1, 2].map((i) => lamp('#ff3a2a', i < s.strikes, 14)).join('');
  return `
<div style="position: absolute; left: 480px; top: 28px; right: 28px; display: flex; align-items: center; gap: 18px">
  <div style="display: flex; align-items: center; gap: 14px; padding: 10px 16px 10px 12px; border-radius: 12px; background: ${T.bake}; border: 1px solid #1a110a; box-shadow: inset 0 1px 0 rgba(255,220,180,0.25), 0 10px 24px rgba(0,0,0,0.35)">
    <span style="font-family: ${F.cond}; font-size: 12px; font-weight: 700; letter-spacing: 0.32em; color: #e9963f; writing-mode: vertical-rl; transform: rotate(180deg)">NODE</span>
    <div style="padding: 5px; border-radius: 6px; background: ${T.glass}; border: 2px solid #e6dcc6; box-shadow: inset 0 3px 8px #000">${tiles('CAPTCHA', { w: 26, h: 42, fs: 30 }, 3)}</div>
    <div style="display: flex; flex-direction: column; gap: 4px; font-family: ${F.cond}">
      <span style="font-size: 18px; font-weight: 700; letter-spacing: 0.24em; color: #f4ecda">HALCYON</span>
      <span style="font-size: 13px; font-weight: 600; letter-spacing: 0.2em; color: #c9b796">TIER 1 · LAYER 1/1</span>
    </div>
  </div>
  <div style="margin-left: auto; display: flex; align-items: center; gap: 22px; padding: 10px 18px; border-radius: 12px; background: ${T.bake}; border: 1px solid #1a110a; box-shadow: inset 0 1px 0 rgba(255,220,180,0.25), 0 10px 24px rgba(0,0,0,0.35); font-family: ${F.cond}">
    <div style="display: flex; align-items: center; gap: 8px"><span style="font-size: 12px; font-weight: 700; letter-spacing: 0.28em; color: #e9963f">TURN</span>${tiles(String(s.turn).padStart(2, '0'), { w: 22, h: 34, fs: 24 }, 2)}</div>
    <div aria-hidden="true" style="width: 1px; align-self: stretch; background: rgba(255,220,180,0.18)"></div>
    <div role="img" aria-label="Strikes ${s.strikes} of 3" style="display: flex; align-items: center; gap: 8px"><span style="font-size: 12px; font-weight: 700; letter-spacing: 0.28em; color: #e9963f">STRIKES</span><div style="display: flex; gap: 6px; padding: 6px 8px; border-radius: 12px; background: #0a0908; box-shadow: inset 0 2px 4px #000">${strikes}</div></div>
    <div aria-hidden="true" style="width: 1px; align-self: stretch; background: rgba(255,220,180,0.18)"></div>
    <div role="img" aria-label="CRED reserve ${s.reserve} of 15" style="display: flex; align-items: center; gap: 8px"><span style="font-size: 12px; font-weight: 700; letter-spacing: 0.28em; color: #e9963f">RESERVE</span>${tiles(String(s.reserve).padStart(2, '0'), { w: 22, h: 34, fs: 24, color: '#ffd08a' }, 2)}<span style="font-size: 14px; font-weight: 600; color: #c9b796">/ 15 CRED</span></div>
  </div>
</div>`;
}
function flapChip(text, big, src) {
  return `<div style="display: flex; flex-direction: column; align-items: center; gap: 4px">
    <span style="position: relative; display: block; padding: 0 12px; height: 34px; line-height: 34px; border-radius: 5px; background: ${flipBg}; box-shadow: inset 0 1px 0 rgba(255,255,255,0.18), 0 2px 3px rgba(0,0,0,0.8); font-family: ${F.cond}; font-size: 20px; font-weight: 700; letter-spacing: 0.1em; color: ${big ? '#ff5a3c' : '#f8f5ee'}; ${big ? 'text-shadow: 0 0 8px rgba(255,60,30,0.6)' : ''}; white-space: nowrap">${esc(text)}</span>
    <span style="font-family: ${F.cond}; font-size: 10px; font-weight: 700; letter-spacing: 0.2em; color: #a8987a">${src}</span>
  </div>`;
}
function responseBoard(items) {
  return `<div style="position: absolute; left: 500px; top: 562px; width: 560px; box-sizing: border-box; display: flex; align-items: center; gap: 16px; padding: 10px 18px; border-radius: 12px; background: linear-gradient(180deg,#1e1d1b,#121110); border: 2px solid #e6dcc6; box-shadow: 0 12px 26px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.08)">
    <span style="font-family: ${F.cond}; font-size: 13px; font-weight: 700; letter-spacing: 0.28em; line-height: 16px; color: #ffb85a; text-shadow: 0 0 6px rgba(255,140,40,0.5)">NEXT<br>RESPONSE</span>
    <svg aria-hidden="true" width="14" height="14" viewBox="0 0 24 24" fill="#ffb85a"><path d="M8 5l10 7-10 7z"></path></svg>
    <div style="display: flex; gap: 8px; align-items: flex-start">${items.map((it) => flapChip(it[0], it[1], it[2])).join('')}</div>
  </div>`;
}
function note(lines) {
  return `<div style="position: absolute; left: 1084px; top: 556px; width: 226px; box-sizing: border-box; padding: 16px 16px 14px; transform: rotate(-2deg); background: #f7f3e8; box-shadow: 4px 4px 0 #111; font-family: ${F.mono}; font-size: 13px; line-height: 19px; color: #111">
    <span aria-hidden="true" style="position: absolute; left: 70px; top: -10px; width: 90px; height: 20px; transform: rotate(3deg); background: rgba(240,230,170,0.75)"></span>
    <span style="display: block; font-size: 10px; letter-spacing: 0.2em; margin-bottom: 6px">NUL/REM</span>
    ${lines.map((l) => `<span style="display: block; background: ${l.hl ? '#fff36a' : 'transparent'}; ${l.leak ? 'color: #4f8f7f; font-family: ' + F.sans + '; font-style: italic' : ''}">${esc(l.t)}</span>`).join('')}
  </div>`;
}
function endTurn(s) {
  return `<div style="position: absolute; right: 28px; top: 550px; box-sizing: border-box; padding: 12px 14px; border-radius: 14px; background: ${T.bake}; border: 1px solid #1a110a; box-shadow: inset 0 1px 0 rgba(255,220,180,0.25), 0 14px 30px rgba(0,0,0,0.5); display: flex; align-items: center; gap: 14px; font-family: ${F.cond}; z-index: 40">
    <div style="display: flex; flex-direction: column; gap: 8px">
      <div style="display: flex; align-items: center; justify-content: space-between; gap: 8px"><span style="font-size: 11px; font-weight: 700; letter-spacing: 0.26em; color: #e9963f">DECK</span>${tiles(String(s.deck).padStart(2, '0'), { w: 20, h: 30, fs: 22 }, 2)}</div>
      <div style="display: flex; align-items: center; justify-content: space-between; gap: 8px"><span style="font-size: 11px; font-weight: 700; letter-spacing: 0.26em; color: #e9963f">DISCARD</span>${tiles(String(s.discard).padStart(2, '0'), { w: 20, h: 30, fs: 22, color: '#c9b796' }, 2)}</div>
      <button type="button" style="display: flex; align-items: center; gap: 7px; height: 26px; padding: 0 10px; border: 0; border-radius: 6px; cursor: pointer; background: #1a110a; box-shadow: inset 0 1px 3px #000; font-family: ${F.cond}; font-size: 11px; font-weight: 700; letter-spacing: 0.24em; color: #e9a090">${lamp('#d8321f', false, 7)}END RUN</button>
    </div>
    <div style="position: relative; width: 112px; height: 112px; border-radius: 50%; box-sizing: border-box; padding: 7px; background: ${T.chrome}; box-shadow: 0 6px 14px rgba(0,0,0,0.5), 0 0 0 4px rgba(255,170,60,0.25), 0 0 22px rgba(255,150,40,0.45)">
      <button type="button" style="width: 98px; height: 98px; border: 0; border-radius: 50%; cursor: pointer; display: flex; flex-direction: column; align-items: center; justify-content: center; background: radial-gradient(circle at 40% 30%,#fffaf0,#efe3c8 55%,#c9b78f); box-shadow: 0 5px 0 #9c8a66, 0 7px 10px rgba(0,0,0,0.4), inset 0 2px 2px rgba(255,255,255,0.9); font-family: ${F.cond}; color: #3a2a18"><span style="font-size: 23px; font-weight: 700; letter-spacing: 0.12em; line-height: 23px">END</span><span style="font-size: 23px; font-weight: 700; letter-spacing: 0.12em; line-height: 23px">TURN</span></button>
    </div>
  </div>`;
}
function cardGlyph(g) {
  const st = 'fill="none" stroke="#f1cf7a" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"';
  const p = {
    cloak: `<path d="M12 2.5l8 3v6c0 5-3.5 8.5-8 10-4.5-1.5-8-5-8-10v-6z" ${st}></path><path d="M8.5 12l2.5 2.5 4.5-5" ${st}></path>`,
    exploit: `<circle cx="12" cy="12" r="7" ${st}></circle><circle cx="12" cy="12" r="2" ${st}></circle><path d="M12 2v4M12 18v4M2 12h4M18 12h4" ${st}></path>`,
    pick: `<path d="M4 7c4-4 12-4 16 0" ${st}></path><path d="M12 5v16" ${st}></path><path d="M10 21h4" ${st}></path>`,
    chip: `<rect x="6" y="6" width="12" height="12" rx="2" ${st}></rect><path d="M9 2v4M15 2v4M9 18v4M15 18v4M2 9h4M2 15h4M18 9h4M18 15h4" ${st}></path>`,
    ghost: `<path d="M5 20V10a7 7 0 0 1 14 0v10l-2.5-2-2.3 2-2.2-2-2.2 2-2.3-2z" ${st}></path><circle cx="9.5" cy="10.5" r="1" fill="#f1cf7a"></circle><circle cx="14.5" cy="10.5" r="1" fill="#f1cf7a"></circle>`,
  }[g];
  return `<div aria-hidden="true" style="position: relative; height: 62px; border-radius: 6px; display: flex; align-items: center; justify-content: center; background: radial-gradient(circle at 50% 50%, rgba(241,207,122,0.16), rgba(0,0,0,0) 60%), repeating-linear-gradient(90deg,rgba(241,207,122,0.12) 0 1px,rgba(0,0,0,0) 1px 16px), rgba(0,0,0,0.25); box-shadow: inset 0 1px 3px rgba(0,0,0,0.55), 0 1px 0 rgba(255,255,255,0.12)"><span style="position: absolute; left: 12px; right: 12px; top: 50%; height: 1px; background: rgba(241,207,122,0.35)"></span><span style="position: relative; width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: rgba(20,12,4,0.85); box-shadow: 0 0 0 1.5px rgba(241,207,122,0.6)"><svg width="26" height="26" viewBox="0 0 24 24">${p}</svg></span></div>`;
}
// ---------- assemble ----------
function screen(st) {
  const px = st.pixel;
  const bd = `<div style="position: absolute; inset: 0; overflow: hidden; ${px ? 'filter: url(#px3)' : ''}">
      <div style="position: absolute; inset: -12px; filter: blur(5px); opacity: 0.8">${backdrop(false)}</div>
      ${st.hostile ? `<div style="position: absolute; inset: -12px; filter: blur(5px); opacity: ${st.hostile}">${backdrop(true)}</div>` : ''}
      ${px ? ditherOverlay(1600, 1000) : ''}
    </div>
    <div aria-hidden="true" style="position: absolute; inset: 0; background: radial-gradient(130% 100% at 55% 40%, rgba(0,0,0,0) 40%, rgba(10,6,4,0.55) 100%)"></div>`;
  return `
<div style="position: relative; width: 1600px; height: 1000px; overflow: hidden; background: #0e0c0a; font-family: ${F.sans}">
  <svg aria-hidden="true" width="0" height="0" style="position: absolute">
    <defs>
      <filter id="px3" x="0" y="0" width="100%" height="100%" color-interpolation-filters="sRGB">
        <feFlood x="1" y="1" width="1" height="1"></feFlood>
        <feComposite width="3" height="3"></feComposite>
        <feTile result="grid"></feTile>
        <feComposite in="SourceGraphic" in2="grid" operator="in"></feComposite>
        <feMorphology operator="dilate" radius="1"></feMorphology>
        <feComponentTransfer>
          <feFuncR type="discrete" tableValues="${Array.from({ length: 16 }, (_, i) => (i / 15).toFixed(3)).join(' ')}"></feFuncR>
          <feFuncG type="discrete" tableValues="${Array.from({ length: 16 }, (_, i) => (i / 15).toFixed(3)).join(' ')}"></feFuncG>
          <feFuncB type="discrete" tableValues="${Array.from({ length: 16 }, (_, i) => (i / 15).toFixed(3)).join(' ')}"></feFuncB>
        </feComponentTransfer>
      </filter>
      <pattern id="bayer" width="12" height="12" patternUnits="userSpaceOnUse">
        ${[[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]].map((row, y) => row.map((v, x) => `<rect x="${x * 3}" y="${y * 3}" width="3" height="3" fill="${v < 8 ? '#000' : '#fff'}" opacity="${(Math.abs(v - 7.5) / 7.5 * 0.09).toFixed(3)}"></rect>`).join('')).join('')}
      </pattern>
    </defs>
  </svg>
  ${bd}
  <div style="position: absolute; left: 28px; top: 28px; z-index: 20">${hud(st.hud)}</div>
  ${topBar(st.top)}
  <div style="position: absolute; left: 500px; top: 126px; display: flex; gap: 44px">${st.ice.map(iceConsole).join('')}</div>
  ${responseBoard(st.response)}
  ${note(st.note)}
  ${hand(st.hand, st.overlap, st.hovered, 800)}
  ${endTurn(st.top)}
</div>`;
}

// ---------- states ----------
const P = {
  fort: { name: 'Fortress Pick', stat: 'Strength', val: 1 },
  tumb: { name: 'Tumbler Pick', stat: 'Strength', val: 3 },
  extr: { name: 'Extractor', stat: 'CRED / turn', val: 3 },
  buff: { name: 'Cortex Buffer', stat: '', val: null },
};
const C = {
  probe: { kind: 'SCRIPT', bw: 1, name: 'PROBE', type: 'SCRIPT — EXPLOIT', text: 'Target ICE gets −2 STR for this encounter.', glyph: 'exploit' },
  shield: { kind: 'SCRIPT', bw: 1, name: 'PULP SHIELD', type: 'SCRIPT — CLOAK', text: '+3 SHIELD.', glyph: 'cloak' },
  ghost: { kind: 'SCRIPT', bw: 2, name: 'GHOST SIGNAL', type: 'SCRIPT — CLOAK', text: 'The first TRACE added during the next Corporation Response is reduced to 0. BURNED.', glyph: 'ghost' },
  void: { kind: 'PROGRAM', bw: 1, name: 'VOID ICEPICK', type: 'PROGRAM — ICEPICK', text: 'STR 0. Boost: 1 BW +1 STR. Break: 1 BW.', icons: ['VOID', 'RAM 1'], glyph: 'pick' },
  buffer: { kind: 'PROGRAM', bw: 1, name: 'CORTEX BUFFER', type: 'PROGRAM', text: 'Once per encounter, prevent 1 CORTEX.', icons: ['RAM 1'], glyph: 'chip' },
};

const A = {
  pixel: false, hostile: 0,
  hud: { programs: [P.fort, P.tumb, P.extr], cur: 1, trace: 12, bw: 3, bwMax: 4, vitae: 26, shield: 3, pulp: 12 },
  top: { turn: 2, strikes: 0, reserve: 12, deck: 3, discard: 0 },
  ice: [
    { name: 'AUTO-RENEW', role: 'SUPPORT', type: 'FORTRESS · RATCHET', str: 5, strDelta: '↑1', mood: 'cheery', art: autoRenewArt('cheery'), bubble: 'Your plan renews automatically!', sticker: 'FREE for 30 days!',
      rows: [
        { slot: 'S1', text: 'PULP 1', caption: 'Basic plan', kind: 'normal', cost: 'FREE' },
        { slot: 'S2', text: 'PULP 2', caption: 'Plus plan', kind: 'normal' },
        { slot: 'S3', text: 'PULP 3', caption: 'Premium plan', kind: 'normal' },
        { slot: 'S4', text: 'DEADLOCK', caption: '', kind: 'deadlock' },
      ].map(subRow).join(''),
      passive: { name: 'HARDENING', rule: '+1 STR after each response · max +3', on: true }, plateText: 'HALCYON DOMESTIC CO. · MODEL HD-40 · PAT. 2,421,905 · MADE FOR YOU' },
    { name: 'CAPTCHA', role: 'MAIN', type: 'TUMBLER · SNARE', str: 5, mood: 'cheery', art: captchaArt('cheery'), bubble: "Let's make sure you're human!", lever: true,
      rows: tumblerBank('DISCARD 1', [
        { slot: '1', text: 'DEADLOCK', caption: '', kind: 'deadlock' },
        { slot: '2', text: 'PULP 6', caption: '', kind: 'big' },
      ], 'TRACE 3'),
      passive: { name: 'TRIPWIRE', rule: 'Each break: +1 TRACE', on: true }, deadlocks: [false, false], plateText: 'HALCYON DOMESTIC CO. · MODEL HD-24 · PAT. 2,419,330 · MADE FOR YOU' },
  ],
  response: [['PULP 1', false, 'AUTO-RENEW'], ['PULP 2', false, 'AUTO-RENEW'], ['PULP 3', false, 'AUTO-RENEW'], ['PULP 6', true, 'CAPTCHA']],
  note: [{ t: 'both buttons are locks.' }, { t: 'free first break on' }, { t: 'AUTO-RENEW. use it.', hl: true }],
  hand: [C.probe, C.shield, C.ghost, C.void, C.shield, C.buffer], overlap: 0.10, hovered: 3,
};
const B = {
  pixel: true, hostile: 0.41,
  hud: { programs: [P.fort, P.tumb, P.extr, P.buff], cur: 0, trace: 30, bw: 1, bwMax: 4, vitae: 17, shield: 0, pulp: 11 },
  top: { turn: 3, strikes: 0, reserve: 9, deck: 0, discard: 4 },
  ice: [
    { name: 'AUTO-RENEW', role: 'SUPPORT', type: 'FORTRESS · RATCHET', str: 6, strDelta: '↑2', mood: 'wary', art: autoRenewArt('wary'), bubble: "You cancelled Basic? We'll remember that.", sticker: 'Renews next turn', pixel: true,
      rows: [
        { slot: 'S1', text: 'PULP 1', caption: 'Basic plan', kind: 'broken' },
        { slot: 'S2', text: 'PULP 2', caption: 'Plus plan', kind: 'normal' },
        { slot: 'S3', text: 'PULP 3', caption: 'Premium plan', kind: 'normal' },
        { slot: 'S4', text: 'DEADLOCK', caption: '', kind: 'deadlock' },
      ].map(subRow).join(''),
      passive: { name: 'HARDENING', rule: '+1 STR after each response · max +3', on: true }, plateText: 'HALCYON DOMESTIC CO. · MODEL HD-40 · PAT. 2,421,905 · MADE FOR YOU' },
    { name: 'CAPTCHA', role: 'MAIN', type: 'TUMBLER · SNARE', str: 3, strDelta: '↓2', mood: 'lethal', art: captchaArt('lethal'), bubble: 'WRONG ANSWER.', lever: true, pixel: true,
      rows: tumblerBank('DEADLOCK', [
        { slot: '1', text: 'PULP 6', caption: '', kind: 'big' },
        { slot: '2', text: 'TRACE 3', caption: 'tumbled in', kind: 'normal' },
      ], 'DISCARD 1'),
      passive: { name: 'TRIPWIRE', rule: 'Each break: +1 TRACE', on: true }, deadlocks: [true, false], plateText: 'HALCYON DOMESTIC CO. · MODEL HD-24 · PAT. 2,419,330 · MADE FOR YOU' },
  ],
  response: [['PULP 2', false, 'AUTO-RENEW'], ['PULP 3', false, 'AUTO-RENEW'], ['PULP 6', true, 'CAPTCHA'], ['TRACE 3', false, 'CAPTCHA']],
  note: [{ t: '10 TRACE to a strike.', hl: true }, { t: "we'll take care of it.", leak: true }, { t: "— no we won't." }, { t: 'break the button.' }],
  hand: [C.probe, C.shield, C.ghost, C.void, C.probe], overlap: 0.08, hovered: -1,
};

// ---------- write ----------
const fontsGoogle = '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@500;600;700&amp;family=DM+Sans:ital,wght@0,400;0,500;0,700;1,400&amp;family=Poiret+One&amp;family=Space+Mono&amp;display=swap">';
const fp = '/home/claude/fonts/node_modules/@fontsource';
const localFonts = `<style>
@font-face{font-family:'Barlow Condensed';font-weight:500;src:url(${fp}/barlow-condensed/files/barlow-condensed-latin-500-normal.woff2)}
@font-face{font-family:'Barlow Condensed';font-weight:600;src:url(${fp}/barlow-condensed/files/barlow-condensed-latin-600-normal.woff2)}
@font-face{font-family:'Barlow Condensed';font-weight:700;src:url(${fp}/barlow-condensed/files/barlow-condensed-latin-700-normal.woff2)}
@font-face{font-family:'DM Sans';font-weight:400;src:url(${fp}/dm-sans/files/dm-sans-latin-400-normal.woff2)}
@font-face{font-family:'DM Sans';font-weight:500;src:url(${fp}/dm-sans/files/dm-sans-latin-500-normal.woff2)}
@font-face{font-family:'DM Sans';font-weight:700;src:url(${fp}/dm-sans/files/dm-sans-latin-700-normal.woff2)}
@font-face{font-family:'DM Sans';font-style:italic;font-weight:400;src:url(${fp}/dm-sans/files/dm-sans-latin-400-italic.woff2)}
@font-face{font-family:'Space Mono';src:url(${fp}/space-mono/files/space-mono-latin-400-normal.woff2)}
@font-face{font-family:'Poiret One';src:url(${fp}/poiret-one/files/poiret-one-latin-400-normal.woff2)}
body{margin:0}
</style>`;

for (const [key, st, title, file] of [['A', A, 'HALCYON · CAPTCHA node · Friendly, turn 2', 'EncounterFriendly'], ['B', B, 'HALCYON · CAPTCHA node · Cracking, turn 3, TRACE 30', 'EncounterCracking']]) {
  const body = screen(st);
  fs.writeFileSync(path.join(OUT, `preview_${key}.html`), `<!doctype html><html lang="en"><head><meta charset="utf-8">${localFonts}</head><body>${body}</body></html>`);
  fs.writeFileSync(path.join(OUT, 'project', `${file}.dc.html`), `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>${title}</title>
<script src="./support.js"></script>
</head>
<body>
<x-dc>
<helmet>
${fontsGoogle}
<style>
body{margin:0}
a{color:#d8812f}a:hover{color:#f0a050}
button:focus-visible{outline:2px solid #d8812f;outline-offset:2px}
</style>
</helmet>
${body}
</x-dc>
<script type="text/x-dc" data-dc-script data-props='{"$preview":{"width":1600,"height":1000}}'>
class Component extends DCLogic {
  renderVals() { return {}; }
}
</script>
</body>
</html>
`);
}
console.log('ok');
