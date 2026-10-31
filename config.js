// Supabase Dashboard의 Project Settings > API에서 값을 복사해 붙여 넣으세요.
const SUPABASE_URL = "https://wqfajflwwjdwoazlzaau.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "sb_publishable_ltcR3GW36CJ2b15Tk7Ub1g_NBzF2A61";

// 브라우저에서 사용할 Supabase 클라이언트입니다.
const sb = supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);
