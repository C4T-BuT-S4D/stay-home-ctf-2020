#include "main.hpp"

/*
TODO:
1. Добавить алгоритм проверки ключа в сложном рейде
2. Добавить запись очков активности в сейф-файл
3. Протестировать сборку на линуксе и проверить включен ли pie
4. Добавить уязвимость для обхода pie
5. Убрать отладочные выводы
6. Протестировать руками все менюшки (на сколько это возможно)
7. Написать экслоит на обе уязвимости
8. Написать примеры бинарных патчей
9. Написать чекер
*/

std::string Username;

int main( int argc, char* argv[], char* envp[] )
{
	Setup();

	char login_lifes = 3;
	char reg_lifes = 5;

	while ( true && login_lifes > 0 && reg_lifes > 0 )
	{
		LoginMenu();
		char option;

		std::cin >> option;

		switch( option )
		{
			case '1':
			{
				if ( Login() )
					Session();
				else
					login_lifes--;	
				break;
			}
			case '2':
				if ( !Registration() )
					reg_lifes--;
				break;
			case '3':
				exit( -1 );
				break;
			default:
				login_lifes--;
				break;
		}
	}

	return 0;
};

void Setup( void )
{
	init_alphs();
	
	setvbuf( stdin,  0, 2, 0 );
	setvbuf( stdout, 0, 2, 0 );
	setvbuf( stderr, 0, 2, 0 );
};

void LoginMenu( void )
{
	std::cout << "*****************************************" << std::endl;
	std::cout << "**************** Martian ****************" << std::endl;
	std::cout << "*****************************************" << std::endl;

	std::cout << "1. Login" << std::endl;
	std::cout << "2. Registration" << std::endl;
	std::cout << "3. Exit" << std::endl;
	std::cout << "> ";
};


bool Registration( void )
{
	std::cout << "{?} Enter username: ";
	std::cin >> Username;

	if ( !CheckUsernameFormat( Username ) )
	{
		std::cout << "{-} Incorrect username format!" << std::endl;
		return false;
	}

	if ( FileExist( USER_STORAGE_PREFIX + Username ) )
	{
		std::cout << "{-} User already exist!" << std::endl;
		return false;
	}

	std::cout << "{?} Password: ";
	std::string Password;
	std::cin >> Password;

	if ( !CheckPasswordFormat( Password ) ) 
	{
		std::cout << "{-} Incorrect password format!" << std::endl;
		return false;
	}

	Martian *new_player = new Martian( Username, Password );
	new_player->SaveFile();
	delete new_player;

	return true;
};

bool Login( void )
{
	std::cout << "{?} Enter username: ";
	std::cin >> Username;

	if ( !CheckUsernameFormat( Username ) )
	{
		std::cout << "{-} Incorrect username format!" << std::endl;
		return false;
	}

	if ( !FileExist( USER_STORAGE_PREFIX + Username ) )
	{
		std::cout << "{-} No such user!" << std::endl;
		return false; 
	}

	std::cout << "{?} Enter password: ";
	std::string Password;
	std::cin >> Password;

	if ( !CheckPasswordFormat( Password ) )
	{
		std::cout << "{-} Incorrect password format!" << std::endl;
		return false;
	}

	if ( !CheckUserPassword( Username, Password ) )
	{
		std::cout << "{-} Incorrect password!" << std::endl;
		return false;
	}
 	
 	std::cout << "{+} Login is successful!" << std::endl;
 	
 	current_player = new Martian( Username, Password );
 	current_player->LoadSaveFile();
 	//current_player->ViewUserStats();

	return true;
};


void Session( void )
{	
	int cnt = 10;

	while( true && cnt > 0 ) 
	{
		UserMenu();

		int UserInput;
		std::cin >> UserInput;

		if ( UserInput <= 0 || UserInput > 11 )
		{
			std::cout << "{-} Incorrect option!" << std::endl;
			UserInput = 0;
			cnt--;
			continue;
		}

		switch( UserInput )
		{
			case 1:
				current_player->ViewUserStats(); // +
				break;
			case 2:
				current_player->ChangeStatus();
				break;
			case 3:
				current_player->EatPotatoes(); // +
				break;
			case 4:
				current_player->DrinkWater(); // +
				break;
			case 5:
				current_player->PlantPotatoes(); // +
				break;
			case 6:
				current_player->ReadBook(); // +
				break;
			case 7:
				current_player->MakeRaid();
				break;
			case 8:
				current_player->RepairHome(); // +
				break;
			case 9:
				current_player->GoToNextDay(); // +
				break;
			case 10:
				current_player->SaveFile(); // +
				break;
			case 11:
				exit( 10 );
				break;
			default:
				cnt--;
				break;
		}
	}
};

void UserMenu( void )
{
	std::cout << "|------- Profile [" << Username << "] -------|" << std::endl;
	std::cout << "1. View stats" << std::endl;
	std::cout << "2. Change status" << std::endl;
	std::cout << "3. Eat potatoes" << std::endl;
	std::cout << "4. Drink water" << std::endl;
	std::cout << "5. Plant potatoes" << std::endl;
	std::cout << "6. Read book" << std::endl;
	std::cout << "7. Explore the desert" << std::endl;
	std::cout << "8. Repair home" << std::endl; 
	std::cout << "9. Go to next day" << std::endl;
	std::cout << "10. Save progress" << std::endl;
	std::cout << "11. Exit" << std::endl;

	std::cout << "[>] ";
};
