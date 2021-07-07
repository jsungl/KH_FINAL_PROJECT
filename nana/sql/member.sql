--------------------------------------------------------------------------------------
-- member테이블
--------------------------------------------------------------------------------------

create table member(
		id varchar2(15),
		password varchar2(300) not null,
		name varchar2(256) not null,
		gender char(1),
		birthday date,
		email varchar2(256) not null,
		phone char(11) not null,
		preference varchar2(256),
        sso varchar2(30),
		constraint pk_member_id primary key(id),
		constraint ck_member_gender check(gender in ('M', 'F'))
);

insert into member values ('yougs','1234','유관순','F',null,'yougs@naver.com','01012345678',null,null);
insert into member values ('sinsa','1234','신사임당','F',null,'sinsa@naver.com','01012345678',null,null);
insert into member values ('abcd','1234','에이비시디','M',null,'abcdef@gmail.com','01012345678',null,null);
insert into member values ('pogba','1234','포그바','F',null,'pogba@gmail.com','01043781256',null,null);
insert into member values ('mbappe','1234','음바페','M',null,'mbappe@gmail.com','01012017755',null,null);
insert into member values ('lewandowski','1234','레반도프스키','M',null,'lewandowski@gmail.com','01099043565',null,null);
--commit;

select * from member;
desc member;
delete from member
where id = 'baeguson78';


update
    member
set
    enroll_date = to_date('19/07/09','RR/MM/DD')
where
    id = 'abcde';


--alter table member add enroll_date date default sysdate;
--alter table member
--drop column p_like;
--
--alter table member
--drop column b_like;

--alter table member add naverlogin varchar2(30);
--alter table member
--modify gender char(1) null;

--alter table member
--rename column naverlogin to sso;

--제약조건 조회
select constraint_name,
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'MEMBER';

--------------------------------------------------------------------------------------
-- authority테이블
--------------------------------------------------------------------------------------

create table authority(
    id varchar2(20) not null, --회원아이디
    authority varchar2(20) default 'ROLE_USER' not null, --권한
    constraint pk_authority primary key (id,authority), --묶어서 pk설정(복합 primary key)
    constraint fk_authority_member_id foreign key(id) references member(id)
);

insert into authority values('honggd', 'ROLE_USER');
insert into authority values('admin', 'ROLE_USER');
insert into authority values('admin', 'ROLE_ADMIN');

insert into authority values('pogba', 'ROLE_USER');
insert into authority values('mbappe', 'ROLE_USER');
insert into authority values('lewandowski', 'ROLE_USER');
delete from authority
where id = 'baeguson78';


--commit;

select * from authority;

--drop table authority;

--alter table authority
--drop constraint fk_authority_member_id;

--------------------------------------------------------------------------------------
-- persistent_logins테이블
--------------------------------------------------------------------------------------

--security의 remember-me 사용을 위한 persistent_logins 테이블 생성
create table persistent_logins (
    username varchar2(64) not null, --사용자아이디
    series varchar2(64) primary key, --
    token varchar2(64) not null, -- username,password, 만료시간(expiry time)에 대한 임의의 hashing값(단방향 : 결과물로 유추못함)
    last_used timestamp not null
);


select * from persistent_logins;




-----------------------------------------------------------------------------------------
-- 장소 테이블
select * from place;

select * from local;
select * from category;

-- 게시판 테이블
select * from board; 

-- 좋아요목록 테이블
select * from board_like;

select B.board_no, B.title, B.category, B.write_date
from board_like BL join board B
    on BL.board_no = B.board_no
where BL.id = 'honggd';


-- 찜목록 테이블
select * from place_like;


select P.place_no, P.place_name, P.address
from place_like PL join place P
    on PL.place_no = P.place_no
where PL.id = 'honggd';



-- 댓글 테이블
select * from board_comment;

-- 반려동물 테이블
select * from place_pet;


select *
from place P join place_pet PE
    on P.place_no = PE.place_no;
    
select
        P.place_no,P.place_name,P.local_code,P.category_code,P.address,P.content,P.x_coord,P.y_coord,PE.pet_check
from 
        place P join place_pet PE on P.place_no = PE.place_no
where
     P.local_code = 'L4' and P.category_code in ('C1','C3') and PE.pet_check = 1;
 
