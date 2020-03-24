#pragma once

#include "consts.hpp"
#include "home.hpp"
#include "item.hpp"
#include "utils.hpp"

class Martian {
	private:
		std::string name;
		std::string password;
		std::string status;

		int lifedays = 0;

		double health;
		double hunger;
		double thirst;
		double stamina;
		double intelligence;
		double repair_skill;

		Home* home;

		std::vector<Item> stash;

		int actions;
	public:
		Martian( std::string, std::string );

		bool LoadSaveFile( void );
		bool SaveFile( void );

		std::string GetName( void );
		void ViewUserStats( void );
		bool CanDoAction( ACTION_TYPE );

		// UserInterface
		bool EatPotatoes( void );
		bool DrinkWater( void );
		bool ReadBook( void );
		bool RepairHome( void );
		bool PlantPotatoes( void );
		bool MakeRaid( void );
		bool GoToNextDay( void );
		bool ChangeStatus( void );

		// some
		void Damage( double );
		void SubStamina( double );
		bool CheckHealth( void );
		void MakeRandomEvent( void );

		inline std::vector<double> get( void );

		void AddItemToHomeStock( Item );
};


int EasyRaid( Martian* player );
int MediumRaid( Martian* player );
int HardRaid( Martian* player );
