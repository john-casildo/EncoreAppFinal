# 🎸 Encore iOS App — Complete Setup Guide
### For Beginners | Xcode + SwiftUI + Supabase

---

## STEP 1 — Install Xcode

1. Open the **Mac App Store**
2. Search **Xcode** and install it (it's free, ~10GB)
3. Open Xcode once to finish setup

---

## STEP 2 — Create Your Xcode Project

1. Open Xcode → **Create New Project**
2. Choose **iOS → App**
3. Fill in:
   - **Product Name:** `Encore`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Bundle Identifier:** `com.yourname.encore`
4. Save to your Desktop

---

## STEP 3 — Add the Code Files

Inside Xcode, you'll see a folder called `Encore` in the left sidebar.

**Create this folder structure** (right-click → New Group):
```
Encore/
├── EncoreApp.swift          ← already exists, REPLACE it
├── Models/
│   └── Models.swift
├── Services/
│   ├── SupabaseClient.swift
│   └── AuthManager.swift
└── Views/
    ├── MainTabView.swift
    ├── Auth/
    │   └── AuthView.swift
    ├── Renter/
    │   ├── BrowseView.swift
    │   ├── InstrumentDetailView.swift
    │   ├── MyRentalsView.swift
    │   └── RenterProfileView.swift
    └── Host/
        ├── HostDashboardView.swift
        ├── HostListingsView.swift
        ├── HostBookingsView.swift
        └── HostProfileView.swift
```

**For each file:**
1. Right-click the correct folder in Xcode
2. Select **New File → Swift File**
3. Name it exactly as shown above
4. **Delete all default content**
5. **Paste the code** from the corresponding `.swift` file provided

---

## STEP 4 — Set Up Supabase (Free)

### 4a. Create Your Project
1. Go to **https://supabase.com** → Sign up (free)
2. Click **New Project**
3. Name it `encore`, choose a region close to you
4. Wait ~2 minutes for setup

### 4b. Create Database Tables

Go to **SQL Editor** in Supabase and run this:

```sql
-- Users table
create table users (
  id uuid references auth.users primary key,
  name text,
  email text,
  role text default 'renter',
  avatar_url text,
  created_at timestamp default now()
);

-- Instruments table
create table instruments (
  id uuid default gen_random_uuid() primary key,
  host_id uuid references users(id),
  name text not null,
  category text,
  description text,
  price_per_day numeric,
  image_emoji text default '🎸',
  location text,
  is_available boolean default true,
  rating numeric default 0,
  review_count int default 0,
  created_at timestamp default now()
);

-- Rentals table
create table rentals (
  id uuid default gen_random_uuid() primary key,
  instrument_id uuid references instruments(id),
  renter_id uuid references users(id),
  host_id uuid references users(id),
  start_date date,
  end_date date,
  total_price numeric,
  status text default 'pending',
  instrument_name text,
  instrument_emoji text,
  created_at timestamp default now()
);

-- Enable Row Level Security (important!)
alter table users enable row level security;
alter table instruments enable row level security;
alter table rentals enable row level security;

-- Policies (allow users to read/write their own data)
create policy "Users can view all instruments" on instruments for select using (true);
create policy "Hosts can insert instruments" on instruments for insert with check (auth.uid() = host_id);
create policy "Users can view their rentals" on rentals for select using (auth.uid() = renter_id or auth.uid() = host_id);
create policy "Renters can create rentals" on rentals for insert with check (auth.uid() = renter_id);
```

### 4c. Get Your API Keys
1. Go to **Settings → API**
2. Copy:
   - **Project URL** (looks like `https://xxxx.supabase.co`)
   - **anon/public key** (long string)

### 4d. Paste Keys into Xcode
Open `SupabaseClient.swift` and replace:
```swift
static let url = "https://YOUR_PROJECT_ID.supabase.co"
static let anonKey = "YOUR_ANON_KEY_HERE"
```
With your real values.

---

## STEP 5 — Run the App

1. In Xcode, select **iPhone 15 Pro** simulator at the top
2. Press the **▶ Play button** (or Cmd+R)
3. The app will build and launch in the simulator!

---

## STEP 6 — Test the App

**As a Renter:**
- Sign up with role "Rent instruments"
- Browse the instrument catalog
- Tap any instrument → book it with dates
- Check "My Rentals" tab

**As a Host:**
- Sign up with role "List my instruments"
- View earnings dashboard
- Add a new instrument (+ button)
- Toggle availability on listings
- Approve/decline bookings

**Switch modes anytime** from the Profile tab.

---

## STEP 7 — Add Stripe Payments (Later)

1. Sign up at **https://stripe.com**
2. Install Stripe iOS SDK via Swift Package Manager
3. Replace the mock `bookNow()` function in `InstrumentDetailView.swift`
   with a real Stripe Checkout call

---

## Common Xcode Errors & Fixes

| Error | Fix |
|---|---|
| "Cannot find type 'X'" | Make sure the file is added to the target |
| "No such module" | Build once with Cmd+B |
| Simulator won't load | Xcode → Product → Clean Build Folder (Cmd+Shift+K) |
| Supabase auth error | Check your URL/key in SupabaseClient.swift |

---

## File Summary

| File | What it does |
|---|---|
| `EncoreApp.swift` | App entry — decides login vs main screen |
| `AuthManager.swift` | Handles login/signup with Supabase |
| `SupabaseClient.swift` | Connects to Supabase API |
| `Models.swift` | All data structures (Instrument, Rental, User) |
| `AuthView.swift` | Login + signup screen |
| `MainTabView.swift` | Tab bar — switches Renter/Host tabs |
| `BrowseView.swift` | Renter: browse & filter instruments |
| `InstrumentDetailView.swift` | Renter: view details + book |
| `MyRentalsView.swift` | Renter: active & past rentals |
| `RenterProfileView.swift` | Renter: profile & settings |
| `HostDashboardView.swift` | Host: earnings & activity |
| `HostListingsView.swift` | Host: manage listings + add new |
| `HostBookingsView.swift` | Host: approve/decline bookings |
| `HostProfileView.swift` | Host: profile & settings |

---

## If You Run Out of Tokens

Start a **new Claude conversation** and say:

> *"I'm building Encore, an iOS musical instrument rental app in SwiftUI.
> Here is what's already been built: [paste the file names].
> I now need help with: [what you want next, e.g. 'adding Stripe payments',
> 'image upload for instruments', 'push notifications', 'a map view']*"

Claude will pick up exactly where we left off!

---

**Built with ❤️ for Encore** | SwiftUI + Supabase | 2025
