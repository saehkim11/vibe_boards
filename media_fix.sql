-- 사진·영상 경로 저장 권한 보완
-- Supabase SQL Editor에서 한 번 실행하세요.
-- RLS는 그대로 유지하며, 게시글 첨부 정보 열에만 UPDATE 권한을 추가합니다.

begin;

grant update (media_path, media_type)
  on table public.posts
  to authenticated;

commit;
