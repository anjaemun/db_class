use db_dbclass;

drop table if exists member_table;
create table member_table(
	id bigint auto_increment,
    member_email varchar(30) not null unique,
    member_name varchar(20) not null,
    member_password varchar(20) not null,
    constraint pk_member primary key(id)
);
desc member_table;
alter table member_table modify column member_email varchar(30) not null unique;
drop table if exists category_table;
create table category_table(
	id bigint auto_increment,
    category_name varchar(20) not null,
    constraint pk_category primary key(id)
);
drop table if exists board_table;
create table board_table(
	id bigint auto_increment,
    board_title varchar(50) not null,
    board_writer varchar(30) not null,
    board_contents varchar(500),
    board_hits int,
    board_created_at datetime default now(),
    board_update_at datetime on update now(),
    board_file_attached int default 0,
    member_id bigint,
    category_id bigint,
    constraint pk_board primary key(id),
    constraint fk_board_member foreign key(member_id) references member_table(id),
    constraint fk_board_category foreign key(category_id) references category_table(id)
);
drop table if exists board_file_table;
create table board_file_table(
	id bigint auto_increment,
    original_file_name varchar(100),
    stored_file_name varchar(100),
    board_id bigint,
    constraint pk_board_file primary key(id),
    constraint fk_board_file_board foreign key(board_id) references board_table(id) on delete cascade
);
drop table if exists comment_table;
create table comment_table(
	id bigint auto_increment,
    comment_writer varchar(30) not null,
	comment_contents varchar(200) not null,
    comment_created_at datetime default now(),
	board_id bigint,
    member_id bigint,
    constraint pk_comment primary key(id),
    constraint fk_comment_board foreign key(board_id) references board_table(id),
    constraint fk_comment_member foreign key(member_id) references member_table(id)
);
drop table if exists good_table;
create table good_table(
	id bigint auto_increment,
    comment_id bigint,
    member_id bigint, 
    constraint pk_good primary key(id),
    constraint fk_good_comment foreign key(comment_id) references comment_table(id),
    constraint fk_good_member foreign key(member_id) references member_table(id)
);

select * from member_table;
select * from board_table;
select * from board_file_table;
select * from good_table;
select * from comment_table;
select * from category_table;

-- 회원 기능
-- 1. 회원가입(임의의 회원3명 가입)
insert into member_table(member_email,member_name,member_password) values('aa@aa','aa','aa');
insert into member_table(member_email,member_name,member_password) values('bb@bb','bb','bb');
insert into member_table(member_email,member_name,member_password) values('cc@cc','cc','cc');
-- 2. 이메일 중복체크 
select * from member_table where member_email='aa@aa';
-- 3. 로그인
select * from member_table where member_email='aa@aa' and member_password='1234';
-- 4. 전체 회원 목록 조회 
select * from member_table;
-- 5. 특정 회원만 조회 
select * from member_table where id=1;
-- 6. 내정보 수정하기(6.1, 6.2에 해당하는 쿼리문작성)
	-- 6.1 회원정보 수정화면 요청(회원정보 수정 페이지를 보여준다고 가정했을 때 필요한 쿼리) 
    select * from member_table where id=1;
	-- 6.2 회원정보 수정 처리(비밀번호를 변경한다는 상황)	
	update member_table set member_password = '1234'  where id=1; 
-- 7. 회원 삭제 또는 탈퇴 
delete from member_table where id=3;


-- 게시판 기능 
-- 1. 게시글 작성(파일첨부 x) 3개 이상 
-- 1번 회원이 자유게시판 글 2개, 공지사항 글 1개 작성 
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('안녕하세요', 'aaa@member.com', '오늘은 월요일이라 힘이나네요', 1, 1);
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('눈이 왔어요', 'aaa@member.com', '빙판길 조심', 1, 1);    
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('전체공지입니다.', 'aaa@member.com', '공지입니다.', 1, 2);
-- 2번 회원이 자유게시판 글 3개 작성
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('오늘점심은', 'bbb@member.com', '서브웨이', 2, 1);
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('자바 재밌다', 'bbb@member.com', '진짜요', 2, 1);    
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('디비 재밌다', 'bbb@member.com', '??', 2, 1);
-- 3번 회원이 가입인사 글 1개 작성 
insert into board_table(board_title, board_writer, board_contents, member_id, category_id)
	values('오늘 가입했습니다', 'ccc@member.com', '반갑습니다', 3, 3);
-- 1.1. 게시글 작성(파일첨부 o)
-- 2번 회원이 파일있는 자유게시판 글 2개 작성
delete from board_table where id=11;
insert into board_table(board_title, board_writer, board_contents, board_file_attached, member_id, category_id)
	values('설산 풍경 감상하세요', 'bbb@member.com', '멋져요', 1, 2, 1);
