/*
 * Copy this file to `config.js` in the same folder and fill in your project's
 * values. `index.html` loads `supabase/config.js` if it is there; without it
 * the app runs exactly as before, in-memory with save/open data files.
 *
 * Find both values in Supabase Studio ▸ Project Settings ▸ API.
 *
 * The anon key is a public, publishable key — it is meant to sit in client
 * code. It is NOT a secret in the sense a password is, but it is also not a
 * permission: what it can actually do is decided by the Row Level Security
 * policies in schema.sql. Never put the `service_role` key here; it bypasses
 * RLS entirely and would hand anyone who opened the page full access.
 */
window.SUPABASE_CONFIG = {
  url:     "https://kifftjpmuzjlpytddcrm.supabase.co",
  anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpZmZ0anBtdXpqbHB5dGRkY3JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NjMwNzEsImV4cCI6MjEwNTEzOTA3MX0.5f3o8EDQgdiOhTDOL_OycKDBqcjDBHwQr8Ars3JWDjI"
};
