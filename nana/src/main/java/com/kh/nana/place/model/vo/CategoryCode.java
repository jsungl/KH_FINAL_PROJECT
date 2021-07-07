package com.kh.nana.place.model.vo;

public enum CategoryCode {
	/**
	 * C1	랜드마크
		C2	맛집
		C3	오락
		C4	레저/스포츠
		C5	캠핑/차박
	 */
	LANDMARK("C1"), GOURMET("C2"), ENTERTAINMENT("C3"), LEISURE("C4"), CAMPING("C5");
	
	private String value;
	
	CategoryCode(String value){
		this.value = value;
	}
	
	//getter
	public String getValue() {
		return this.value;
	}
	
	public static CategoryCode categoryCodeValueOf(String value) {
		switch(value) {
		case "C1" : return LANDMARK;
		case "C2" : return GOURMET;
		case "C3" : return ENTERTAINMENT;
		case "C4" : return LEISURE;
		case "C5" : return CAMPING;
		default:
			throw new AssertionError("Unkown CategoryCode : " + value);
		}
	}

}