-- 첨부된 파일정보를 board_file_table에 저장 
-- 사용자가 첨부한 파일 이름: 한라산.jpg
insert into board_file_table(original_file_name, stored_file_name, board_id)
	values('한라산.jpg', '2234989874898_한라산.jpg', 12); -- 여기서 12는 게시글의 번호(id)
insert into board_table(board_title, board_writer, board_contents, board_file_attached, member_id, category_id)
	values('오늘 다녀온 맛집', 'bbb@member.com', '겁나 맛있어요', 1, 2, 1);    
insert into board_file_table(original_file_name, stored_file_name, board_id)
	values('음식.jpg', '2234989873242_음식.jpg', 13);    
-- 2. 게시글 목록 조회 
-- 2.1 전체글 목록 조회
select * from board_table;
select id, board_title, board_writer, board_hits, board_created_at from board_table;
-- 2.2 자유게시판 목록 조회 
select * from board_table where category_id=1;
-- 2.3 공지사항 목록 조회 
select * from board_table where category_id=2;
-- 2.4 목록 조회시 카테고리 이름도 함께 나오게 조회(join)
select * from board_table b, category_table c where b.category_id=c.id;
-- 3. 2번 게시글 조회 (조회수 처리 필요함)
update board_table set board_hits=board_hits+1 where id=2;
select * from board_table where id=2;
-- 3.1. 파일 첨부된 게시글 조회 (게시글 내용과 파일을 함께)
update board_table set board_hits=board_hits+1 where id=12;
-- 게시글 내용만 가져옴
select * from board_table where id=12;
-- 해당 게시글에 첨부된 파일 정보 가져옴 
select * from board_file_table where board_id=12;
-- join 
select * from board_table b, board_file_table bf where b.id=bf.board_id and b.id=12;
-- 4. 1번 회원이 자유게시판에 첫번째로 작성한 게시글의 제목, 내용 수정
select * from board_table where id=1;
update board_table set board_title='안녕하십니까_수정', board_contents='월요일 사라져라' where id=1;
-- 5. 2번 회원이 자유게시판에 첫번째로 작성한 게시글 삭제 
delete from board_table where id=5;
-- 7. 페이징 처리(한 페이지당 글 3개씩)
select * from board_table order by id desc;
select * from board_table order by id desc limit 0,3; -- 1 페이지
select * from board_table order by id desc limit 3,3; -- 2 페이지
select * from board_table order by id desc limit 6,3; -- 3 페이지
select * from board_table order by id desc limit 9,3; -- 4 페이지

select * from board_table order by id desc limit 0,5;
select * from board_table order by id desc limit 5,5;
select * from board_table order by id desc limit 10,5;
-- 한 페이지당 3개씩 출력하는 경우 전체 글 갯수가 20개라면 필요한 페이지 개수? 7개
select count(*) from board_table;
-- 7.1. 첫번째 페이지
-- 7.2. 두번째 페이지
-- 7.3. 세번째 페이지 
-- 8. 검색(글제목 기준)
select * from board_table where board_title like '%오눌%';
-- 8.1 검색결과를 오래된 순으로 조회 
select * from board_table where board_title like '%오늘%' order by id asc;
-- 8.2 검색결과를 조회수 내림차순으로 조회 
select * from board_table where board_title like '%오늘%' order by id desc;
-- 8.3 검색결과 페이징 처리 
select * from board_table where board_title like '%오늘%' order by board_hits desc limit 0,3;


-- 댓글 기능 
-- 1. 댓글 작성 
insert into comment_table(comment_writer, comment_contents) values('aa','aa');
insert into comment_table(comment_writer, comment_contents) values('bb','bb');
-- 1.1. 1번 회원이 1번 게시글에 댓글 작성 
insert into comment_table(comment_writer, comment_contents, board_id, member_id) values('bb','bb',1,1);
-- 1.2. 2번 회원이 1번 게시글에 댓글 작성 
insert into comment_table(comment_writer, comment_contents, board_id, member_id) values('bb','bb',1,2);
-- 2. 댓글 조회
select * from board_table where id=1;
select * from comment_table where board_id=1;
select * from board_table b, comment_table c where b.id=c.board_id	and b.id=1;
-- 3. 댓글 좋아요 
-- 3.1. 1번 회원이 2번 회원이 작성한 댓글에 좋아요 클릭
-- 좋아요 했는지 체크
select id from good_table where comment_id  =2 and member_id=1;
-- 좋아요
insert into good_table(member_id, comment_id) values(1,2);
insert into good_table(member_id, comment_id) values(2,1);
-- 좋아요 취소
delete from good_table where id=1;
-- 3.2. 3번 회원이 2번 회원이 작성한 댓글에 좋아요 클릭 
insert into good_table(member_id, comment_id) values(3,2);
-- 4. 댓글 조회시 좋아요 갯수도 함께 조회
select count(*) 
	 from good_table where comment_id=2;