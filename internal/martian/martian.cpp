#include "martian.hpp"

Martian::Martian( std::string _name, std::string _password )
{
	name = _name;
	password = _password;

	status = "None";

	health = INIT_HP;
	hunger = INIT_HUNGER;
	thirst = INIT_THIRST;
	stamina = INIT_STAMINA;
	intelligence = INIT_INTELLIGENCE;
	repair_skill = INIT_REPAIR_SKILL;

	home = new Home();

	actions = INIT_ACTIONS_POINTS;

};

void Martian::ViewUserStats( void )
{
	std::cout << "***--- Profile ---***" << std::endl; 
	std::cout << "User: " << name << std::endl;
	std::cout << "Status: " << status << std::endl;
	std::cout << "Action points: " << actions << std::endl; 

	std::cout << "Health: " << health << std::endl;
	std::cout << "Hunger: " << hunger << std::endl;
	std::cout << "Thirst: " << thirst << std::endl;
	std::cout << "Stamina: " << stamina << std::endl;
	std::cout << "Intelligence: " << intelligence << std::endl;
	std::cout << "Repair skill: " << repair_skill << std::endl;

	std::cout << "{?} Show home stats? [y\\n]: ";
	BYTE inp;
	std::cin >> inp;
	
	if ( inp == 'y' )
	{
		std::cout << "|||***--- Home ---***|||" << std::endl;
		std::cout << "Health: " << home->GetHealth() << std::endl;
		std::cout << "Energy: " << home->GetEnergy() << std::endl;
		std::cout << "Temperature: " << home->GetTemp() << std::endl;
	}

	std::cout << "{?} View stock status? [y\\n]: ";
	std::cin >> inp;
	
	if ( inp == 'y' )
		home->ViewStockStatus();

	std::cout << "{?} View stock items? [y\\n]: ";
	std::cin >> inp;
		
	if ( inp == 'y' )
	{
		std::cout << "|||---(((ITEMS)))---|||" << std::endl;
		home->ViewStock();	
	}

	if ( home->GetTrophyStatus() )
	{
		std::cout << "{?} View trophy? [y\\n]: ";
		std::cin >> inp;

		if ( inp == 'y' )
			home->TrophyMenu();
	}

	std::cout << "{?} View graden? [y\\n]: ";
	std::cin >> inp;
		
	if ( inp == 'y' )
	{
		home->ViewGarden();	
	}
};

bool Martian::ChangeStatus( void )
{
	std::cout << "{?} Enter new status: ";
	std::string new_status;
	std::cin >> new_status;

	if ( new_status.size() > TMP_BUF_SIZE )
	{
		std::cout << "{-} Status size is to big!" << std::endl;
		return false;
	}

	if ( !CheckUserStatus( new_status ) )
	{
		std::cout << "{-} Bad chars is user status!" << std::endl;
		return false;
	}

	std::cout << "{+} Status is changed!" << std::endl;
	status = new_status;

	return true;
};

