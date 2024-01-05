use db_dbclass;

drop table if exists member_table;
create table member_table(
	id bigint auto_increment,
    member_email varchar(30) not null,
    member_name varchar(20) not null,
    member_password varchar(20) not null,
    constraint pk_member primary key(id)
);
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
    board_created_at datetime,
    board_update_at datetime,
    board_file_attached int,
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
    constraint fk_board_file_board foreign key(board_id) references board_table(id)
);
drop table if exists comment_table;
create table comment_table(
	id bigint auto_increment,
    comment_writer varchar(30) not null,
	comment_contents varchar(200) not null,
    comment_created_at datetime,
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

