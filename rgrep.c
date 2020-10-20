#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#define MAXSIZE 4096

/**
* You can use this recommended helper function
* Returns true if partial_line matches pattern, starting from
* the first char of partial_line.
*/


int matches_leading(char *partial_line, char *pattern) {
	int i = 0;
	int j = 0;
	int count = 0;
	while (pattern[i] != '\0')
	{
		if (partial_line[j] == '\0')
		{
			return 0; //if there is no match
		}
		else if (partial_line[j] == '\n')
		{
			j++; //this skips a line if a new line is passed through partial_line
		}
		else if (pattern[i] == '+' && pattern[i - 1] == '\\')
		{
			if (pattern[i] == partial_line[j])
			{
				i++;
				j++;
			}
			else
			{
				i = 0;
				j++;
			}
		}
		else if (pattern[i] == '.' && pattern[i - 1] == '\\')
		{
			if (pattern[i] == partial_line[j])
			{
				i++;
				j++;
			}
			else
			{
				i = 0;
				j++;
			}
		}
		else if (pattern[i + 1] == '\\' && pattern[i] == '\\')
		{
			if (pattern[i + 1] == partial_line[j])
			{
				i += 2;
				j++;
			}
			else
			{
				i = 0;
				j++;
			}
		}
		else if (pattern[i] == '?' && pattern[i - 1] == '\\')
		{
			if (pattern[i] == partial_line[j])
			{
				i++;
				j++;
			}
			else
			{
				i = 0;
				j++;
			}
		}
		else if (pattern[i] == '\\' && (pattern[i + 1] != '+' || pattern[i + 1] != '.' || pattern[i + 1] != '?' || pattern[i + 1] != '\\'))
		{
			if (pattern[i + 1] == partial_line[j])
			{
				i += 2;
				j++;
			}
			else
			{
				i = 0;
				j++;
			}
		}
		else if ((pattern[i] == '+') && (pattern[i - 1] != '\\'))
		{
			count++;
			char bplus = pattern[i - 1];
			if (bplus == '.') //this has to be done for the period case because if it wasn't here then it would just keep on looking for a period
			{
				bplus = partial_line[j]; //this makes the char before the plus euqal the char before the period
			}

			while (bplus == partial_line[j])
			{
				j++; //when it matches then it keeps going
			}
			i++;
			int pattern_len = strlen(pattern);
			int line_len = strlen(partial_line);

			while ((pattern[i] == bplus) && ((pattern_len - count) < (line_len)))
			{
				i++; //checks the string lengths so it doesn't print out any gthing that doesn't match 
			}

		}
		else if ((pattern[i] == partial_line[j]) || (pattern[i] == '.' && partial_line[j + 1] != '\0' && pattern[i - 1] != '\\')) //make the period act like it is null
		{
			i++;
			j++;
		}
		else if (pattern[i] == '\\')
		{
			i++;
		}
		else if (pattern[i] != partial_line[j])
		{
			i = 0;
			j++;
		}
		else
		{
			return 0; //no matches
		}
	}

	return 1;
}
/**
* You may assume that all strings are properly null terminated
* and will not overrun the buffer set by MAXSIZE
*
* Implementation of the rgrep matcher function
*/
int rgrep_matches(char *line, char *pattern) {
	int i = 0;
	int check = 1; //checks if \\ and ? are used
	int val = 0; //needed for the no return value warning by make
	while (pattern[i] != '\0') //Goes through the text to see if ? and \\ are found
	{
		if ((pattern[i] == '?') || (pattern[i] == '\\'))
		{
			check = 0; //changes the value of check if ? and \\ are found
		}
		i++;
	}

	if (check == 1) //an if statement if ? and \\ aren't found
	{
		val = matches_leading(line, pattern);
	}

	else //if check == 0 then it looks for where the ? and\\ are located
	{
		i = 0;
		if (pattern[i] == '?' || pattern[i - 1] != '\\')
		{
			char no_char[strlen(pattern) - 2];
			char cha[strlen(pattern) - 1];

			int j = 0;
			int k = 0;

			while (pattern[j] != '\0') //has character
			{
				if (pattern[j] == '?')
				{
					j++;
				}
				cha[k] = pattern[j];

				j++;
				k++;
			}

			j = 0;
			k = 0;

			while (pattern[j] != '\0') //no character
			{
				if (pattern[j + 1] == '?') //if statement for if the next char is a ?
				{
					j += 2; //this skips the char and the ?
				}
				no_char[k] = pattern[j];
				j++;
				k++;
			}


			//so when using match_leading it wouldn't work completly, so I just made two ints that will work like a boolean

			int set_char = 0;
			int set_no_char = 0;
			set_no_char = matches_leading(line, no_char);
			set_char = matches_leading(line, cha);

			if (set_no_char || set_char)
			{
				val = 1;
			}
		}
		if (pattern[i] == '?' && pattern[i - 1] == '\\')
		{
			matches_leading(line, pattern);
		}
	}
	return val;
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
		return 2;
	}

	/* we're not going to worry about long lines */
	char buf[MAXSIZE];

	while (!feof(stdin) && !ferror(stdin)) {
		if (!fgets(buf, sizeof(buf), stdin)) {
			break;
		}
		if (rgrep_matches(buf, argv[1])) {
			fputs(buf, stdout);
			fflush(stdout);
		}
	}

	if (ferror(stdin)) {
		perror(argv[0]);
		return 1;
	}

	return 0;
}