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