bool Martian::SaveFile( void )
{	
	std::string _filename = USER_STORAGE_PREFIX;
	_filename += name;

	const char* Filename = _filename.c_str();
	std::ofstream UserSaveFile( Filename );

	if ( !UserSaveFile )
	{
		std::cout << "{-} Some internal error! Cannot create file <";
		std::cout << Filename << ">" << std::endl;
		return false;
	}

	// write password
	const char password_size = (char) password.size();
	UserSaveFile.write( &password_size, sizeof( char ) );
	UserSaveFile.write( (const char*) password.c_str(), password_size );

	const char delimeter = 0x0a;
	UserSaveFile.write( &delimeter, sizeof( char ) );
	// write status
	UserSaveFile.write( (const char*) status.c_str(), status.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	// write stats
	// write health
	std::string str = std::to_string( health );
	const char* tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write hunger
	str = std::to_string( hunger );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write thirst
	str = std::to_string( thirst );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write stamina
	str = std::to_string( stamina );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write intelligence
	str = std::to_string( intelligence );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write repair_skill
	str = std::to_string( repair_skill );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	// write actions points
	str = std::to_string( actions );
	tmp = (const char*) str.c_str();

	UserSaveFile.write( tmp, str.size() );
	UserSaveFile.write( &delimeter, sizeof( char ) );

	str.clear();

	UserSaveFile.close();  

	return true;
};

bool Martian::LoadSaveFile( void )
{
	std::string Filename = USER_STORAGE_PREFIX + name;
	std::vector<BYTE> UserFileData = ReadFile( Filename );

	int data_idx = 0;
	int password_size = (int) UserFileData[ 0 ];
	data_idx = 1 + password_size; // this is id of first '\n'
	data_idx++;

	std::string tmp_buf;
	tmp_buf.reserve( TMP_BUF_SIZE );

	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	status = tmp_buf;
	tmp_buf.clear();
	data_idx++;

	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	health = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;

	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	hunger = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;
	
	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	thirst = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;
	
	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	stamina = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;
	
	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	intelligence = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;
	
	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	repair_skill = std::stod( tmp_buf );
	tmp_buf.clear();
	data_idx++;
	
	while ( UserFileData[ data_idx ] != '\n' )
	{
		tmp_buf.push_back( UserFileData[ data_idx++ ] );
	}

	actions = std::stoi( tmp_buf );
	tmp_buf.clear();

	return true;
};

bool Martian::EatPotatoes( void )
{
	Item* potato = home->GetItemByName( std::string( "potato" ) );

	if ( potato == NULL )
	{
		std::cout << "{-} You don't have potatoes!" << std::endl;
		return false;
	}

	if ( potato->get_count() == 0 )
	{
		std::cout << "{-} You don't have potatoes!" << std::endl;
		return false;
	}

	hunger -= 0.25;
	health += 5.5;

	CheckHealth();

	potato->del( 1 );

	std::cout << "{+} Now your <hunger> is <" << hunger << ">" << std::endl;
	std::cout << "{+} Now your <health> is <" << health << ">" << std::endl;

	return true;
};

bool Martian::DrinkWater( void )
{
	Item* water = home->GetItemByName( std::string( "drink water" ) );

	if ( water == NULL )
	{
		std::cout << "{-} You don't have water!" << std::endl;
		return false;
	}

	if ( water->get_count() == 0 )
	{
		std::cout << "{-} You don't have drink water!" << std::endl;
		return false;
	}

	thirst -= 0.15;
	water->del( 1 );

	std::cout << "{+} Now your <thirst> is <" << thirst << ">" << std::endl;

	return true;
};

bool Martian::PlantPotatoes( void )
{
	if ( home->GetStockStatus() )
	{
		std::cout << "{?} How much you want to plant: ";
		DWORD plant_count;
		std::cin >> plant_count;

		if ( plant_count <= 0 )
		{
			std::cout << "{-} Error count of plants!" << std::endl;
			return false;
		}

		if ( !CanDoAction( PLANT_POTATOES ) )
		{
			std::cout << "{-} You do not have enough activity points!" << std::endl;
			return false;
		}

		if ( home->CheckGarden( plant_count ) )
		{
			Item* potato = home->GetItemByName( "potato" );

			if ( potato == NULL )
			{
				std::cout << "{-} You don't have potatoes!" << std::endl;
				return false;
			}

			if ( plant_count > potato->get_count() )
			{
				std::cout << "{-} You don't have potatoes!" << std::endl;
				return false;
			}

			potato->del( plant_count );
			home->PlantPotatoes( plant_count );
		}
		else
		{
			std::cout << "{-} There is no place in the garden!" << std::endl;
			return false; 
		}
	}
	else
	{
		std::cout << "{-} Stock is overflowed!" << std::endl;
		return false;
	}

	return true;
};

bool Martian::RepairHome( void )
{
	if ( CanDoAction( REPAIR_HOME ) )
	{
		if ( home->GetHealth() < INIT_HP )
		{
			std::pair<bool,double> result = home->Repair( repair_skill );

			if ( !result.first && result.second > 0.0 )
			{
				health -= result.second;
				CheckHealth();
			}

			actions -= REPAIR_HOME;
			return result.first;
		}
		else
		{
			std::cout << "{+} The house does not require repair" << std::endl;
			return false;
		}
	}
	else
	{
		std::cout << "{-} You have no more action points today!" << std::endl;
		return false;
	}

	return true;
};

bool Martian::ReadBook( void )
{
	std::cout << "{?} How many times do you want to read a book: ";
	int count;
	std::cin >> count;

	if ( count < 0 | count > 24 )
	{
		std::cout << "{-} Error input!" << std::endl;
		return false;
	}

	int need_actions = (int) READ_BOOK * count;

	if ( need_actions > actions )
	{
		std::cout << "{-} You dont have action points!" << std::endl;
		return false;
	}

	if ( CanDoAction( READ_BOOK ) )
	{
		intelligence += 35 * count;
		actions -= READ_BOOK * count;
		std::cout << "Reading ";
		for ( int i = 0; i < 7; i++ )
		{
			std::cout << ".";
		}

		std::cout << std::endl;

		std::cout << "{+} You read the book. Intellect increased by <";
		std::cout << 35 * count << ">" << std::endl; 
	}
	else
	{
		std::cout << "{-} You have no more action points today!" << std::endl;
		return false;
	}

	return true;
};

void Martian::Damage( double value )
{
	health -= value;
	CheckHealth();
};

void Martian::SubStamina( double value )
{
	stamina -= value;
	
	if ( stamina <= 0.0 )
		stamina = 0.0;
};

bool Martian::CheckHealth( void )
{
	if ( health <= 0.0 )
	{
		std::cout << "{-} You died!" << std::endl;
		Die( name );
	}

	if ( health > INIT_HP )
	{
		health = INIT_HP;
	}

	return true;
};

bool Martian::MakeRaid( void )
{
	std::cout << "XxXxXxXxXx Raids xXxXxXxXxX" << std::endl;
	std::cout << "1. Easy raid" << std::endl;
	std::cout << "2. Medium raid" << std::endl;
	std::cout << "3. Hard raid" << std::endl; 

	std::cout << "Choose raid difficulty level: ";

	int _inp;
	std::cin >> _inp;

	if ( _inp <= 0 || _inp > 3 )
	{
		std::cout << "{-} Incorrect input!" << std::endl;
		return false;
	}

	switch ( _inp )
	{
		case 1:
		{	
			if ( !CanDoAction( MAKE_EASY_RAID ) )
			{
				std::cout << "{-} You do not have enough activity points!" << std::endl;
				return false;
			}

			actions -= MAKE_EASY_RAID;
			EasyRaid( this );
			break;
		}
		case 2:
		{
			if ( !CanDoAction( MAKE_MEDIUM_RAID ) )
			{
				std::cout << "{-} You do not have enough activity points!" << std::endl;
				return false;
			}

			actions -= MAKE_MEDIUM_RAID;
			MediumRaid( this );
			break;
		}
		case 3:
		{
			if ( intelligence <= 100.0 )
			{
				std::cout << "{-} You don't have <intelligence> !" << std::endl;
				return false;
			}

			if ( !CanDoAction( MAKE_HARD_RAID ) )
			{
				std::cout << "{-} You do not have enough activity points!" << std::endl;
				return false;
			}

			actions -= MAKE_HARD_RAID;
			HardRaid( this );
			break;
		}
	}

	return true;
};

bool Martian::GoToNextDay( void )
{
	if ( hunger > 0.0 )
		health -= hunger;
	
	if ( thirst > 0.0 )
		health -= thirst;

	if ( stamina > 0 )
		health += ( stamina * 0.01 );

	CheckHealth();

	home->Damage( 1.0 + ( repair_skill * 0.33 ) );

	if ( home->GetHealth() <= 0.0 )
	{
		std::cout << "{-} Your house is completely destroyed!" << std::endl;
		Die( name );
	}

	home->EnergyTick();
	actions = INIT_ACTIONS_POINTS;

	lifedays++;
	
	home->GardenTick();
	MakeRandomEvent();

	// stats corrections
	hunger  += 0.5;
	thirst  += 0.5;
	stamina -= 1.5;

	intelligence -= 3.77;

	if ( intelligence > 100.0 )
		repair_skill += ( intelligence * 0.001 );
	
	return true;
};

void Martian::MakeRandomEvent( void )
{
	int EventId = GetRandomEventId();

	if ( EventId > 990 && intelligence < 55.0 )
	{
		std::cout << "{..} During the day, you tried to improve";
		std::cout << "the work of the energy block, and at night"; 
		std::cout << "it exploded from overloading.";
		std::cout << "{-} You died!" << std::endl;
		Die( name );
	}

	if ( intelligence <= 0.0 )
	{
		std::cout << "{..} At night you decided to take a walk ...";
		std::cout << "and forgot to put on a spacesuit" << std::endl;
		std::cout << "{-} You died!" << std::endl;
		Die( name );
	}

	std::cout << "{..} Nothing happened" << std::endl;
};

inline std::string Martian::GetName( void )
{
	return name;
};

inline double Martian::GetHP( void )
{
	return health;
};

inline int Martian::GetAP( void )
{
	int ap = 0.001 * (stamina + intelligence);

	return ap;
};

inline int  Martian::GetStamina( void )
{
	return (int) stamina;
};

inline void Martian::RegenHP( void )
{
	health += stamina * 0.001;
	CheckHealth();
};

inline void Martian::AddStamina( double value )
{
	stamina += value;
};

inline int Martian::GetINT( void )
{
	return (int) intelligence;
};

inline std::vector<double> Martian::get( void )
{
	std::vector<double> stats;

	stats.push_back( health ); // 0
	stats.push_back( hunger ); // 1 
	stats.push_back( thirst ); // 2
	stats.push_back( stamina ); // 3 
	stats.push_back( intelligence ); // 4 
	stats.push_back( repair_skill ); // 5 

	return stats;
};

bool Martian::CanDoAction( ACTION_TYPE Action )
{
	return ( ( actions - Action ) >= 0 );
};

void Martian::AddItemToHomeStock( Item _new_item )
{
	home->AddItem( _new_item );
};

void Martian::SetTroph( std::string _troph )
{
	home->SetTrophy( _troph );
};

int EasyRaid( Martian* player )
{
	std::vector<double> stats = player->get();

	// check int
	if ( stats[ 4 ] <= 20.0 )
	{
		std::cout << "{-} During the raid, you found a chest";
		std::cout << "but you weren’t smart enough to open it";
		std::cout << std::endl;

		player->Damage( 5.0 );
		player->SubStamina( 1.0 );

		return 0;
	}

	std::random_device rd;
	std::mt19937 gen( rd() );
	std::uniform_int_distribution<> dis( 10000, 999999 );

	int value1 = dis( gen );
	int value2 = dis( gen );

	std::cout << "{?} During the raid, you found a chest." << std::endl;
	std::cout << "It has a lock on it, which can be opened" << std::endl;
	std::cout << " by entering the answer to the proposed example," << std::endl;
	std::cout << "however when you see the example, you will only " << std::endl;
	std::cout << "have 3 seconds to open." << std::endl;

	std::cout << value1 << "+" << value2 << " = ?" << std::endl;

	int start_time = (int) time( NULL );
	int answer = 0;

	std::cin >> answer;

	if ( ( (int) time( NULL ) - start_time ) > 3 )
	{
		std::cout << "{-} Time is out!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;
		player->Damage( 15.0 );

		return 0;
	}

	if ( answer == ( value1 + value2 ) )
	{
		std::cout << "{+} You managed to open the chest and there you found:" << std::endl;

		int potatoes_cnt = 8 + ( dis( gen ) % 2 );
		int water_cnt = 8 + ( dis( gen ) % 2 );

		std::cout << "potato: " << potatoes_cnt << std::endl;
		std::cout << "drink water: " << water_cnt << std::endl;

		Item _potato = storage->GetItemByName( "potato" );
		_potato.add( potatoes_cnt - 1 );

		Item _drink_water = storage->GetItemByName( "drink water" );
		_drink_water.add( water_cnt - 1 );

		player->AddItemToHomeStock( _potato );
		player->AddItemToHomeStock( _drink_water );

		player->AddStamina( 1.0 );
	}
	else
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;

		player->Damage( 15.0 );  
	}

	return 1;
};

