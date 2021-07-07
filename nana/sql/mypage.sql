
---------------- My Page -------------------

-- 여행 코스 이름 등록 밑 코스 등록 테이블
create table travel_course_no(
    id varchar2(100),
    course_no number,
    title varchar2(200) not null,
    reg_date date default sysdate,
    constraint pk_travel_c_no_no primary key(course_no),
    constraint fk_travel_c_no_member_id foreign key(id) 
            references member(id) on delete set null
);

--여행 코스 테이블
create table travel_course(
    id varchar2(100),
    no number,
    title varchar2(200) not null,
    travel_date date,
    travel_local varchar2(400) not null,
    content varchar2(400),
    reg_date date default sysdate,
    constraint pk_travel_course_no primary key(no),
    constraint fk_travel_course_member_id foreign key(id) 
            references member(id) on delete set null
);

-- 여행 코스 사진 테이블 
create table course_photo(
    id varchar2(100),
    no number,
    img_no number not null,
    original_filename varchar2(256) not null,
    renamed_filename varchar2(256) not null,
    upload_date date default sysdate,
    constraint pk_course_photo_no primary key(img_no),
    constraint fk_course_photo_no foreign key(no)
        references travel_course(no) on delete cascade,
    constraint fk_course_photo_id foreign key(id)
            references member(id) on delete set null
);

SELECT * FROM USER_SEQUENCES;

create sequence seq_travel_course_list_no;
create sequence seq_travel_course_no;
create sequence seq_course_photo_no;

commit;

SELECT * FROM tabs;

select * from travel_course_no;
select * from travel_course;
select * from course_photo;
select * from member;
select * from PLACE_PHOTO order by place_no;
select * from BOARD;
select * from PLACE;
select * from PLACE_PET;
select * from BOARD_COMMENT;
select * from BOARD_LIKE;
select * from PLACE_LIKE;
select * from AUTHORITY;

select * from BOARD_COMMENT where id = 'honggd';

select CONSTRAINT_NAME, TABLE_NAME, R_CONSTRAINT_NAME
from user_constraints
where CONSTRAINT_NAME = 'FK_AUTHORITY_MEMBER_ID';

delete from travel_course_no where course_no = 141;

UPDATE member
SET password='1234',
	name='홍지디',
	gender='M',
	birthday='',
	email='',
	phone='',
	preference=''
WHERE id= 'honggd';

UPDATE travel_course
SET id='honggd'
WHERE no= 201;

UPDATE member
SET password='1234',
	name='홍지디',
	gender='M',
	birthday='',
	email='',
	phone='',
	preference=''
WHERE id= 'honggd';

DELETE

FROM member

WHERE id = 'abcde';


select 
            tc.*,
            cp.id "photo_id",
            cp.no "photo_no",
            cp.img_no,
            cp.original_filename,
            cp.renamed_filename,
            cp.upload_date
		from  
		    travel_course tc
		  left join 
		    course_photo cp
		      on tc.no = cp.no
		where tc.title = '강남 먹방 여행'
        order by tc.reg_date;


select pl.no,
        pl.id,
        pl.place_no,
        p.place_name,
        p.address,
        p.content
		from  
		    PLACE_LIKE pl
		  left join 
		    PLACE p
		      on pl.place_no = p.place_no
		where pl.id = 'honggd';
        
select bl.no,
        bl.id,
        bl.board_no,
        b.title,
        b.content,
        b.category,
        b.write_date
		from  
		    BOARD_LIKE bl
		  left join 
		    BOARD b
		      on bl.board_no = b.board_no
		where bl.id = 'honggd';
        
select tcn.*,
            tc.no,
            tc.travel_date,
            tc.travel_local,
            tc.content
		from  
		    travel_course_no tcn
		  left join 
		    travel_course tc
		      on tcn.title = tc.title
		where tcn.id = 'admin' and tc.id = 'admin'
        order by tc.travel_date;

delete from(
select  *
		from  
		    travel_course tc
		  left join 
		    course_photo cp
		      on tc.no = cp.no
		where tc.no = 26
        );
        
select count(*)
		from travel_course_no
		where title = '강남 먹방 여행';

select course_no
		from travel_course_no
		where title = '강남 먹방 여행';

select count(*)
		from
			travel_course_no
		where id = 'honggd';

insert into
			travel_course_no
		values(
			'honggd',
			seq_travel_course_list_no.nextval,
			'안뇽',
			default
		);
        
insert into
			travel_course
		values(
			'honggd',
			seq_travel_course_no.nextval,
			'맛있는 녀석들 촬영 맛집 코스',
			sysdate,
			'더보일러스',
			'서양식 립바베큐',
			default
		);
        
delete from(
			select *
			from  
			    travel_course_no
			where title = '안뇽'
	        );
            
delete from(
			select *
			from  
			    travel_course
			where title = '안뇽'
	        );
--DROP TABLE travel_course_no CASCADE CONSTRAINTS;
--DROP TABLE travel_course CASCADE CONSTRAINTS;
--DROP TABLE course_photo CASCADE CONSTRAINTS;
--drop sequence seq_travel_course_no;
--drop sequence seq_course_photo_no;
