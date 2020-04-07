#pragma once 

#include "consts.hpp"
#include "garden.hpp"
#include "item.hpp"
#include "utils.hpp"
#include "items_store.hpp"

class Home {
	private:
		bool is_trophy;
		double health;
		double max_capacity;
		double current_capacity;
		double energy;
		double temperature;

		std::vector<Item> stock;

		Garden* garden;
		std::string trophy;
		bool can_add_items;

	public:
		Home( double, double, double, double );
		Home();

		std::pair<bool,double> Repair( double );
		void Damage( double );
		void EnergyTick( void );

		// geters
		double GetHealth( void );
		double GetEnergy( void );
		double GetTemp( void );

		Item* GetItemByName( std::string );
		Item* GetItemById( DWORD );
		
		// viewers
		void ViewStockStatus( void );
		void ViewStock( void );
		
		// stock methods 
		void InitDefaultStock( void );
		bool GetStockStatus( void );
		bool RecalculateStock( void );

		bool AddItem( Item );		
		bool MoveToTrashByName( std::string );
		bool MoveToTrashById( DWORD );

		// garden methods
		void InitDeafultGarden( void );
		void PlantPotatoes( DWORD );
		bool CheckGarden( DWORD );
		void ViewGarden( void );
		int GardenTick( void );

		// trophy
		std::string GetTrophyDisplayCode( void );
		bool TrophyMenu( void );
		void SetTrophy( std::string _trophy );
		bool ViewTrophy( void );
		bool GetTrophyStatus( void );
};