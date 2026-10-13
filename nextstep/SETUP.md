# NextStep: Supabase setup (about 10 minutes)

Files: `index.html` (the whole website), `schema.sql` (database tables).
Menu names in Supabase can change slightly, but the steps stay the same.

## 1. Create the project
1. Go to supabase.com and sign in.
2. New project: give it a name (for example `nextstep`), set a database password, pick the region closest to your students (India: Mumbai if available).

## 2. Create the tables
1. Open **SQL Editor** and click **New query**.
2. Paste everything from `schema.sql` and click **Run**.
3. You should see "Success". Under **Table Editor** you now have `profiles`, `progress`, `study_log` and `tasks`.

## 3. Choose how signup works
Open **Authentication** and then the **Email** provider.
- **Confirm email ON** (recommended for the real launch): a student must click the link in their email before logging in. The site already shows a message for this.
- **Confirm email OFF** (easier for testing): signup logs the student in straight away.

## 4. Paste your two keys into `index.html`
1. In Supabase open **Project Settings** and then **API** (or use the **Connect** button).
2. Copy the **Project URL** and the **anon / publishable key**.
3. Open `index.html` in VS Code, search for `SUPABASE_URL` and paste both values between the quotes:

```js
const SUPABASE_URL='https://abcdxyz.supabase.co';
const SUPABASE_ANON_KEY='eyJ...your anon key...';
```

The anon key is meant to be public, because the row level security rules in `schema.sql` protect each student's data.
Never paste the `service_role` key into this file.

## 5. Put the site live
Deploy `index.html` to Netlify, Vercel, GitHub Pages or Cloudflare Pages.
Then in Supabase open **Authentication** and then **URL Configuration** and set **Site URL** to your live link
(for example `https://nextstep.netlify.app`). Confirmation emails use this link.

## 6. Test it
1. Open the live site, sign up with a real email, and log in.
2. Tick a topic, add a task, and finish or log a study session.
3. Log in on another phone or laptop. Everything should be there.
4. In Supabase **Table Editor** you can see the rows being created.

## Notes
- If both values stay empty, the site runs in demo mode and saves data only in that browser.
- Supabase free projects can pause after a period of no activity. Check your plan's current limits before launching to many students.
- Add a Privacy Policy before you collect real students' emails, especially if students are under 18.
