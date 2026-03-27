#include "list.h"

void init_list_node(struct list *list) {
	list->head = 0;
	list->tail = 0;
}

int list_insert(struct list *list, struct node *item) {
	item->prev = list->tail;
	item->next = 0;

	if (list->tail)
		(list->tail)->next = item;
	else
		list->head = item; // list was empty

	list->tail = item;
	return 1;
}

int list_remove(struct list *list, struct node *item) {
	if (item->prev)
		item->prev->next = item->next;
	else
		list->head = item->next; // removing head

	if (item->next)
		item->next->prev = item->prev;
	else
		list->tail = item->prev; // removing tail

	item->next = 0;
	item->prev = 0;
	return 1;
}
