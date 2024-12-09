//Author: AccelerateZ
#include <iostream>
#include <cstdio>
using namespace std;

const int ROWS = 6, COLS = 7;
int board[ROWS][COLS] = { 0 };
int indicator[COLS] = { 5, 5, 5, 5, 5, 5, 5 };

void printBoard(int board[ROWS][COLS]) {
	cout<<" 0 1 2 3 4 5 6"<<endl;
	for(int i = 0; i < ROWS; i++) {
		cout<<"|";
		for(int j = 0; j < COLS; j++) {
			if(board[i][j] == 0){
				cout<<"_"<<"|";
			}
			else if (board[i][j] == 1) {
				cout<<"*"<<"|";
			}
			else if (board[i][j] == 2) {
			    cout<<"+"<<"|";
			}
		}
		cout<<endl;
	}
	return;
}

bool isVaildToken(int col) {
	if (col >= 0 && col <= 6 && indicator[col] >= 0) {
		return true;
	} else{
		cout << "Invalid column, please try again." << endl;
		return false;
	}
}

void placeToken(int currentPlayer) {
	cout << "Player " << currentPlayer << ", it is your turn." << endl;
	while (true) {
		int c;
		cout << "Select a column to play. Must be between 0 and 6." << endl;
		cin >> c;
		if (isVaildToken(c)) {
			board[indicator[c]][c] = currentPlayer;
			indicator[c]--;
			break;
		}
	}
	printBoard(board);
}

bool isBoardFull() {
    for (int i = 0; i < COLS; ++i) {
        if (indicator[i] >= 0) {
            return false;
        }
    }
    return true;
}

bool checkWin(int player){
	for(int i=0; i<ROWS; i++){
		for(int j=0; j<COLS; j++){
			if(board[i][j] == player){
				if(i-3>=0 && board[i-1][j] == player && board[i-2][j] == player && board[i-3][j] == player){ // Horizontal
					return true;
				}
				if(j+3<COLS && board[i][j+1] == player && board[i][j+2] == player && board[i][j+3] == player){ // Vertical
					return true;
				}
				if(i-3>=0 && j+3<COLS && board[i-1][j+1] == player && board[i-2][j+2] == player && board[i-3][j+3] == player){ // Diagonal
					return true;
				}
				if(i+3<ROWS && j+3<COLS && board[i+1][j+1] == player && board[i+2][j+2] == player && board[i+3][j+3] == player){ // Diagonal
					return true;
				}
			}
		}
	}
	return false;
}

int togglePlayer(int currentPlayer) {
	if (currentPlayer == 1) {
		return 2;
	} else {
		return 1;
	}
}

int main()
{
	int currentPlayer = 1;
	cout << "Welcome to connect-4 the MIPS version!" << endl;
	cout << "This is a 2 player game, each player will take turns placing a token. "<<endl;
	cout << "The objective is to create a line of 4 consecutive tokens." << endl;
	cout << "Good Luck!" << endl;
	printBoard(board);
	while (true){
		placeToken(currentPlayer);
		if (checkWin(currentPlayer)){
			cout << "Player " << currentPlayer << " wins!" << endl;
			break;
		}
		else if (isBoardFull()){
			cout << "The board is full, it's a draw!" << endl;
			break;
		}
		else{
			currentPlayer = togglePlayer(currentPlayer);
		}
	}
	return 0;
}