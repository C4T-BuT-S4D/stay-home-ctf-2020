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

	//ViewUserStats(); // debug only
};

void Martian::ViewUserStats( void )
{
	std::cout << "***--- Profile ---***" << std::endl; 
	std::cout << "User: " << name << std::endl;
	std::cout << "Status: " << status << std::endl;

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
	
	std::cout << "prefix = " << USER_STORAGE_PREFIX << std::endl;
	std::cout << "name = " << name << std::endl;
	std::cout << "_filename = " << _filename << std::endl;
	std::cout << "Filename = " << Filename << std::endl;

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
	potato->del( 1 );

	std::cout << "{+} Now your <hunger> is <" << hunger << ">" << std::endl;
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
	if ( CanDoAction( READ_BOOK ) )
	{
		intelligence += 2.5;
		actions -= READ_BOOK;
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
		Die();
		exit( -1 );
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
			if ( intelligence >= 100.0 )
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

	//std::cout << "night event: " << EventId << std::endl;

	if ( EventId == NIGHT_DESTINY )
	{
		std::cout << "{..} At night, a storm suddenly rose and demolished your house" << std::endl;
		std::cout << "{-} You died!" << std::endl;
		Die();
	}

	if ( EventId > NIGHT_INT_IS_POWER && intelligence < 55.0 )
	{
		std::cout << "{..} During the day, you tried to improve";
		std::cout << "the work of the energy block, and at night"; 
		std::cout << "it exploded from overloading.";
		std::cout << "{-} You died!" << std::endl;
		Die();
	}

	if ( EventId == NIGHT_CHOKED )
	{
		std::cout << "{..} In a dream, you choked and suffocated" << std::endl;
		std::cout << "{-} You died!" << std::endl;
		Die();
	}

	if ( intelligence <= 0.0 )
	{
		std::cout << "{..} At night you decided to take a walk ...";
		std::cout << "and forgot to put on a spacesuit" << std::endl;
		std::cout << "{-} You died!" << std::endl;
		Die();
	}

	std::cout << "{..} Nothing happened" << std::endl;
};

std::string Martian::GetName( void )
{
	return name;
};

inline std::vector<double> Martian::get( void )
{
	std::vector<double> stats;

	stats.push_back( health ); // 0
	stats.push_back( hunger ); // 1 
	stats.push_back( thirst ); // 2
	stats.push_back( stamina ); // 3 
	stats.push_back( intelligence ); // 4 
	stats.push_back( repair_skill );

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

int EasyRaid( Martian* player )
{
	std::vector<double> stats = player->get();

	if ( stats[ 4 ] <= 20.0 )
	{
		std::cout << "{-} During the raid, you found a chest";
		std::cout << "but you weren’t smart enough to open it";

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

	if ( (int) time( NULL ) - start_time > 3 )
	{
		std::cout << "{-} Time out!" << std::endl;
		return 0;
	}

	if ( answer == ( value1 + value2 ) )
	{
		std::cout << "{+} You managed to open the chest and there you found" << std::endl;

		int potatoes_cnt = 1 + ( dis( gen ) % 3 );
		int water_cnt = 1 + ( dis( gen ) % 3 );

		std::cout << "potato: " << potatoes_cnt << std::endl;
		std::cout << "drink water: " << water_cnt << std::endl;

		Item _potato = storage->GetItemByName( "potato" );
		_potato.add( potatoes_cnt - 1 );

		Item _drink_water = storage->GetItemByName( "drink water" );
		_drink_water.add( water_cnt - 1 );

		player->AddItemToHomeStock( _potato );
		player->AddItemToHomeStock( _drink_water );
	}
	else
	{
		std::cout << "{-} Incorrect code!" << std::endl;
		std::cout << "{-} The chest exploded and damaged you!" << std::endl;

		player->Damage( 5.0 );  
	}

	return 1;
};

int MediumRaid( Martian* player )
{
	std::cout << "todo!" << std::endl;
};

int HardRaid( Martian* player )
{
	std::cout << "todo!" << std::endl;
};
