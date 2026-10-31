-- 게시글 사진·영상 첨부를 위한 Supabase Storage 설정
-- Supabase SQL Editor에서 한 번 실행하세요.
-- 실행 후 웹 화면의 업로드 기능을 연결합니다.

begin;

-- 게시글이 연결한 미디어 파일의 경로와 형식을 저장합니다.
alter table public.posts
  add column if not exists media_path text,
  add column if not exists media_type text;

-- 이미지와 짧은 영상만 담는 공개 버킷입니다.
-- 공개 게시판의 첨부파일이므로 URL을 아는 사람은 볼 수 있습니다.
insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'post-media',
  'post-media',
  true,
  10485760,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'video/mp4',
    'video/webm'
  ]::text[]
)
on conflict (id) do nothing;

-- 파일 경로 형식: {현재로그인사용자ID}/{무작위파일명.확장자}
-- 정책이 이미 있으면 덮어쓰지 않습니다.
do $$
begin
  if not exists (
    select 1 from pg_catalog.pg_policy
    where polrelid = 'storage.objects'::regclass
      and polname = 'post_media_insert_own_folder'
  ) then
    create policy post_media_insert_own_folder
      on storage.objects
      for insert
      to authenticated
      with check (
        bucket_id = 'post-media'
        and (storage.foldername(name))[1] = (select auth.uid()::text)
      );
  end if;

  if not exists (
    select 1 from pg_catalog.pg_policy
    where polrelid = 'storage.objects'::regclass
      and polname = 'post_media_delete_own_folder'
  ) then
    create policy post_media_delete_own_folder
      on storage.objects
      for delete
      to authenticated
      using (
        bucket_id = 'post-media'
        and (storage.foldername(name))[1] = (select auth.uid()::text)
      );
  end if;
end;
$$;

commit;
