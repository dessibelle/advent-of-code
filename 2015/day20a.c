#include <stdio.h>
#include <stdlib.h>


int presents_for_house(int house) {
    int num_presents = 0;

    for (int i = 1; i <= house; i++) {
        if (house % i == 0) {
            num_presents += 10 * i;
        }
    }

    return num_presents;
}

int first_house_matching_target(int target) {
    int num_presents = 0;
    int house = 0;

    while (num_presents < target) {
        house++;
        num_presents = presents_for_house(house);
    }

    return house;

}

int clean_stdin()
{
    while (getchar() != '\n');
    return 1;
}

int main(int argc, char* argv[]) {

    int target = atoi(argv[1]);
    char c;

    if (target < 1) {
        do
        {
            printf("Enter a target number of presents: ");

        } while (((scanf("%d%c", &target, &c) != 2 || c != '\n') && clean_stdin()) || target < 1);
    }

    int house = first_house_matching_target(target);

    printf("House %d\n", house);

    return 0;

}
