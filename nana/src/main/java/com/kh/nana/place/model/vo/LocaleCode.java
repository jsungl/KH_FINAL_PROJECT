package com.kh.nana.place.model.vo;

public enum LocaleCode {
	/**
	 * L1	서울
	L2	충청도/대전
	L3	전라도
	L4	경기도
	L5	강원도
	L6	제주도
	L7	경상도/부산
	 */
	SEOUL("L1"),  CHUNGCHEONG("L2"), JEOLLA("L3"), GYEONGGI("L4"), GANGWON("L5"), JEJU("L6"), GYEONGSANG("L7");
	
	private String value;
	
	LocaleCode(String value){
		this.value = value;
	}
	
	//getter
	public String getValue() {
		return this.value;
	}
	
	//valueOf
	public static LocaleCode localeValueOf(String value) {
		switch(value) {
		case "L1" : return SEOUL;
		case "L2" : return CHUNGCHEONG;
		case "L3" : return JEOLLA;
		case "L4" : return GYEONGGI;
		case "L5" : return GANGWON;
		case "L6" : return JEJU;
		case "L7" : return GYEONGSANG;
		default:
			throw new AssertionError("Unknown LocalCode : " + value);
		}
	}

}
