select * from user_tables;
select * from user_sequences;

select * from member;
select * from travel_course_no;
select * from board;

select * from place;
select * from place_photo;

--장소마다 사진 1개씩 가져오기
select place_no, min(place_photo_no), min(renamed_filename)
from place_photo
where place_no < 7 -- 장소번호 1~6
group by place_no
order by place_no;

select * from local_photo;
select * from user_sequences;

create table tb_local(
    local_code varchar2(10) not null,
    local_name varchar2(100) not null,
    constraint pk_local_code primary key(local_code)
);

alter table tb_local rename to local;
alter table tb_category rename to category;


insert into tb_local values('L1', '서울');
insert into tb_local values('L2', '충청도/대전');
insert into tb_local values('L3', '전라도');
insert into tb_local values('L4', '경기도');
insert into tb_local values('L5', '강원도');
insert into tb_local values('L6', '제주도');
insert into tb_local values('L7', '경상도/부산');

select * from tb_local order by local_code;

commit;

create table tb_category(
    category_code varchar2(10) not null,
    category_name varchar2(100) not null,
    constraint pk_category_code primary key(category_code)
);

insert into tb_category values('C1', '랜드마크');
insert into tb_category values('C2', '맛집');
insert into tb_category values('C3', '오락');
insert into tb_category values('C4', '레저/스포츠');
insert into tb_category values('C5', '캠핑/차박');

select * from tb_category;

commit;

alter table place
add constraint fk_local_code foreign key(local_code) 
                            references tb_local(local_code);
                            
alter table place
add constraint fk_category_code foreign key(category_code) 
                            references tb_category(category_code);
                            
--제약조건 확인
select constraint_name, 
        uc.table_name,
        ucc.column_name,
        uc.constraint_type,
        uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'BOARD_LIKE';

--지역코드 리스트
select * from local;
/*
L1	서울
L2	충청도/대전
L3	전라도/광주
L4	경기도
L5	강원도
L6	제주도
L7	경상도/부산
*/


--카테고리코드 리스트
select * from category;
                            
--local_photo_img_no sequence 생성
create sequence seq_local_photo_img_no
start with 22;

--지역코드별 장소 리스트 + 지역명 + 카테고리명
select *
from(
    select * 
    from place join local 
        using(local_code)
) join category
    using(category_code)
where local_code = 'L1';

--지역코드별 이미지 리스트
select * 
from local_photo 
where local_code = 'L1';

--카테고리 이름
select category_name from category where category_code = 'C1';


select * from user_constraints where table_name = 'BOARD';

create table board(
    board_no number not null,
    place_no number null,
    course_no number null,
    id varchar2(100) not null,
    category varchar2(20) not null,
    title varchar2(300) not null,
    content clob not null,
    read_count number default 0 not null,
    like_count number default 0 not null,
    write_date date default sysdate not null,
    constraints pk_board_no primary key(board_no),
    constraints fk_place_no foreign key(place_no) references place(place_no),
    constraints fk_course_no foreign key(course_no) references travel_course_no(course_no),
    constraints fk_id foreign key(id) references member(id) on delete cascade
    
);

create sequence seq_board_no;

--alter table board
--modify course_no number null;

select * from board order by board_no desc;

select * 
from place
where place_name = '테스트다요';

select * from place;

select * from member;
select * from authority;

delete from authority where id = 'kym912999';
delete from member where id = 'kym912999';

commit;

select * from place_photo;


select * from place_like;
select * from travel_course_no;
select * from board_like;

select title
from travel_course_no
where course_no = 41;

--seq_travel_course_no

insert into travel_course_no
values('honggd', seq_travel_course_no.nextval, '홍대 데이트 코스', sysdate);
insert into travel_course_no
values('honggd', seq_travel_course_no.nextval, '맛있는 녀석들 촬영 맛집 코스', sysdate);
insert into travel_course_no
values('honggd', seq_travel_course_no.nextval, '나만 가고 싶은 숨은 맛집 코스', sysdate);

commit;

create table board_like (
    board_no number not null,
    id varchar2(100) not null,
    constraints fk_board_like_board_no foreign key(board_no) references board(board_no),
    constraints fk_board_like_id foreign key(id) references member(id) on delete cascade
);

commit;

/*
    constraints fk_place_no foreign key(place_no) references place(place_no),
    constraints fk_course_no foreign key(course_no) references travel_course_no(course_no),
*/
--fk_course_no, fk_place_no : on delete set null

alter table board
add constraint fk_place_no foreign key(place_no) references place(place_no) on delete set null;

alter table board
add constraint fk_course_no foreign key(course_no) references travel_course_no(course_no) on delete set null;

--댓글 테이블 작성
create table board_comment(
    reply_no number,
    comment_level number default 1,
    id varchar2(100),
    content varchar2(2000),
    board_no number,
    comment_ref number,
    reg_date date default sysdate,
    constraint pk_board_comment_reply_no primary key(reply_no),
    constraint fk_board_comment_id foreign key(id) references member(id) on delete set null,
    constraint fk_board_comment_board_no foreign key(board_no) references board(board_no) on delete cascade,
    constraint fk_board_comment_ref foreign key(comment_ref) references board_comment(reply_no) on delete cascade
);

comment on column board_comment.reply_no is '게시판댓글번호';
comment on column board_comment.comment_level is '게시판댓글 레벨';
comment on column board_comment.id is '게시판댓글 작성자';
comment on column board_comment.content is '게시판댓글';
comment on column board_comment.board_no is '참조원글번호';
comment on column board_comment.comment_ref is '게시판댓글 참조번호';
comment on column board_comment.reg_date is '게시판댓글 작성일';

