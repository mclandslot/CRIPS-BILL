/*
 * Copy this file to `config.js` in the same folder and fill in your project's
 * values. `index.html` loads `supabase/config.js` if it is there; without it
 * the app runs in-memory with save/open data files.
 *
 * Find both values in Supabase Studio ▸ Project Settings ▸ API.
 *
 * The anon key is a public, publishable key — it is meant to sit in client
 * code. It is NOT a secret in the sense a password is, but it is also not a
 * permission: what it can actually do is decided by the Row Level Security
 * policies on your tables. Never put the `service_role` key here; it bypasses
 * RLS entirely and would hand anyone who opened the page full access.
 *
 * `config.js` is listed in .gitignore so your project's values stay out of git.
 */
window.SUPABASE_CONFIG = {
  url:     "https://YOUR-PROJECT-REF.supabase.co",
  anonKey: "YOUR-ANON-PUBLIC-KEY"
};
