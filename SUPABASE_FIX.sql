-- ═══════════════════════════════════════════════════════════════════
-- FIX VOTING — Run this in your Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════════════
-- This makes sure:
--   1. The expo_votes table exists
--   2. Anonymous users CAN insert votes
--   3. Anonymous users CAN read results
-- ═══════════════════════════════════════════════════════════════════

-- Step 1: Make sure table exists (does nothing if it already exists)
CREATE TABLE IF NOT EXISTS expo_votes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  tool_id TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 2: Enable Row Level Security
ALTER TABLE expo_votes ENABLE ROW LEVEL SECURITY;

-- Step 3: Remove any old policies (clean slate)
DROP POLICY IF EXISTS "anon_insert" ON expo_votes;
DROP POLICY IF EXISTS "anon_select" ON expo_votes;
DROP POLICY IF EXISTS "Anyone can vote" ON expo_votes;
DROP POLICY IF EXISTS "Anyone can read results" ON expo_votes;
DROP POLICY IF EXISTS "insert" ON expo_votes;
DROP POLICY IF EXISTS "select" ON expo_votes;

-- Step 4: Allow ANY user (anonymous) to INSERT votes
CREATE POLICY "anon_insert" ON expo_votes
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Step 5: Allow ANY user (anonymous) to READ votes
CREATE POLICY "anon_select" ON expo_votes
  FOR SELECT
  TO anon
  USING (true);

-- ═══════════════════════════════════════════════════════════════════
-- TEST: Run this query to confirm everything is working
-- ═══════════════════════════════════════════════════════════════════
-- After voting from your phone, run this and you should see your votes:
--
-- SELECT tool_id, COUNT(*) as votes
-- FROM expo_votes
-- GROUP BY tool_id
-- ORDER BY votes DESC;
-- ═══════════════════════════════════════════════════════════════════