--create sequence
create sequence seq_board_comment_reply_no;

--댓글 수
select count(*) 
from board_comment
where board_no = 41;

select bc.*
from board_comment bc
where board_no = 41
start with comment_level = 1
connect by prior reply_no = comment_ref
order siblings by reg_date desc;

--댓글 추가
insert into board_comment(reply_no, comment_level, id, content, board_no, comment_ref)
values(seq_board_comment_reply_no.nextval, 1, 'sejong', '잘 읽었습니다.', 41, null);
insert into board_comment(reply_no, comment_level, id, content, board_no, comment_ref)
values(seq_board_comment_reply_no.nextval, 1, 'admin', '완전꿀팁!!', 41, null);
insert into board_comment(reply_no, comment_level, id, content, board_no, comment_ref)
values(seq_board_comment_reply_no.nextval, 1, 'honggd', '감사합니다.', 41, 1);

update board_comment
set comment_level = 2
where id = 'honggd';

commit;

--장소리스트 + categoryName, localName + 사진1장, place_like_count, board_count
--placeLikeCount, boardCount는 null일 시 0으로 처리
select place_no, place_name, local_code, local_name, category_code, category_name, content, from_user, nvl(place_like_count, 0)place_like_count, renamed_filename, nvl(board_count, 0)board_count
from place join category using(category_code) join local using(local_code)
    left join (
        select place_no, count(*) place_like_count
        from place_like
        group by place_no
    ) using(place_no)
    left join (
        select place_no, min(renamed_filename) renamed_filename
        from place_photo 
        group by place_no
    ) using(place_no)
    left join (
        select place_no, count(*) board_count
        from board
        group by place_no
        having place_no > 0
    ) using(place_no)
where category_code = 'C1'
order by place_name;

--장소별 좋아요 카운트
select place_no, count(*) 
from place_like
group by place_no
order by place_no;

--장소별 renamed_filename
select place_no, min(renamed_filename)
from place_photo 
group by place_no
order by place_no;

--장소별 게시글 카운트
select place_no,  count(*) board_count
from board
group by place_no
having place_no > 0;

select * from board_like;

--장소 리스트 + 사진1장
select *
from(
select place_no, category_code, local_code, local_name, place_name, address, content, category_name, from_user, min(renamed_filename) renamed_filename
from (
    select *
            from(
                select * 
                from place full join local 
                    using(local_code)
            ) full join category
                using(category_code)
    ) full join place_photo
    using(place_no)
where category_code = 'C1'
group by (place_no, category_code, local_code, local_name, place_name, address, content, category_name, from_user)
)A full join (
    select place_no, count(*) 
    from place_like
    group by place_no
) L
using(place_no)
order by place_no desc;



select * from place order by place_no desc;


--장소 1개 조회....?사진3개나옴쓰..ㅇ.ㅇ
		select p.*, l.local_name, c.category_name, h.*
		from place p 
        left join place_photo h
        on p.place_no = h.place_no
        left join local l
		    on p.local_code = l.local_code
		        left join category c
		    on p.category_code = c.category_code
		where p.place_no = 13;
    
select * from place_photo;

select * from place_like order by place_no;

select * from board_like order by board_no;

--사용자가 해당 게시글에 좋아요를 눌렀는지 여부 확인
select *
from board_like
where id = 'honggd' and board_no = 41;


select count(*) 
from board_like
where board_no = 41;

commit;

select * from place order by place_no desc;

update place set from_user = 1 where place_no = 235;


alter table place
rename column fromuser to from_user;

select * from place;


		select p.*, l.local_name, c.category_name, h.*, nvl(z.board_count, 0)board_count, nvl(w.place_like_count, 0) place_like_count
		from place p 
        left join place_photo h
        on p.place_no = h.place_no
        left join local l
		    on p.local_code = l.local_code
		        left join category c
		    on p.category_code = c.category_code
                left join (
                    select place_no,  count(*) board_count
                    from board
                    group by place_no
                    having place_no > 0
                ) z on p.place_no = z.place_no
                left join (
                    select place_no, count(*) place_like_count
                    from place_like
                    group by place_no
                    order by place_no
                ) w on p.place_no = w.place_no
		where p.place_no = 15;
        
select board_no,  cnt
from board
    join (
        select board_no, count(*) cnt
        from board_like
        group by board_no
    ) using(board_no);
        
--게시물 별 좋아요 수
select board_no, count(*) 
from board_like
group by board_no
order by board_no;

select * from travel_course;


select * from board order by board_no desc;


select count(*) from board;

select * from board_like;

--채팅 기록 테이블 생성
create table chat(
    chat_no number not null,
    from_id varchar2(100) not null,
    to_address varchar2(100) not null,
    message varchar2(4000) not null,
    reg_time date not null,
    
    constraint pk_chat_no primary key(chat_no),
    constraint fk_chat_from foreign key(from_id) references member(id) on delete set null
);

create sequence seq_chat_no;

commit;

--회원별 채팅 구분
select * 
from chat
where to_address = '/ask/honggd'
order by chat_no;

--채팅 이력 있는 회원 아이디 리스트 조회
select distinct from_id
from chat
where from_id != 'admin';

--회원별 채팅 기록 수
select to_address, count(*)
from chat
group by to_address;