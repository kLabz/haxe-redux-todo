package dto;

@:enum abstract TodoFilter(String) from String to String {
	var SHOW_ALL = "SHOW_ALL";
	var SHOW_COMPLETED = "SHOW_COMPLETED";
	var SHOW_ACTIVE = "SHOW_ACTIVE";
}

