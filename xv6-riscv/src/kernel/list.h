#ifndef LIST_H
#define LIST_H

#define offsetof(type, member) ((unsigned long)&((type *)0)->member)

struct node {
	struct node *next;
	struct node *prev;
};

struct list {
	struct node *head;
	struct node *tail;
};

// Get a pointer to the struct containing this node
#define container_of(ptr, type, member) \
	((type *)((char *)(ptr) - offsetof(type, member)))

void init_list_node(struct list *list);
int  list_insert(struct list *list, struct node *item);
int  list_remove(struct list *list, struct node *item);

#endif

