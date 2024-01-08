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


-- 게시글 카테고리 
-- 게시판 카테고리는 자유게시판, 공지사항, 가입인사 세가지가 있음.
-- 카테고리 세가지 미리 저장
insert into category_table(category_name) values('공지사항');
insert into category_table(category_name) values('자유게시판');
insert into category_table(category_name) values('가입인사');
-- 게시판 기능 
-- 1. 게시글 작성(파일첨부 x) 3개 이상 
insert into board_table(board_title, board_writer, board_contents)
	values('aa', 'aa@aa.com', 'aa');
insert into board_table(board_title, board_writer, board_contents)
	values('bb', 'bb@bb.com', 'bb');
insert into board_table(board_title, board_writer, board_contents)
	values('cc', 'cc@cc.com', 'cc');
-- 1번 회원이 자유게시판 글 2개, 공지사항 글 1개 작성 
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('aa', 'aa@aa.com', 'aa', '2', '1');
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('bb', 'aa@aa.com', 'bb', '2', '1');
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('aaa', 'aa@aa.com', 'cc', '1', '1');
-- 2번 회원이 자유게시판 글 3개 작성
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('dd', 'bb@bb.com', 'aa', '2', '2');
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('ee', 'bb@bb.com', 'bb', '2', '2');
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('ff', 'bb@bb.com', 'cc', '2', '2');
-- 3번 회원이 가입인사 글 1개 작성 
insert into board_table(board_title, board_writer, board_contents, category_id, member_id)
	values('aa', 'cc@cc.com', 'aa', '3', '3');
-- 1.1. 게시글 작성(파일첨부 o)
insert into board_table(board_title, board_writer, board_contents, board_file_attached)
	values('aa', 'cc@cc.com', 'aa', '1');
-- 2번 회원이 파일있는 자유게시판 글 2개 작성
insert into board_table(board_title, board_writer, board_contents, board_file_attached, category_id, member_id)
	values('aa', 'bb@bb.com', 'aa', '1', '2', '2');
insert into board_file_table(original_file_name, stored_file_name, board_id)
	values('한라산.jpg', '2234989874898_한라산.jpg', '15');
-- 첨부된 파일정보를 board_file_table에 저장
-- 사용자가 저장한 파일 이름 : 한라산.jpg _
insert into board_table(board_title, board_writer, board_contents, board_file_attached, category_id, member_id)
	values('bb', 'bb@bb.com', 'bb', '1', '2', '2');
insert into board_file_table(original_file_name, stored_file_name, board_id)
	values('음식.jpg', '2234989874899_음식.jpg', '16');
-- 2. 게시글 목록 조회 
-- 2.1 전체글 목록 조회
select * from board_table;
-- 2.2 자유게시판 목록 조회 
select * from board_table where category_id = 2;
-- 2.3 공지사항 목록 조회 
select * from board_table where category_id = 1;
-- 2.4 목록 조회시 카테고리 이름도 함께 나오게 조회
select distinct * from board_table b, category_table c where category_name like '%';
-- 3. 2번 게시글 조회 (조회수 처리 필요함)
select * from board_table where id = '2';
update board_table set board_hits = board_hits + 1 where id = 2;
-- 3.1. 파일 첨부된 게시글 조회 (게시글 내용과 파일을 함께)
update board_table set board_hits = board_hits + 1 where id = 15;
-- 게시글 내용만 가져옴
select * from board_table where id = 15;
-- 해당 게시글에 첨부된 파일 정보 가져옴
select * from board_file_table where id = 15;
-- join
select * from board_table b, board_file_table bf where b.id = bf.board_id and id = 15;
-- 4. 1번 회원이 자유게시판에 첫번째로 작성한 게시글의 제목, 내용 수정
select *from board_table where id = 1;
update board_table set board_title = '안녕하십니까_수정', board_contents = '월요일 사라져라' where id = 1;
-- 5. 2번 회원이 자유게시판에 첫번째로 작성한 게시글 삭제 
delete from board_table where id = 5;
-- 7. 페이징 처리(한 페이지당 글 3개씩)
-- 7.1. 첫번째 페이지
-- 7.2. 두번째 페이지
-- 7.3. 세번째 페이지 
-- 8. 검색(글제목 기준)
-- 8.1 검색결과를 오래된 순으로 조회 
-- 8.2 검색결과를 조회수 내림차순으로 조회 
-- 8.3 검색결과 페이징 처리 