int MediumRaid( Martian* player )
{
	std::vector<double> stats = player->get();

	// check INT
	if ( stats[ 4 ] <= 55.0 )
	{
		std::cout << "{-} During the raid, you found a chest";
		std::cout << "but you weren’t smart enough to open it";
		std::cout << "and it exploded and damaged you!" << std::endl;

		player->Damage( 25.0 );
		player->SubStamina( 5.0 );

		return 1;
	}

	BYTE monster_hp = 120;
	BYTE monster_attack = 12;
	BYTE monster_regen = 8;

	std::random_device rd;
	std::mt19937 gen( rd() );
	std::uniform_int_distribution<> dis( 1, 100 );

	std::cout << "{?} You found a chest, but it is guarded by some strange animals." << std::endl;
	std::cout << "{?} You were not able to get around it and it noticed you." << std::endl;
	std::cout << "{?} You have to fight." << std::endl;

	DWORD valid_code = (int) monster_hp + (int) monster_attack + (int) monster_regen;
	valid_code += (int) player->GetHP();
	valid_code = valid_code << 2;
	valid_code += player->GetINT();

	bool runaway = false;

	while ( monster_hp > 0 && !runaway )
	{
		std::cout << "Monster HP: " << (int) monster_hp << std::endl;
		std::cout << "Player HP: " << player->GetHP() << std::endl;

		std::cout << "--- Actions ---" << std::endl;
		std::cout << "1. Attack" << std::endl;
		std::cout << "2. Defence" << std::endl;
		std::cout << "3. Run away" << std::endl;
		std::cout << "> ";

		int option;
		std::cin >> option;

		int monster_move = dis( gen ) % 2;

		if ( option <= 0 || option > 3 )
		{
			std::cout << "{-} Incorrect option" << std::endl;
			continue;
		}

		switch ( option )
		{
			case 1:
			{
				std::cout << "{..} You attack!" << std::endl;

				if ( monster_move == 1 )
				{
					std::cout << "{..} The monster is also attacking!" << std::endl;
					monster_hp -= (BYTE) player->GetHP();
					player->Damage( (double) monster_attack );
				}
				else
				{
					std::cout << "{..} Monster defends itself!" << std::endl;
					monster_hp -= (BYTE) player->GetHP() / 2;
				}
				break;
			}
			case 2:
				std::cout << "{..} You defend" << std::endl;

				if ( monster_move == 1 )
				{
					std::cout << "{..} The monster attacks!" << std::endl;
					player->Damage( (double) monster_attack / 
						( 2.0 * (double)( player->GetStamina() * 0.05 ) ) );
				}
				else
				{
					std::cout << "{..} Monster is also defends itself!" << std::endl;
				}

				break;
			case 3:
			{
				std::cout << "{-} You ran away but lost a lot of health!" << std::endl;
				player->SubStamina( 10.0 );
				player->Damage( player->GetHP() / 2.0 );

				runaway = true;
				break;
			}
			default:
				break;
		}

		if ( monster_hp < 80 )
		{
			std::cout << "{...} Monster is raging! Attack power increase!" << std::endl;
			monster_attack += 50;
		}

		valid_code += 13;
		monster_hp += monster_regen;
		player->RegenHP();
	}
	
	if ( runaway )
	{
		return 1;
	}

	std::cout << "{+++} You killed a monster!!!" << std::endl;
	player->AddStamina( 350.0 );

	std::cout << "{?} You got a chest, but this time you";
	std::cout << " need to enter the password immediately";
	std::cout << " within 5 seconds" << std::endl;

	//std::cout << "valid_code: " << valid_code << std::endl; // DEBUG only
	std::cout << "Code: ";

	int start_time = (int) time( NULL );

	DWORD user_code;
	std::cin >> user_code;

	if ( ( (int) time( NULL ) - start_time ) > 5 )
	{
		std::cout << "{-} Time is out!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;
		player->Damage( 25.0 );

		return 1;
	}

	if ( user_code == valid_code )
	{
		std::cout << "{+} You managed to open the chest and there you found:" << std::endl;

		int potatoes_cnt = 3 + ( dis( gen ) % 10 );
		int water_cnt = 3 + ( dis( gen ) % 10 );
		int iron_cnt = 2 + ( dis( gen ) % 5 );
		int ground_cnt = 2 + ( dis( gen ) % 5 );

		std::cout << "potato: " << potatoes_cnt << std::endl;
		std::cout << "drink water: " << water_cnt << std::endl;
		std::cout << "iron: " << iron_cnt << std::endl;
		std::cout << "ground: " << ground_cnt << std::endl;

		Item _potato = storage->GetItemByName( "potato" );
		_potato.add( potatoes_cnt - 1 );

		Item _drink_water = storage->GetItemByName( "drink water" );
		_drink_water.add( water_cnt - 1 );

		Item _ground = storage->GetItemByName( "ground" );
		_ground.add( ground_cnt - 1 );

		Item _iron = storage->GetItemByName( "iron" );
		_iron.add( iron_cnt - 1 );

		player->AddItemToHomeStock( _potato );
		player->AddItemToHomeStock( _drink_water );
		player->AddItemToHomeStock( _ground );
		player->AddItemToHomeStock( _iron );
	}
	else
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;

		player->Damage( 25.0 );  
	}

	return 0;
};

