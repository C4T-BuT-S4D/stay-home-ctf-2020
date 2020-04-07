#pragma once

#include "consts.hpp"

class Garden {
	private:
		// first value: if true thats mean cell is locked and have potato
		// second value: >0 if first == true, contains count of days
		std::vector<std::pair<bool, DWORD>> beds;

		DWORD MaxSize;
	public:
		Garden( DWORD );

		DWORD GetCountOfFreeBeds( void );
		bool PlantPotatoes( DWORD );
		bool PlantPotato( void );

		void ViewGarden( void );
		int DailyTick( void );
};