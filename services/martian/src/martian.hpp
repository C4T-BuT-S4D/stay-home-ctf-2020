#pragma once

#include "consts.hpp"
#include "home.hpp"
#include "item.hpp"
#include "utils.hpp"

static std::string strings[] = { "You will die here. The sands will bury you and your memory will run out. All you can do is die worthy. You cannot survive in the sand, they will swallow you. And when you die, no one will regret. Surrender before it's too late and accept your death with dignity. Don't be a coward!", "Nowhere to run!", "You know my doom!! I will crush you", "You will stay here forever" };

static std::vector<std::string> msgs( strings, strings + ( sizeof ( strings ) /  sizeof ( std::string ) ) );

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

		// geters 
		inline double GetHP( void );
		inline int GetAP( void );
		inline void RegenHP( void );
		inline std::string GetName( void );
		inline void AddStamina( double );
		inline int GetINT( void );

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
