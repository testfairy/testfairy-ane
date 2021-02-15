package com.testfairy;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AirTestFairy implements FREExtension {
	@Override
	public void initialize() {

	}

	@Override
	public FREContext createContext(String s) {
		return new AirTestFairyContext();
	}

	@Override
	public void dispose() {

	}
}