// отладить проверку кода
int HardRaid( Martian* player )
{
	//std::vector<double> stats = player->get();

	// check INT
	if ( player->GetINT() <= 110.0 )
	{
		std::cout << "{-} During the raid, you found a chest";
		std::cout << "but you weren’t smart enough to open it";
		std::cout << "and it exploded and damaged you!" << std::endl;

		player->Damage( 35.0 );
		player->SubStamina( 10.0 );

		return 1;
	}

	int boss_HP = 30;
	std::string round_msg;

	double boss_AP = 13.37;

	std::cout << "{?} You found a chest, but it is guarded by strange Boss." << std::endl;
	std::cout << "{?} You were not able to get around it and it noticed you." << std::endl;
	std::cout << "{?} You have to fight." << std::endl;

	bool runaway = false;
	char* ptr_round_msg;
	BYTE fight_signature = 0;

	while ( boss_HP > 0 && !runaway )
	{

		std::random_device rd;
		std::mt19937 gen( rd() );
		std::uniform_int_distribution<> dis( 1, 100 );

		int monster_round_val = dis( gen ) % 4;

		fight_signature += monster_round_val;

		round_msg.reserve( msgs[ monster_round_val ].size() );
		round_msg.resize( msgs[ monster_round_val ].size() );
		round_msg.shrink_to_fit();

		round_msg = msgs[ monster_round_val ];
		ptr_round_msg = (char*) round_msg.c_str();

		std::cout << "Boss says: " << round_msg << std::endl;

		std::cout << "Boss HP: ";
		
		for ( int i = 0; i < boss_HP; i++ )
			std::cout << "|";
		
		std::cout << std::endl;

		std::cout << "Player HP: " << player->GetHP() << std::endl;

		std::cout << "--- Actions ---" << std::endl;
		std::cout << "1. Light attack" << std::endl;
		std::cout << "2. Medium attack" << std::endl;
		std::cout << "3. Difficult attack" << std::endl;
		std::cout << "4. Run away!" << std::endl;
		std::cout << "> ";

		int option;
		std::cin >> option;

		if ( option <= 0 || option > 4 )
		{
			std::cout << "{-} Incorrect option" << std::endl;
			continue;
		}

		fight_signature += option;

		switch ( option )
		{
			case 1:
			{	
				if ( player->GetINT() > 125.0 )
				{
					boss_HP -= 1;
				}
				break;
			}
			case 2:
			{
				if ( player->GetINT() > 200.0 )
				{
					boss_HP -= 2;
				}
				else
				{
					std::cout << "{-} You could not complete this attack!" << std::endl;
				}
				break;
			}
			case 3:
			{
				if ( player->GetINT() > 250.0 )
				{
					if ( player->GetStamina() > 90 )
					{
						boss_HP -= 5;
					}
				}
				else
				{
					std::cout << "{-} You could not complete this attack!" << std::endl;
				}
				break;
			}
			case 4:
			{
				std::cout << "{-} You ran away but lost a lot of health!" << std::endl;
				player->SubStamina( 25.0 );
				player->Damage( player->GetHP() / 1.75 );

				runaway = true;
				break;
			}
			default:
				break;
		}

		if ( runaway )
			break;

		double damage = boss_AP * ( (double) ( monster_round_val + 1 ) * 1.337 );
		damage -= (double)player->GetStamina() * 0.2337;
		
		if ( damage < 0.0 )
			damage = 0.0;

		std::cout << "{.} Boss damage on this round: " << damage << std::endl;
		player->Damage( damage );
		player->RegenHP();
	}
	
	if ( runaway )
	{
		std::cout << "{?} You can say a few words last: ";
		std::cin >> ptr_round_msg;
		return 1;
	}

	std::cout << "{+} Wooooow you win the boss!" << std::endl;
	player->AddStamina( 30.0 );

	std::cout << "{?} You got a chest, but this time you";
	std::cout << " need to enter the code immediately";
	std::cout << " within 5 seconds" << std::endl;

	std::cout << "Code: ";

	int start_time = (int) time( NULL );

	std::string user_code;
	std::cin >> user_code;

	if ( ( (int) time( NULL ) - start_time ) > 5 )
	{
		std::cout << "{-} Time is out!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;
		player->Damage( 35.0 );

		return 1;
	}

	bool lose = false;
	// check user code correction!
	if ( user_code.size() < 16 || user_code.size() > 32 )
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		lose = true;
	}

	// check delimeters
	else if ( user_code[ 5 ] != '-' || user_code[ 11 ] != '-' )
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		lose = true;
	}

	if ( lose )
	{
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;
		player->Damage( 35.0 );
		return 1;
	}

	WORD first_part; 
	char tmp[ 5 ];
	memcpy( (void*) tmp, (void*) user_code.c_str(), 5 );
	first_part = std::atoi( (const char*)&tmp[ 0 ] );

	std::string second_part;
	std::string third_part;

	for ( int i = 6; i < 11; i++ )
		second_part.push_back( user_code[ i ] );

	for ( int i = 12; i < 17; i++ )
		third_part.push_back( user_code[ i ] );
	
	// check first value 
	//unsigned short crc_ccitt_update (unsigned short crc, unsigned char data)

	WORD t;
	WORD crc = 0xffff;
	BYTE data = fight_signature;

	data ^= crc & 255;
	data ^= data << 4;

	t = (((WORD)data << 8) | ((crc>>8)&255));
	t ^= (WORD)(data >> 4);
	t ^= ((WORD)data << 3);
	
	if ( first_part != t )  
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;
		player->Damage( 35.0 );

		return 1;
	}

	// check second value 
	int xor_res = 0;

	for ( int i = 0; i < 5; i++ )
	{
		xor_res ^= (int) second_part[ i ];
	}

	fight_signature ^= 65;
	if ( xor_res != ( fight_signature & 0x7f ) ) // debug condition 
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you" << std::endl;
		player->Damage( 35.0 );

		return 1;
	}

	// check third value
	std::string _name = player->GetName();
	std::string NameHash = _hash( _name );
	std::string third_part_correct; 

	bool flags[ 5 ] = { true, true, true, true, true };

	for ( int i = 1; i < 1000; i++ )
	{	
		// 0 
		if ( ( i % 3 == 0 ) && ( i % 7 == 0 ) && ( i % 13 == 0 ) && flags[ 0 ] )
		{
			// idx = 8 
			int idx = ( ( ( i ^ 0x7f ) >> 3 ) ^ 13 ) / 4;
			third_part_correct.push_back( (char) NameHash[ idx ] );
			flags[ 0 ] = false;
			continue;
		}

		// 3
		else if ( ( i % 17 == 0 ) && ( i % 23 == 0 ) && flags[ 1 ] )
		{
			// idx = 7 
			int idx = i & 0x7f;
			third_part_correct.push_back( (char) NameHash[ idx ] );
			flags[ 1 ] = false;
			continue;
		}

		// 2 
		else if ( ( i % 11 == 0 ) && ( i % 34 == 0 ) && flags[ 2 ] )
		{
			// idx = 0
			int idx = ( ( ( i ^ 137 ) & 0xff ) ^ 0x7f ) % 16;
			third_part_correct.push_back( (char) NameHash[ idx ] );
			flags[ 2 ] = false;
			continue;
		}

		// 4
		else if ( ( i % 22 == 0 ) && ( i % 41 == 0 ) && flags[ 3 ] ) 
		{
			// idx = 12
			int idx = ( ( ( i / 2 ) & 0xff ) ^ 127 ) % 16;
			third_part_correct.push_back( (char) NameHash[ idx ] );
			flags[ 3 ] = false;
			continue;
		}

		// 1
		else if ( ( i % 111 == 0 ) && ( i % 9 == 0 ) && flags[ 4 ] ) 
		{
			// idx = 10
			int idx = ( i >> 5 );
			third_part_correct.push_back( (char) NameHash[ idx ] );
			flags[ 4 ] = false;
			continue;
		}
	}
	
	bool incorrect_code = false;

	for ( int i = 0; i < 5; i++ )
	{
		if ( third_part[ i ] != third_part_correct[ i ] )
		{
			incorrect_code = true;
		}
	}

	if ( incorrect_code )
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you" << std::endl;
		player->Damage( 35.0 );

		return 1;
	}

	// CORRECT CODE ENTERED
	std::cout << "{+} You managed to open the chest and there you found:" << std::endl;

	std::random_device rd;
	std::mt19937 gen( rd() );
	std::uniform_int_distribution<> dis( 1, 100 );

	int potatoes_cnt = 7 + ( dis( gen ) % 15 );
	int water_cnt = 5 + ( dis( gen ) % 15 );
	int iron_cnt = 5 + ( dis( gen ) % 10 );
	int ground_cnt = 5 + ( dis( gen ) % 10 );

	std::cout << "potato: " << potatoes_cnt << std::endl;
	std::cout << "drink water: " << water_cnt << std::endl;
	std::cout << "iron: " << iron_cnt << std::endl;
	std::cout << "ground: " << ground_cnt << std::endl;

	Item _potato = storage->GetItemByName( "potato" );
	_potato.add( potatoes_cnt - 1 );

	Item _drink_water = storage->GetItemByName( "drink water" );
	_drink_water.add( water_cnt - 1 );

	Item _ground = storage->GetItemByName( "ground" );
	_ground.add( ground_cnt - 1 );

	Item _iron = storage->GetItemByName( "iron" );
	_iron.add( iron_cnt - 1 );

	// add all Items* file context in stock
	std::string great_trophy( "Ancient knowledge: " );

	std::string path( USER_STORAGE_PREFIX );
    for (const auto & entry :  std::filesystem::directory_iterator(path))
    {
    	std::string file_path = entry.path();
        
        if ( file_path[ 6 ] != 'I' || 
        	 file_path[ 7 ] != 't' ||
        	 file_path[ 8 ] != 'e' ||
      		 file_path[ 9 ] != 'm' 
      		) 
      		continue;

        std::vector<BYTE> FileData = ReadFile( file_path );
        int idx = 0;

        while ( FileData[ idx++ ] != '\n' )
        	continue;

       	std::string ItemStatus;

       	while ( FileData[ idx ] != '\n' )
       		ItemStatus.push_back( FileData[ idx++ ] );

       	great_trophy += ItemStatus;
       	great_trophy += '\n';
    }

	player->AddItemToHomeStock( _potato );
	player->AddItemToHomeStock( _drink_water );
	player->SetTroph( great_trophy );
	player->AddItemToHomeStock( _ground );
	player->AddItemToHomeStock( _iron );

	return 0;
};
