package com.kh.nana.board.model.vo;

import java.util.List;

import org.springframework.social.google.api.plus.Activity.Attachment;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString(callSuper = true)
@NoArgsConstructor
public class BoardExt extends Board {
	
	private boolean hasAttachment;
	private List<Attachment> attachList;
	
}
