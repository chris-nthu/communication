#include<stdio.h>
#include<stdlib.h>

struct linklist{
	int data;
	// char prime;
	struct linklist *next;
	struct linklist *previous;
};
typedef struct linklist node;

int main(){
	
	node *head = NULL, *ptr;
	
	int n, fact = 0, i;
	scanf("%d", &n);
	for(i=1; i<=n; i++)
	{
		if ( n % i == 0 )
		{
			fact += i;
			if ( head == NULL )
			{
				head = (node*) malloc ( sizeof(node) );
				head->data = fact;
				head->next = NULL;
				head->previous = NULL;
				ptr = head;	
			}
			else
			{
				ptr->next = (node*) malloc ( sizeof(node) );
				ptr->next->previous = ptr;
				ptr = ptr->next;
				ptr->data = fact;
				ptr->next = NULL;
			}
		}
		fact = 0;	
	}
	
	ptr = head;
	while ( ptr != NULL )
	{
		printf("%d\n", ptr->data);
		ptr = ptr->next;
	}
	
	/*
	printf("%d\n", ptr->data);
	ptr = ptr->previous;
	while ( ptr != NULL )
	{
		printf("%d\n", ptr->data);
		ptr = ptr->previous;
	}
	*/
	
	
	return 0;
}
