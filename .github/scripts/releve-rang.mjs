// Relève chaque jour le rang RetroAchievements et l'ajoute à data/rank-history.json
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';

const u = process.env.RA_USER, y = process.env.RA_API_KEY;
if (!u || !y) { console.error('Secrets RA_USER et/ou RA_API_KEY manquants (Settings → Secrets and variables → Actions)'); process.exit(1); }

const get = async (ep, params) => {
  const r = await fetch(`https://retroachievements.org/API/${ep}.php?` + new URLSearchParams({ ...params, y }));
  if (!r.ok) throw new Error(`${ep} : HTTP ${r.status}`);
  return r.json();
};

const [prof, sum] = await Promise.all([get('API_GetUserProfile', { u }), get('API_GetUserSummary', { u, g: 1, a: 0 })]);
if (!sum.Rank) { console.log('Pas de rang disponible pour ce compte.'); process.exit(0); }

const file = 'data/rank-history.json';
let data = {};
try { data = JSON.parse(readFileSync(file, 'utf8')); } catch {}
const key = String(prof.User || u).toLowerCase();
const h = (data[key] ||= []);
const entry = { d: new Date().toISOString().slice(0, 10), r: sum.Rank, p: prof.TotalPoints, t: sum.TotalRanked };
const last = h[h.length - 1];
if (last && last.d === entry.d) Object.assign(last, entry); else h.push(entry);

mkdirSync('data', { recursive: true });
writeFileSync(file, JSON.stringify(data) + '\n');
console.log(`${key} : #${entry.r} sur ${entry.t} (${entry.p} pts)`);
