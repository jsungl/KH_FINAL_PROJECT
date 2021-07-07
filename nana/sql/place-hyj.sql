alter table place add  constraint pk_place_no primary key (place_no);

create sequence seq_place_no
start with 110
increment by 1
nocache;

select * from place order by place_no asc;
select * from place_photo order by place_photo_no desc;

create table place_photo (
    place_photo_no number,
    place_no number not null,
    original_filename varchar2(256) not null,
    renamed_filename varchar2(256) not null,
    constraint pk_place_photo_no primary key (place_photo_no),
    constraint fk_place_photo_place_no foreign key(place_no)
        references place(place_no) on delete cascade
);

create sequence seq_place_photo_no
start with 1
increment by 1
nocache;


		select p.*, l.local_name, c.category_name, h.place_photo_no, h.place_no, h.original_filename, h.renamed_filename
		from place p 
        inner join place_photo h
        on p.place_no = h.place_no
        inner join local l
		    on p.local_code = l.local_code
		        inner join category c
		    on p.category_code = c.category_code
		where p.place_no = 1;
        
create table notification (
	noti_no number,
	board_no number not null,
	type varchar2(10) not null,
	sender_name varchar2(256) not null,
	recever_id varchar2(15) not null,
	message_content varchar2(500) not null,
	send_time date default sysdate,
	constraint pk_noti_no primary key (noti_no),
	constraint fk_recever_id foreign key(recever_id)
        references member(id) on delete cascade
);

create sequence seq_noti_no
start with 1
increment by 1
nocache;

select * from notification;