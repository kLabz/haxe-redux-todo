package util;

import redux.Redux;
import redux.thunk.Thunk;
import store.AppState;

class TestUtil {
	// Note: this will only work with simple thunks, not relying on dispatch's result
	public static function computeThunkActions<T>(
		thunk:Thunk<AppState, T>,
		state:AppState,
		?params:T
	):Array<Action> {
		var actions = [];
		var dispatch = actions.push;
		var getState = function() return state;

		switch (thunk) {
			case Action(cb): cb(dispatch, getState);
			case WithParams(cb): cb(dispatch, getState, params);
		}

		return actions;
	}
}

