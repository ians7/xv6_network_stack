
user/_xv6test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_func_shared>:
  printf("Thread %d is running\n", val);
  free(arg);
  return (void *)(uintptr_t)(val + 1);
}

void* thread_func_shared(void *arg) {
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  int i;
  for (i = 0; i < 50; i++) {
       8:	00002717          	auipc	a4,0x2
       c:	7d872703          	lw	a4,2008(a4) # 27e0 <shared_counter>
      10:	0017079b          	addiw	a5,a4,1
      14:	0337071b          	addiw	a4,a4,51
      18:	86be                	mv	a3,a5
      1a:	2785                	addiw	a5,a5,1
      1c:	fee79ee3          	bne	a5,a4,18 <thread_func_shared+0x18>
      20:	00002797          	auipc	a5,0x2
      24:	7cd7a023          	sw	a3,1984(a5) # 27e0 <shared_counter>
    shared_counter++;
  }

  return 0;
}
      28:	4501                	li	a0,0
      2a:	60a2                	ld	ra,8(sp)
      2c:	6402                	ld	s0,0(sp)
      2e:	0141                	addi	sp,sp,16
      30:	8082                	ret

0000000000000032 <exit_all>:
void *exit_all(void *args) {
      32:	1141                	addi	sp,sp,-16
      34:	e406                	sd	ra,8(sp)
      36:	e022                	sd	s0,0(sp)
      38:	0800                	addi	s0,sp,16
  if (val == 9) {
      3a:	4118                	lw	a4,0(a0)
      3c:	47a5                	li	a5,9
      3e:	02f70563          	beq	a4,a5,68 <exit_all+0x36>
  sleep(100);
      42:	06400513          	li	a0,100
      46:	00001097          	auipc	ra,0x1
      4a:	a1c080e7          	jalr	-1508(ra) # a62 <sleep>
  printf("Test 6 FAILED: exit_all failed\n");
      4e:	00001517          	auipc	a0,0x1
      52:	11250513          	addi	a0,a0,274 # 1160 <ithread_join+0x4c>
      56:	00001097          	auipc	ra,0x1
      5a:	d02080e7          	jalr	-766(ra) # d58 <printf>
}
      5e:	4501                	li	a0,0
      60:	60a2                	ld	ra,8(sp)
      62:	6402                	ld	s0,0(sp)
      64:	0141                	addi	sp,sp,16
      66:	8082                	ret
    sleep(5);
      68:	4515                	li	a0,5
      6a:	00001097          	auipc	ra,0x1
      6e:	9f8080e7          	jalr	-1544(ra) # a62 <sleep>
    exit(0);
      72:	4501                	li	a0,0
      74:	00001097          	auipc	ra,0x1
      78:	95e080e7          	jalr	-1698(ra) # 9d2 <exit>

000000000000007c <prop_mem_dealloc2>:
{
      7c:	1101                	addi	sp,sp,-32
      7e:	ec06                	sd	ra,24(sp)
      80:	e822                	sd	s0,16(sp)
      82:	e426                	sd	s1,8(sp)
      84:	1000                	addi	s0,sp,32
  sleep(60); // wait for allocation
      86:	03c00513          	li	a0,60
      8a:	00001097          	auipc	ra,0x1
      8e:	9d8080e7          	jalr	-1576(ra) # a62 <sleep>
  int val = p[0]; // should be 42 before deallocation
      92:	00002497          	auipc	s1,0x2
      96:	73e48493          	addi	s1,s1,1854 # 27d0 <p>
      9a:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
      9c:	438c                	lw	a1,0(a5)
      9e:	00001517          	auipc	a0,0x1
      a2:	0e250513          	addi	a0,a0,226 # 1180 <ithread_join+0x6c>
      a6:	00001097          	auipc	ra,0x1
      aa:	cb2080e7          	jalr	-846(ra) # d58 <printf>
  sleep(40); // wait for deallocation
      ae:	02800513          	li	a0,40
      b2:	00001097          	auipc	ra,0x1
      b6:	9b0080e7          	jalr	-1616(ra) # a62 <sleep>
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
      ba:	6098                	ld	a4,0(s1)
      bc:	37ab77b7          	lui	a5,0x37ab7
      c0:	078a                	slli	a5,a5,0x2
      c2:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab46ef>
      c6:	04f70763          	beq	a4,a5,114 <prop_mem_dealloc2+0x98>
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
      ca:	00001517          	auipc	a0,0x1
      ce:	0ee50513          	addi	a0,a0,238 # 11b8 <ithread_join+0xa4>
      d2:	00001097          	auipc	ra,0x1
      d6:	c86080e7          	jalr	-890(ra) # d58 <printf>
  fail = p[0]; // this should ideally trap or fail
      da:	00002797          	auipc	a5,0x2
      de:	6f67b783          	ld	a5,1782(a5) # 27d0 <p>
      e2:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e4:	85a6                	mv	a1,s1
      e6:	00001517          	auipc	a0,0x1
      ea:	10250513          	addi	a0,a0,258 # 11e8 <ithread_join+0xd4>
      ee:	00001097          	auipc	ra,0x1
      f2:	c6a080e7          	jalr	-918(ra) # d58 <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f6:	85a6                	mv	a1,s1
      f8:	00001517          	auipc	a0,0x1
      fc:	10850513          	addi	a0,a0,264 # 1200 <ithread_join+0xec>
     100:	00001097          	auipc	ra,0x1
     104:	c58080e7          	jalr	-936(ra) # d58 <printf>
}
     108:	4501                	li	a0,0
     10a:	60e2                	ld	ra,24(sp)
     10c:	6442                	ld	s0,16(sp)
     10e:	64a2                	ld	s1,8(sp)
     110:	6105                	addi	sp,sp,32
     112:	8082                	ret
    printf("FAIL: p is invalid\n");
     114:	00001517          	auipc	a0,0x1
     118:	08c50513          	addi	a0,a0,140 # 11a0 <ithread_join+0x8c>
     11c:	00001097          	auipc	ra,0x1
     120:	c3c080e7          	jalr	-964(ra) # d58 <printf>
    return 0;
     124:	b7d5                	j	108 <prop_mem_dealloc2+0x8c>

0000000000000126 <prop_mem_alloc2>:
  p[1] = 2;
  return 0;
}

void *prop_mem_alloc2(void *arg)
{
     126:	1141                	addi	sp,sp,-16
     128:	e406                	sd	ra,8(sp)
     12a:	e022                	sd	s0,0(sp)
     12c:	0800                	addi	s0,sp,16
  sleep(50);
     12e:	03200513          	li	a0,50
     132:	00001097          	auipc	ra,0x1
     136:	930080e7          	jalr	-1744(ra) # a62 <sleep>
  if(p == (int *)0xdeadbeef) {
     13a:	00002717          	auipc	a4,0x2
     13e:	69673703          	ld	a4,1686(a4) # 27d0 <p>
     142:	37ab77b7          	lui	a5,0x37ab7
     146:	078a                	slli	a5,a5,0x2
     148:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab46ef>
     14c:	02f70763          	beq	a4,a5,17a <prop_mem_alloc2+0x54>
    printf("FAIL: p == 0xdeadbeef\n");
    return 0;
  }

  if(p[0] == 3 && p[1] == 2) {
     150:	4314                	lw	a3,0(a4)
     152:	478d                	li	a5,3
     154:	00f69663          	bne	a3,a5,160 <prop_mem_alloc2+0x3a>
     158:	4358                	lw	a4,4(a4)
     15a:	4789                	li	a5,2
     15c:	02f70863          	beq	a4,a5,18c <prop_mem_alloc2+0x66>
    printf("PASSED\n");
    // SUCCESS
  } else {
    printf("FAIL: values did not change for siblings\n");
     160:	00001517          	auipc	a0,0x1
     164:	0f050513          	addi	a0,a0,240 # 1250 <ithread_join+0x13c>
     168:	00001097          	auipc	ra,0x1
     16c:	bf0080e7          	jalr	-1040(ra) # d58 <printf>
    // FAIL
  }
  return 0;
}
     170:	4501                	li	a0,0
     172:	60a2                	ld	ra,8(sp)
     174:	6402                	ld	s0,0(sp)
     176:	0141                	addi	sp,sp,16
     178:	8082                	ret
    printf("FAIL: p == 0xdeadbeef\n");
     17a:	00001517          	auipc	a0,0x1
     17e:	0b650513          	addi	a0,a0,182 # 1230 <ithread_join+0x11c>
     182:	00001097          	auipc	ra,0x1
     186:	bd6080e7          	jalr	-1066(ra) # d58 <printf>
    return 0;
     18a:	b7dd                	j	170 <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18c:	00001517          	auipc	a0,0x1
     190:	0bc50513          	addi	a0,a0,188 # 1248 <ithread_join+0x134>
     194:	00001097          	auipc	ra,0x1
     198:	bc4080e7          	jalr	-1084(ra) # d58 <printf>
     19c:	bfd1                	j	170 <prop_mem_alloc2+0x4a>

000000000000019e <prop_mem_dealloc1>:
{
     19e:	1101                	addi	sp,sp,-32
     1a0:	ec06                	sd	ra,24(sp)
     1a2:	e822                	sd	s0,16(sp)
     1a4:	e426                	sd	s1,8(sp)
     1a6:	1000                	addi	s0,sp,32
  p = (int *)sbrk(4096);  // allocate a page
     1a8:	6505                	lui	a0,0x1
     1aa:	00001097          	auipc	ra,0x1
     1ae:	8b0080e7          	jalr	-1872(ra) # a5a <sbrk>
     1b2:	00002497          	auipc	s1,0x2
     1b6:	61e48493          	addi	s1,s1,1566 # 27d0 <p>
     1ba:	e088                	sd	a0,0(s1)
  p[0] = 42;
     1bc:	02a00793          	li	a5,42
     1c0:	c11c                	sw	a5,0(a0)
  sleep(80);              // allow thread 2 to read
     1c2:	05000513          	li	a0,80
     1c6:	00001097          	auipc	ra,0x1
     1ca:	89c080e7          	jalr	-1892(ra) # a62 <sleep>
  p = (int *)sbrk(-4096);            // deallocate
     1ce:	757d                	lui	a0,0xfffff
     1d0:	00001097          	auipc	ra,0x1
     1d4:	88a080e7          	jalr	-1910(ra) # a5a <sbrk>
     1d8:	e088                	sd	a0,0(s1)
}
     1da:	4501                	li	a0,0
     1dc:	60e2                	ld	ra,24(sp)
     1de:	6442                	ld	s0,16(sp)
     1e0:	64a2                	ld	s1,8(sp)
     1e2:	6105                	addi	sp,sp,32
     1e4:	8082                	ret

00000000000001e6 <prop_mem_alloc1>:
{
     1e6:	1141                	addi	sp,sp,-16
     1e8:	e406                	sd	ra,8(sp)
     1ea:	e022                	sd	s0,0(sp)
     1ec:	0800                	addi	s0,sp,16
  p = (int *)sbrk(4096);
     1ee:	6505                	lui	a0,0x1
     1f0:	00001097          	auipc	ra,0x1
     1f4:	86a080e7          	jalr	-1942(ra) # a5a <sbrk>
     1f8:	00002797          	auipc	a5,0x2
     1fc:	5d878793          	addi	a5,a5,1496 # 27d0 <p>
     200:	e388                	sd	a0,0(a5)
  p[0] = 3;
     202:	470d                	li	a4,3
     204:	c118                	sw	a4,0(a0)
  p[1] = 2;
     206:	639c                	ld	a5,0(a5)
     208:	4709                	li	a4,2
     20a:	c3d8                	sw	a4,4(a5)
}
     20c:	4501                	li	a0,0
     20e:	60a2                	ld	ra,8(sp)
     210:	6402                	ld	s0,0(sp)
     212:	0141                	addi	sp,sp,16
     214:	8082                	ret

0000000000000216 <thread_func_basic>:
void* thread_func_basic(void *arg) {
     216:	1101                	addi	sp,sp,-32
     218:	ec06                	sd	ra,24(sp)
     21a:	e822                	sd	s0,16(sp)
     21c:	e426                	sd	s1,8(sp)
     21e:	e04a                	sd	s2,0(sp)
     220:	1000                	addi	s0,sp,32
     222:	84aa                	mv	s1,a0
  int val = *(int*)arg;
     224:	00052903          	lw	s2,0(a0) # 1000 <expand_num_threads+0x4c>
  printf("Thread %d is running\n", val);
     228:	85ca                	mv	a1,s2
     22a:	00001517          	auipc	a0,0x1
     22e:	05650513          	addi	a0,a0,86 # 1280 <ithread_join+0x16c>
     232:	00001097          	auipc	ra,0x1
     236:	b26080e7          	jalr	-1242(ra) # d58 <printf>
  free(arg);
     23a:	8526                	mv	a0,s1
     23c:	00001097          	auipc	ra,0x1
     240:	b52080e7          	jalr	-1198(ra) # d8e <free>
}
     244:	0019051b          	addiw	a0,s2,1
     248:	60e2                	ld	ra,24(sp)
     24a:	6442                	ld	s0,16(sp)
     24c:	64a2                	ld	s1,8(sp)
     24e:	6902                	ld	s2,0(sp)
     250:	6105                	addi	sp,sp,32
     252:	8082                	ret

0000000000000254 <thread_func_exit>:
void* thread_func_exit(void *arg) {
     254:	1141                	addi	sp,sp,-16
     256:	e406                	sd	ra,8(sp)
     258:	e022                	sd	s0,0(sp)
     25a:	0800                	addi	s0,sp,16
  ithread_exit(0);
     25c:	4501                	li	a0,0
     25e:	00001097          	auipc	ra,0x1
     262:	cb0080e7          	jalr	-848(ra) # f0e <ithread_exit>
}
     266:	4501                	li	a0,0
     268:	60a2                	ld	ra,8(sp)
     26a:	6402                	ld	s0,0(sp)
     26c:	0141                	addi	sp,sp,16
     26e:	8082                	ret

0000000000000270 <test_thread_create>:
void test_thread_create() {
     270:	1101                	addi	sp,sp,-32
     272:	ec06                	sd	ra,24(sp)
     274:	e822                	sd	s0,16(sp)
     276:	1000                	addi	s0,sp,32
  printf("Test 1: Thread creation\n");
     278:	00001517          	auipc	a0,0x1
     27c:	02050513          	addi	a0,a0,32 # 1298 <ithread_join+0x184>
     280:	00001097          	auipc	ra,0x1
     284:	ad8080e7          	jalr	-1320(ra) # d58 <printf>
  int *arg = malloc(sizeof(int));
     288:	4511                	li	a0,4
     28a:	00001097          	auipc	ra,0x1
     28e:	b8a080e7          	jalr	-1142(ra) # e14 <malloc>
     292:	85aa                	mv	a1,a0
  *arg = 0;
     294:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     298:	00000517          	auipc	a0,0x0
     29c:	f7e50513          	addi	a0,a0,-130 # 216 <thread_func_basic>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	d78080e7          	jalr	-648(ra) # 1018 <ithread_create>
  if (tid < 0) {
     2a8:	02054763          	bltz	a0,2d6 <test_thread_create+0x66>
     2ac:	e426                	sd	s1,8(sp)
     2ae:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2b0:	85aa                	mv	a1,a0
     2b2:	00001517          	auipc	a0,0x1
     2b6:	02e50513          	addi	a0,a0,46 # 12e0 <ithread_join+0x1cc>
     2ba:	00001097          	auipc	ra,0x1
     2be:	a9e080e7          	jalr	-1378(ra) # d58 <printf>
    ithread_join(tid);
     2c2:	8526                	mv	a0,s1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	e50080e7          	jalr	-432(ra) # 1114 <ithread_join>
     2cc:	64a2                	ld	s1,8(sp)
}
     2ce:	60e2                	ld	ra,24(sp)
     2d0:	6442                	ld	s0,16(sp)
     2d2:	6105                	addi	sp,sp,32
     2d4:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	fe250513          	addi	a0,a0,-30 # 12b8 <ithread_join+0x1a4>
     2de:	00001097          	auipc	ra,0x1
     2e2:	a7a080e7          	jalr	-1414(ra) # d58 <printf>
     2e6:	b7e5                	j	2ce <test_thread_create+0x5e>

00000000000002e8 <test_global_pointer_dealloc>:
void test_global_pointer_dealloc() {
     2e8:	1101                	addi	sp,sp,-32
     2ea:	ec06                	sd	ra,24(sp)
     2ec:	e822                	sd	s0,16(sp)
     2ee:	e426                	sd	s1,8(sp)
     2f0:	e04a                	sd	s2,0(sp)
     2f2:	1000                	addi	s0,sp,32
  printf("Test 7: sbrk(-) Test\n");
     2f4:	00001517          	auipc	a0,0x1
     2f8:	01c50513          	addi	a0,a0,28 # 1310 <ithread_join+0x1fc>
     2fc:	00001097          	auipc	ra,0x1
     300:	a5c080e7          	jalr	-1444(ra) # d58 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     304:	4581                	li	a1,0
     306:	00000517          	auipc	a0,0x0
     30a:	e9850513          	addi	a0,a0,-360 # 19e <prop_mem_dealloc1>
     30e:	00001097          	auipc	ra,0x1
     312:	d0a080e7          	jalr	-758(ra) # 1018 <ithread_create>
     316:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     318:	4581                	li	a1,0
     31a:	00000517          	auipc	a0,0x0
     31e:	d6250513          	addi	a0,a0,-670 # 7c <prop_mem_dealloc2>
     322:	00001097          	auipc	ra,0x1
     326:	cf6080e7          	jalr	-778(ra) # 1018 <ithread_create>
     32a:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32c:	854a                	mv	a0,s2
     32e:	00001097          	auipc	ra,0x1
     332:	de6080e7          	jalr	-538(ra) # 1114 <ithread_join>
  ithread_join(tid2);
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	ddc080e7          	jalr	-548(ra) # 1114 <ithread_join>
}
     340:	60e2                	ld	ra,24(sp)
     342:	6442                	ld	s0,16(sp)
     344:	64a2                	ld	s1,8(sp)
     346:	6902                	ld	s2,0(sp)
     348:	6105                	addi	sp,sp,32
     34a:	8082                	ret

000000000000034c <test_global_pointer_alloc>:

void test_global_pointer_alloc() {
     34c:	1101                	addi	sp,sp,-32
     34e:	ec06                	sd	ra,24(sp)
     350:	e822                	sd	s0,16(sp)
     352:	e426                	sd	s1,8(sp)
     354:	e04a                	sd	s2,0(sp)
     356:	1000                	addi	s0,sp,32
  printf("Test 6: sbrk(+) Test\n");
     358:	00001517          	auipc	a0,0x1
     35c:	fd050513          	addi	a0,a0,-48 # 1328 <ithread_join+0x214>
     360:	00001097          	auipc	ra,0x1
     364:	9f8080e7          	jalr	-1544(ra) # d58 <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     368:	4581                	li	a1,0
     36a:	00000517          	auipc	a0,0x0
     36e:	e7c50513          	addi	a0,a0,-388 # 1e6 <prop_mem_alloc1>
     372:	00001097          	auipc	ra,0x1
     376:	ca6080e7          	jalr	-858(ra) # 1018 <ithread_create>
     37a:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37c:	4581                	li	a1,0
     37e:	00000517          	auipc	a0,0x0
     382:	da850513          	addi	a0,a0,-600 # 126 <prop_mem_alloc2>
     386:	00001097          	auipc	ra,0x1
     38a:	c92080e7          	jalr	-878(ra) # 1018 <ithread_create>
     38e:	84aa                	mv	s1,a0
  ithread_join(tid1);
     390:	854a                	mv	a0,s2
     392:	00001097          	auipc	ra,0x1
     396:	d82080e7          	jalr	-638(ra) # 1114 <ithread_join>
  ithread_join(tid2);
     39a:	8526                	mv	a0,s1
     39c:	00001097          	auipc	ra,0x1
     3a0:	d78080e7          	jalr	-648(ra) # 1114 <ithread_join>

}
     3a4:	60e2                	ld	ra,24(sp)
     3a6:	6442                	ld	s0,16(sp)
     3a8:	64a2                	ld	s1,8(sp)
     3aa:	6902                	ld	s2,0(sp)
     3ac:	6105                	addi	sp,sp,32
     3ae:	8082                	ret

00000000000003b0 <test_thread_join>:

//test joining of threads

void test_thread_join() {
     3b0:	1141                	addi	sp,sp,-16
     3b2:	e406                	sd	ra,8(sp)
     3b4:	e022                	sd	s0,0(sp)
     3b6:	0800                	addi	s0,sp,16
  printf("Test 2: Joining threads\n");
     3b8:	00001517          	auipc	a0,0x1
     3bc:	f8850513          	addi	a0,a0,-120 # 1340 <ithread_join+0x22c>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	998080e7          	jalr	-1640(ra) # d58 <printf>

  int *arg = malloc(sizeof(int));
     3c8:	4511                	li	a0,4
     3ca:	00001097          	auipc	ra,0x1
     3ce:	a4a080e7          	jalr	-1462(ra) # e14 <malloc>
     3d2:	85aa                	mv	a1,a0
  *arg = 100;
     3d4:	06400793          	li	a5,100
     3d8:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3da:	00000517          	auipc	a0,0x0
     3de:	e3c50513          	addi	a0,a0,-452 # 216 <thread_func_basic>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	c36080e7          	jalr	-970(ra) # 1018 <ithread_create>

  if (tid < 0) {
     3ea:	02054763          	bltz	a0,418 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ee:	00001097          	auipc	ra,0x1
     3f2:	d26080e7          	jalr	-730(ra) # 1114 <ithread_join>
     3f6:	85aa                	mv	a1,a0
  if (status == 101) {
     3f8:	06500793          	li	a5,101
     3fc:	02f50763          	beq	a0,a5,42a <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     400:	00001517          	auipc	a0,0x1
     404:	fc050513          	addi	a0,a0,-64 # 13c0 <ithread_join+0x2ac>
     408:	00001097          	auipc	ra,0x1
     40c:	950080e7          	jalr	-1712(ra) # d58 <printf>
  }
}
     410:	60a2                	ld	ra,8(sp)
     412:	6402                	ld	s0,0(sp)
     414:	0141                	addi	sp,sp,16
     416:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     418:	00001517          	auipc	a0,0x1
     41c:	f4850513          	addi	a0,a0,-184 # 1360 <ithread_join+0x24c>
     420:	00001097          	auipc	ra,0x1
     424:	938080e7          	jalr	-1736(ra) # d58 <printf>
    return;
     428:	b7e5                	j	410 <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     42a:	00001517          	auipc	a0,0x1
     42e:	f6650513          	addi	a0,a0,-154 # 1390 <ithread_join+0x27c>
     432:	00001097          	auipc	ra,0x1
     436:	926080e7          	jalr	-1754(ra) # d58 <printf>
     43a:	bfd9                	j	410 <test_thread_join+0x60>

000000000000043c <test_shared_memory>:


//test shared memory

void test_shared_memory() {
     43c:	7139                	addi	sp,sp,-64
     43e:	fc06                	sd	ra,56(sp)
     440:	f822                	sd	s0,48(sp)
     442:	f426                	sd	s1,40(sp)
     444:	f04a                	sd	s2,32(sp)
     446:	ec4e                	sd	s3,24(sp)
     448:	e852                	sd	s4,16(sp)
     44a:	0080                	addi	s0,sp,64
  printf("Test 3: Shared memory between threads\n");
     44c:	00001517          	auipc	a0,0x1
     450:	f9c50513          	addi	a0,a0,-100 # 13e8 <ithread_join+0x2d4>
     454:	00001097          	auipc	ra,0x1
     458:	904080e7          	jalr	-1788(ra) # d58 <printf>

  shared_counter = 0;
     45c:	00002797          	auipc	a5,0x2
     460:	3807a223          	sw	zero,900(a5) # 27e0 <shared_counter>
  int tids[4];
  for (int i = 0; i < 4; i++) {
     464:	fc040493          	addi	s1,s0,-64
     468:	fd040993          	addi	s3,s0,-48
  shared_counter = 0;
     46c:	8926                	mv	s2,s1
    tids[i] = ithread_create(thread_func_shared, 0);
     46e:	00000a17          	auipc	s4,0x0
     472:	b92a0a13          	addi	s4,s4,-1134 # 0 <thread_func_shared>
     476:	4581                	li	a1,0
     478:	8552                	mv	a0,s4
     47a:	00001097          	auipc	ra,0x1
     47e:	b9e080e7          	jalr	-1122(ra) # 1018 <ithread_create>
     482:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     486:	0911                	addi	s2,s2,4
     488:	ff3917e3          	bne	s2,s3,476 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48c:	4088                	lw	a0,0(s1)
     48e:	00001097          	auipc	ra,0x1
     492:	c86080e7          	jalr	-890(ra) # 1114 <ithread_join>
  for (int i = 0; i < 4; i++) {
     496:	0491                	addi	s1,s1,4
     498:	ff349ae3          	bne	s1,s3,48c <test_shared_memory+0x50>
  }

  if (shared_counter == 200) {
     49c:	00002597          	auipc	a1,0x2
     4a0:	3445a583          	lw	a1,836(a1) # 27e0 <shared_counter>
     4a4:	0c800793          	li	a5,200
     4a8:	02f58263          	beq	a1,a5,4cc <test_shared_memory+0x90>
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
  } else {
    printf("Test 3 FAILED - shared_counter = %d\n", shared_counter);
     4ac:	00001517          	auipc	a0,0x1
     4b0:	f8c50513          	addi	a0,a0,-116 # 1438 <ithread_join+0x324>
     4b4:	00001097          	auipc	ra,0x1
     4b8:	8a4080e7          	jalr	-1884(ra) # d58 <printf>
  }
}
     4bc:	70e2                	ld	ra,56(sp)
     4be:	7442                	ld	s0,48(sp)
     4c0:	74a2                	ld	s1,40(sp)
     4c2:	7902                	ld	s2,32(sp)
     4c4:	69e2                	ld	s3,24(sp)
     4c6:	6a42                	ld	s4,16(sp)
     4c8:	6121                	addi	sp,sp,64
     4ca:	8082                	ret
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
     4cc:	00001517          	auipc	a0,0x1
     4d0:	f4450513          	addi	a0,a0,-188 # 1410 <ithread_join+0x2fc>
     4d4:	00001097          	auipc	ra,0x1
     4d8:	884080e7          	jalr	-1916(ra) # d58 <printf>
     4dc:	b7c5                	j	4bc <test_shared_memory+0x80>

00000000000004de <test_exit>:

//test exit off of return

void test_exit() {
     4de:	1141                	addi	sp,sp,-16
     4e0:	e406                	sd	ra,8(sp)
     4e2:	e022                	sd	s0,0(sp)
     4e4:	0800                	addi	s0,sp,16
  printf("Test 4: Graceful exit via ithread_exit\n");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	f7a50513          	addi	a0,a0,-134 # 1460 <ithread_join+0x34c>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	86a080e7          	jalr	-1942(ra) # d58 <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4f6:	4581                	li	a1,0
     4f8:	00000517          	auipc	a0,0x0
     4fc:	d5c50513          	addi	a0,a0,-676 # 254 <thread_func_exit>
     500:	00001097          	auipc	ra,0x1
     504:	b18080e7          	jalr	-1256(ra) # 1018 <ithread_create>
  int status = ithread_join(tid);
     508:	00001097          	auipc	ra,0x1
     50c:	c0c080e7          	jalr	-1012(ra) # 1114 <ithread_join>
     510:	85aa                	mv	a1,a0

  if (status == 0) {
     512:	ed09                	bnez	a0,52c <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     514:	00001517          	auipc	a0,0x1
     518:	f7450513          	addi	a0,a0,-140 # 1488 <ithread_join+0x374>
     51c:	00001097          	auipc	ra,0x1
     520:	83c080e7          	jalr	-1988(ra) # d58 <printf>
  } else {
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
  }
}
     524:	60a2                	ld	ra,8(sp)
     526:	6402                	ld	s0,0(sp)
     528:	0141                	addi	sp,sp,16
     52a:	8082                	ret
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
     52c:	00001517          	auipc	a0,0x1
     530:	f9c50513          	addi	a0,a0,-100 # 14c8 <ithread_join+0x3b4>
     534:	00001097          	auipc	ra,0x1
     538:	824080e7          	jalr	-2012(ra) # d58 <printf>
}
     53c:	b7e5                	j	524 <test_exit+0x46>

000000000000053e <test_exit_all>:

void test_exit_all() {
     53e:	7119                	addi	sp,sp,-128
     540:	fc86                	sd	ra,120(sp)
     542:	f8a2                	sd	s0,112(sp)
     544:	f4a6                	sd	s1,104(sp)
     546:	f0ca                	sd	s2,96(sp)
     548:	ecce                	sd	s3,88(sp)
     54a:	e8d2                	sd	s4,80(sp)
     54c:	e4d6                	sd	s5,72(sp)
     54e:	e0da                	sd	s6,64(sp)
     550:	fc5e                	sd	s7,56(sp)
     552:	0100                	addi	s0,sp,128
  printf("Test 5: Graceful exit of all threads via exit\n");
     554:	00001517          	auipc	a0,0x1
     558:	fa450513          	addi	a0,a0,-92 # 14f8 <ithread_join+0x3e4>
     55c:	00000097          	auipc	ra,0x0
     560:	7fc080e7          	jalr	2044(ra) # d58 <printf>
  int *num = malloc(10*sizeof(int));
     564:	02800513          	li	a0,40
     568:	00001097          	auipc	ra,0x1
     56c:	8ac080e7          	jalr	-1876(ra) # e14 <malloc>
     570:	8baa                	mv	s7,a0
  int tids[10];
  for (int i = 0; i < 10; i++) {
     572:	89aa                	mv	s3,a0
     574:	f8840493          	addi	s1,s0,-120
  int *num = malloc(10*sizeof(int));
     578:	8a26                	mv	s4,s1
  for (int i = 0; i < 10; i++) {
     57a:	4901                	li	s2,0
    num[i] = i;
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     57c:	00000b17          	auipc	s6,0x0
     580:	ab6b0b13          	addi	s6,s6,-1354 # 32 <exit_all>
  for (int i = 0; i < 10; i++) {
     584:	4aa9                	li	s5,10
    num[i] = i;
     586:	0129a023          	sw	s2,0(s3)
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     58a:	85ce                	mv	a1,s3
     58c:	855a                	mv	a0,s6
     58e:	00001097          	auipc	ra,0x1
     592:	a8a080e7          	jalr	-1398(ra) # 1018 <ithread_create>
     596:	00aa2023          	sw	a0,0(s4)
  for (int i = 0; i < 10; i++) {
     59a:	2905                	addiw	s2,s2,1
     59c:	0991                	addi	s3,s3,4
     59e:	0a11                	addi	s4,s4,4
     5a0:	ff5913e3          	bne	s2,s5,586 <test_exit_all+0x48>
     5a4:	02848913          	addi	s2,s1,40
  }
  for (int i = 0; i < 10; i++) {
    ithread_join(tids[i]);
     5a8:	4088                	lw	a0,0(s1)
     5aa:	00001097          	auipc	ra,0x1
     5ae:	b6a080e7          	jalr	-1174(ra) # 1114 <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b2:	0491                	addi	s1,s1,4
     5b4:	ff249ae3          	bne	s1,s2,5a8 <test_exit_all+0x6a>
  }
  free(num);
     5b8:	855e                	mv	a0,s7
     5ba:	00000097          	auipc	ra,0x0
     5be:	7d4080e7          	jalr	2004(ra) # d8e <free>
}
     5c2:	70e6                	ld	ra,120(sp)
     5c4:	7446                	ld	s0,112(sp)
     5c6:	74a6                	ld	s1,104(sp)
     5c8:	7906                	ld	s2,96(sp)
     5ca:	69e6                	ld	s3,88(sp)
     5cc:	6a46                	ld	s4,80(sp)
     5ce:	6aa6                	ld	s5,72(sp)
     5d0:	6b06                	ld	s6,64(sp)
     5d2:	7be2                	ld	s7,56(sp)
     5d4:	6109                	addi	sp,sp,128
     5d6:	8082                	ret

00000000000005d8 <main>:

int main(int argc, char *argv[]) {
     5d8:	1101                	addi	sp,sp,-32
     5da:	ec06                	sd	ra,24(sp)
     5dc:	e822                	sd	s0,16(sp)
     5de:	1000                	addi	s0,sp,32
  if (argc > 2) {
     5e0:	4789                	li	a5,2
     5e2:	02a7d163          	bge	a5,a0,604 <main+0x2c>
     5e6:	e426                	sd	s1,8(sp)
    printf("Needs the format: xv6test (1-7)\n", argv[0]);
     5e8:	618c                	ld	a1,0(a1)
     5ea:	00001517          	auipc	a0,0x1
     5ee:	f3e50513          	addi	a0,a0,-194 # 1528 <ithread_join+0x414>
     5f2:	00000097          	auipc	ra,0x0
     5f6:	766080e7          	jalr	1894(ra) # d58 <printf>
    exit(1);
     5fa:	4505                	li	a0,1
     5fc:	00000097          	auipc	ra,0x0
     600:	3d6080e7          	jalr	982(ra) # 9d2 <exit>
     604:	e426                	sd	s1,8(sp)
     606:	84aa                	mv	s1,a0
  }

  int test = atoi(argv[1]);
     608:	6588                	ld	a0,8(a1)
     60a:	00000097          	auipc	ra,0x0
     60e:	2c6080e7          	jalr	710(ra) # 8d0 <atoi>
  if(argc == 2){ 
     612:	4789                	li	a5,2
     614:	06f49e63          	bne	s1,a5,690 <main+0xb8>
  switch (test) {
     618:	357d                	addiw	a0,a0,-1
     61a:	4799                	li	a5,6
     61c:	06a7e163          	bltu	a5,a0,67e <main+0xa6>
     620:	02051793          	slli	a5,a0,0x20
     624:	01e7d513          	srli	a0,a5,0x1e
     628:	00001717          	auipc	a4,0x1
     62c:	f8c70713          	addi	a4,a4,-116 # 15b4 <ithread_join+0x4a0>
     630:	953a                	add	a0,a0,a4
     632:	411c                	lw	a5,0(a0)
     634:	97ba                	add	a5,a5,a4
     636:	8782                	jr	a5
    case 1:
      test_thread_create();
     638:	00000097          	auipc	ra,0x0
     63c:	c38080e7          	jalr	-968(ra) # 270 <test_thread_create>
      break;
     640:	a0c5                	j	720 <main+0x148>
    case 2:
      test_thread_join();
     642:	00000097          	auipc	ra,0x0
     646:	d6e080e7          	jalr	-658(ra) # 3b0 <test_thread_join>
      break;
     64a:	a8d9                	j	720 <main+0x148>
    case 3:
      test_shared_memory();
     64c:	00000097          	auipc	ra,0x0
     650:	df0080e7          	jalr	-528(ra) # 43c <test_shared_memory>
      break;
     654:	a0f1                	j	720 <main+0x148>
    case 4:
      test_exit();
     656:	00000097          	auipc	ra,0x0
     65a:	e88080e7          	jalr	-376(ra) # 4de <test_exit>
      break;
     65e:	a0c9                	j	720 <main+0x148>
    case 5:
      test_exit_all();
     660:	00000097          	auipc	ra,0x0
     664:	ede080e7          	jalr	-290(ra) # 53e <test_exit_all>
      break;
     668:	a865                	j	720 <main+0x148>
    case 6:
      test_global_pointer_alloc();
     66a:	00000097          	auipc	ra,0x0
     66e:	ce2080e7          	jalr	-798(ra) # 34c <test_global_pointer_alloc>
      break;
     672:	a07d                	j	720 <main+0x148>
    case 7:
      test_global_pointer_dealloc();
     674:	00000097          	auipc	ra,0x0
     678:	c74080e7          	jalr	-908(ra) # 2e8 <test_global_pointer_dealloc>
      break;
     67c:	a055                	j	720 <main+0x148>
    default:
      printf("Invalid test number. Choose 1-5.\n");
     67e:	00001517          	auipc	a0,0x1
     682:	ed250513          	addi	a0,a0,-302 # 1550 <ithread_join+0x43c>
     686:	00000097          	auipc	ra,0x0
     68a:	6d2080e7          	jalr	1746(ra) # d58 <printf>
     68e:	a849                	j	720 <main+0x148>
  }
  }else{
   test_thread_create();
     690:	00000097          	auipc	ra,0x0
     694:	be0080e7          	jalr	-1056(ra) # 270 <test_thread_create>
   printf("\n");
     698:	00001517          	auipc	a0,0x1
     69c:	ee050513          	addi	a0,a0,-288 # 1578 <ithread_join+0x464>
     6a0:	00000097          	auipc	ra,0x0
     6a4:	6b8080e7          	jalr	1720(ra) # d58 <printf>
   test_thread_join();
     6a8:	00000097          	auipc	ra,0x0
     6ac:	d08080e7          	jalr	-760(ra) # 3b0 <test_thread_join>
   printf("\n");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	ec850513          	addi	a0,a0,-312 # 1578 <ithread_join+0x464>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	6a0080e7          	jalr	1696(ra) # d58 <printf>
   test_shared_memory();
     6c0:	00000097          	auipc	ra,0x0
     6c4:	d7c080e7          	jalr	-644(ra) # 43c <test_shared_memory>
   printf("\n");
     6c8:	00001517          	auipc	a0,0x1
     6cc:	eb050513          	addi	a0,a0,-336 # 1578 <ithread_join+0x464>
     6d0:	00000097          	auipc	ra,0x0
     6d4:	688080e7          	jalr	1672(ra) # d58 <printf>
   test_exit();
     6d8:	00000097          	auipc	ra,0x0
     6dc:	e06080e7          	jalr	-506(ra) # 4de <test_exit>
   printf("\n");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	e9850513          	addi	a0,a0,-360 # 1578 <ithread_join+0x464>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	670080e7          	jalr	1648(ra) # d58 <printf>
   // test_exit_all();
   printf("\n");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	e8850513          	addi	a0,a0,-376 # 1578 <ithread_join+0x464>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	660080e7          	jalr	1632(ra) # d58 <printf>
   test_global_pointer_alloc();
     700:	00000097          	auipc	ra,0x0
     704:	c4c080e7          	jalr	-948(ra) # 34c <test_global_pointer_alloc>
   printf("\n");
     708:	00001517          	auipc	a0,0x1
     70c:	e7050513          	addi	a0,a0,-400 # 1578 <ithread_join+0x464>
     710:	00000097          	auipc	ra,0x0
     714:	648080e7          	jalr	1608(ra) # d58 <printf>
   test_global_pointer_dealloc();
     718:	00000097          	auipc	ra,0x0
     71c:	bd0080e7          	jalr	-1072(ra) # 2e8 <test_global_pointer_dealloc>
  }

  exit(0);
     720:	4501                	li	a0,0
     722:	00000097          	auipc	ra,0x0
     726:	2b0080e7          	jalr	688(ra) # 9d2 <exit>

000000000000072a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     72a:	1141                	addi	sp,sp,-16
     72c:	e406                	sd	ra,8(sp)
     72e:	e022                	sd	s0,0(sp)
     730:	0800                	addi	s0,sp,16
  extern int main();
  main();
     732:	00000097          	auipc	ra,0x0
     736:	ea6080e7          	jalr	-346(ra) # 5d8 <main>
  exit(0);
     73a:	4501                	li	a0,0
     73c:	00000097          	auipc	ra,0x0
     740:	296080e7          	jalr	662(ra) # 9d2 <exit>

0000000000000744 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     744:	1141                	addi	sp,sp,-16
     746:	e406                	sd	ra,8(sp)
     748:	e022                	sd	s0,0(sp)
     74a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     74c:	87aa                	mv	a5,a0
     74e:	0585                	addi	a1,a1,1
     750:	0785                	addi	a5,a5,1
     752:	fff5c703          	lbu	a4,-1(a1)
     756:	fee78fa3          	sb	a4,-1(a5)
     75a:	fb75                	bnez	a4,74e <strcpy+0xa>
    ;
  return os;
}
     75c:	60a2                	ld	ra,8(sp)
     75e:	6402                	ld	s0,0(sp)
     760:	0141                	addi	sp,sp,16
     762:	8082                	ret

0000000000000764 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     764:	1141                	addi	sp,sp,-16
     766:	e406                	sd	ra,8(sp)
     768:	e022                	sd	s0,0(sp)
     76a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     76c:	00054783          	lbu	a5,0(a0)
     770:	cb91                	beqz	a5,784 <strcmp+0x20>
     772:	0005c703          	lbu	a4,0(a1)
     776:	00f71763          	bne	a4,a5,784 <strcmp+0x20>
    p++, q++;
     77a:	0505                	addi	a0,a0,1
     77c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     77e:	00054783          	lbu	a5,0(a0)
     782:	fbe5                	bnez	a5,772 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     784:	0005c503          	lbu	a0,0(a1)
}
     788:	40a7853b          	subw	a0,a5,a0
     78c:	60a2                	ld	ra,8(sp)
     78e:	6402                	ld	s0,0(sp)
     790:	0141                	addi	sp,sp,16
     792:	8082                	ret

0000000000000794 <strlen>:

uint
strlen(const char *s)
{
     794:	1141                	addi	sp,sp,-16
     796:	e406                	sd	ra,8(sp)
     798:	e022                	sd	s0,0(sp)
     79a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     79c:	00054783          	lbu	a5,0(a0)
     7a0:	cf91                	beqz	a5,7bc <strlen+0x28>
     7a2:	00150793          	addi	a5,a0,1
     7a6:	86be                	mv	a3,a5
     7a8:	0785                	addi	a5,a5,1
     7aa:	fff7c703          	lbu	a4,-1(a5)
     7ae:	ff65                	bnez	a4,7a6 <strlen+0x12>
     7b0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     7b4:	60a2                	ld	ra,8(sp)
     7b6:	6402                	ld	s0,0(sp)
     7b8:	0141                	addi	sp,sp,16
     7ba:	8082                	ret
  for(n = 0; s[n]; n++)
     7bc:	4501                	li	a0,0
     7be:	bfdd                	j	7b4 <strlen+0x20>

00000000000007c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     7c0:	1141                	addi	sp,sp,-16
     7c2:	e406                	sd	ra,8(sp)
     7c4:	e022                	sd	s0,0(sp)
     7c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     7c8:	ca19                	beqz	a2,7de <memset+0x1e>
     7ca:	87aa                	mv	a5,a0
     7cc:	1602                	slli	a2,a2,0x20
     7ce:	9201                	srli	a2,a2,0x20
     7d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     7d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     7d8:	0785                	addi	a5,a5,1
     7da:	fee79de3          	bne	a5,a4,7d4 <memset+0x14>
  }
  return dst;
}
     7de:	60a2                	ld	ra,8(sp)
     7e0:	6402                	ld	s0,0(sp)
     7e2:	0141                	addi	sp,sp,16
     7e4:	8082                	ret

00000000000007e6 <strchr>:

char*
strchr(const char *s, char c)
{
     7e6:	1141                	addi	sp,sp,-16
     7e8:	e406                	sd	ra,8(sp)
     7ea:	e022                	sd	s0,0(sp)
     7ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
     7ee:	00054783          	lbu	a5,0(a0)
     7f2:	cf81                	beqz	a5,80a <strchr+0x24>
    if(*s == c)
     7f4:	00f58763          	beq	a1,a5,802 <strchr+0x1c>
  for(; *s; s++)
     7f8:	0505                	addi	a0,a0,1
     7fa:	00054783          	lbu	a5,0(a0)
     7fe:	fbfd                	bnez	a5,7f4 <strchr+0xe>
      return (char*)s;
  return 0;
     800:	4501                	li	a0,0
}
     802:	60a2                	ld	ra,8(sp)
     804:	6402                	ld	s0,0(sp)
     806:	0141                	addi	sp,sp,16
     808:	8082                	ret
  return 0;
     80a:	4501                	li	a0,0
     80c:	bfdd                	j	802 <strchr+0x1c>

000000000000080e <gets>:

char*
gets(char *buf, int max)
{
     80e:	711d                	addi	sp,sp,-96
     810:	ec86                	sd	ra,88(sp)
     812:	e8a2                	sd	s0,80(sp)
     814:	e4a6                	sd	s1,72(sp)
     816:	e0ca                	sd	s2,64(sp)
     818:	fc4e                	sd	s3,56(sp)
     81a:	f852                	sd	s4,48(sp)
     81c:	f456                	sd	s5,40(sp)
     81e:	f05a                	sd	s6,32(sp)
     820:	ec5e                	sd	s7,24(sp)
     822:	e862                	sd	s8,16(sp)
     824:	1080                	addi	s0,sp,96
     826:	8baa                	mv	s7,a0
     828:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     82a:	892a                	mv	s2,a0
     82c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     82e:	faf40b13          	addi	s6,s0,-81
     832:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     834:	8c26                	mv	s8,s1
     836:	0014899b          	addiw	s3,s1,1
     83a:	84ce                	mv	s1,s3
     83c:	0349d663          	bge	s3,s4,868 <gets+0x5a>
    cc = read(0, &c, 1);
     840:	8656                	mv	a2,s5
     842:	85da                	mv	a1,s6
     844:	4501                	li	a0,0
     846:	00000097          	auipc	ra,0x0
     84a:	1a4080e7          	jalr	420(ra) # 9ea <read>
    if(cc < 1)
     84e:	00a05d63          	blez	a0,868 <gets+0x5a>
      break;
    buf[i++] = c;
     852:	faf44783          	lbu	a5,-81(s0)
     856:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     85a:	0905                	addi	s2,s2,1
     85c:	ff678713          	addi	a4,a5,-10
     860:	c319                	beqz	a4,866 <gets+0x58>
     862:	17cd                	addi	a5,a5,-13
     864:	fbe1                	bnez	a5,834 <gets+0x26>
    buf[i++] = c;
     866:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     868:	9c5e                	add	s8,s8,s7
     86a:	000c0023          	sb	zero,0(s8)
  return buf;
}
     86e:	855e                	mv	a0,s7
     870:	60e6                	ld	ra,88(sp)
     872:	6446                	ld	s0,80(sp)
     874:	64a6                	ld	s1,72(sp)
     876:	6906                	ld	s2,64(sp)
     878:	79e2                	ld	s3,56(sp)
     87a:	7a42                	ld	s4,48(sp)
     87c:	7aa2                	ld	s5,40(sp)
     87e:	7b02                	ld	s6,32(sp)
     880:	6be2                	ld	s7,24(sp)
     882:	6c42                	ld	s8,16(sp)
     884:	6125                	addi	sp,sp,96
     886:	8082                	ret

0000000000000888 <stat>:

int
stat(const char *n, struct stat *st)
{
     888:	1101                	addi	sp,sp,-32
     88a:	ec06                	sd	ra,24(sp)
     88c:	e822                	sd	s0,16(sp)
     88e:	e04a                	sd	s2,0(sp)
     890:	1000                	addi	s0,sp,32
     892:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     894:	4581                	li	a1,0
     896:	00000097          	auipc	ra,0x0
     89a:	17c080e7          	jalr	380(ra) # a12 <open>
  if(fd < 0)
     89e:	02054663          	bltz	a0,8ca <stat+0x42>
     8a2:	e426                	sd	s1,8(sp)
     8a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     8a6:	85ca                	mv	a1,s2
     8a8:	00000097          	auipc	ra,0x0
     8ac:	182080e7          	jalr	386(ra) # a2a <fstat>
     8b0:	892a                	mv	s2,a0
  close(fd);
     8b2:	8526                	mv	a0,s1
     8b4:	00000097          	auipc	ra,0x0
     8b8:	146080e7          	jalr	326(ra) # 9fa <close>
  return r;
     8bc:	64a2                	ld	s1,8(sp)
}
     8be:	854a                	mv	a0,s2
     8c0:	60e2                	ld	ra,24(sp)
     8c2:	6442                	ld	s0,16(sp)
     8c4:	6902                	ld	s2,0(sp)
     8c6:	6105                	addi	sp,sp,32
     8c8:	8082                	ret
    return -1;
     8ca:	57fd                	li	a5,-1
     8cc:	893e                	mv	s2,a5
     8ce:	bfc5                	j	8be <stat+0x36>

00000000000008d0 <atoi>:

int
atoi(const char *s)
{
     8d0:	1141                	addi	sp,sp,-16
     8d2:	e406                	sd	ra,8(sp)
     8d4:	e022                	sd	s0,0(sp)
     8d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     8d8:	00054683          	lbu	a3,0(a0)
     8dc:	fd06879b          	addiw	a5,a3,-48
     8e0:	0ff7f793          	zext.b	a5,a5
     8e4:	4625                	li	a2,9
     8e6:	02f66963          	bltu	a2,a5,918 <atoi+0x48>
     8ea:	872a                	mv	a4,a0
  n = 0;
     8ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     8ee:	0705                	addi	a4,a4,1
     8f0:	0025179b          	slliw	a5,a0,0x2
     8f4:	9fa9                	addw	a5,a5,a0
     8f6:	0017979b          	slliw	a5,a5,0x1
     8fa:	9fb5                	addw	a5,a5,a3
     8fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     900:	00074683          	lbu	a3,0(a4)
     904:	fd06879b          	addiw	a5,a3,-48
     908:	0ff7f793          	zext.b	a5,a5
     90c:	fef671e3          	bgeu	a2,a5,8ee <atoi+0x1e>
  return n;
}
     910:	60a2                	ld	ra,8(sp)
     912:	6402                	ld	s0,0(sp)
     914:	0141                	addi	sp,sp,16
     916:	8082                	ret
  n = 0;
     918:	4501                	li	a0,0
     91a:	bfdd                	j	910 <atoi+0x40>

000000000000091c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     91c:	1141                	addi	sp,sp,-16
     91e:	e406                	sd	ra,8(sp)
     920:	e022                	sd	s0,0(sp)
     922:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     924:	02b57563          	bgeu	a0,a1,94e <memmove+0x32>
    while(n-- > 0)
     928:	00c05f63          	blez	a2,946 <memmove+0x2a>
     92c:	1602                	slli	a2,a2,0x20
     92e:	9201                	srli	a2,a2,0x20
     930:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     934:	872a                	mv	a4,a0
      *dst++ = *src++;
     936:	0585                	addi	a1,a1,1
     938:	0705                	addi	a4,a4,1
     93a:	fff5c683          	lbu	a3,-1(a1)
     93e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     942:	fee79ae3          	bne	a5,a4,936 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     946:	60a2                	ld	ra,8(sp)
     948:	6402                	ld	s0,0(sp)
     94a:	0141                	addi	sp,sp,16
     94c:	8082                	ret
    while(n-- > 0)
     94e:	fec05ce3          	blez	a2,946 <memmove+0x2a>
    dst += n;
     952:	00c50733          	add	a4,a0,a2
    src += n;
     956:	95b2                	add	a1,a1,a2
     958:	fff6079b          	addiw	a5,a2,-1
     95c:	1782                	slli	a5,a5,0x20
     95e:	9381                	srli	a5,a5,0x20
     960:	fff7c793          	not	a5,a5
     964:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     966:	15fd                	addi	a1,a1,-1
     968:	177d                	addi	a4,a4,-1
     96a:	0005c683          	lbu	a3,0(a1)
     96e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     972:	fef71ae3          	bne	a4,a5,966 <memmove+0x4a>
     976:	bfc1                	j	946 <memmove+0x2a>

0000000000000978 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     978:	1141                	addi	sp,sp,-16
     97a:	e406                	sd	ra,8(sp)
     97c:	e022                	sd	s0,0(sp)
     97e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     980:	c61d                	beqz	a2,9ae <memcmp+0x36>
     982:	1602                	slli	a2,a2,0x20
     984:	9201                	srli	a2,a2,0x20
     986:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     98a:	00054783          	lbu	a5,0(a0)
     98e:	0005c703          	lbu	a4,0(a1)
     992:	00e79863          	bne	a5,a4,9a2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     996:	0505                	addi	a0,a0,1
    p2++;
     998:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     99a:	fed518e3          	bne	a0,a3,98a <memcmp+0x12>
  }
  return 0;
     99e:	4501                	li	a0,0
     9a0:	a019                	j	9a6 <memcmp+0x2e>
      return *p1 - *p2;
     9a2:	40e7853b          	subw	a0,a5,a4
}
     9a6:	60a2                	ld	ra,8(sp)
     9a8:	6402                	ld	s0,0(sp)
     9aa:	0141                	addi	sp,sp,16
     9ac:	8082                	ret
  return 0;
     9ae:	4501                	li	a0,0
     9b0:	bfdd                	j	9a6 <memcmp+0x2e>

00000000000009b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     9b2:	1141                	addi	sp,sp,-16
     9b4:	e406                	sd	ra,8(sp)
     9b6:	e022                	sd	s0,0(sp)
     9b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     9ba:	00000097          	auipc	ra,0x0
     9be:	f62080e7          	jalr	-158(ra) # 91c <memmove>
}
     9c2:	60a2                	ld	ra,8(sp)
     9c4:	6402                	ld	s0,0(sp)
     9c6:	0141                	addi	sp,sp,16
     9c8:	8082                	ret

00000000000009ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     9ca:	4885                	li	a7,1
 ecall
     9cc:	00000073          	ecall
 ret
     9d0:	8082                	ret

00000000000009d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     9d2:	4889                	li	a7,2
 ecall
     9d4:	00000073          	ecall
 ret
     9d8:	8082                	ret

00000000000009da <wait>:
.global wait
wait:
 li a7, SYS_wait
     9da:	488d                	li	a7,3
 ecall
     9dc:	00000073          	ecall
 ret
     9e0:	8082                	ret

00000000000009e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     9e2:	4891                	li	a7,4
 ecall
     9e4:	00000073          	ecall
 ret
     9e8:	8082                	ret

00000000000009ea <read>:
.global read
read:
 li a7, SYS_read
     9ea:	4895                	li	a7,5
 ecall
     9ec:	00000073          	ecall
 ret
     9f0:	8082                	ret

00000000000009f2 <write>:
.global write
write:
 li a7, SYS_write
     9f2:	48c1                	li	a7,16
 ecall
     9f4:	00000073          	ecall
 ret
     9f8:	8082                	ret

00000000000009fa <close>:
.global close
close:
 li a7, SYS_close
     9fa:	48d5                	li	a7,21
 ecall
     9fc:	00000073          	ecall
 ret
     a00:	8082                	ret

0000000000000a02 <kill>:
.global kill
kill:
 li a7, SYS_kill
     a02:	4899                	li	a7,6
 ecall
     a04:	00000073          	ecall
 ret
     a08:	8082                	ret

0000000000000a0a <exec>:
.global exec
exec:
 li a7, SYS_exec
     a0a:	489d                	li	a7,7
 ecall
     a0c:	00000073          	ecall
 ret
     a10:	8082                	ret

0000000000000a12 <open>:
.global open
open:
 li a7, SYS_open
     a12:	48bd                	li	a7,15
 ecall
     a14:	00000073          	ecall
 ret
     a18:	8082                	ret

0000000000000a1a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     a1a:	48c5                	li	a7,17
 ecall
     a1c:	00000073          	ecall
 ret
     a20:	8082                	ret

0000000000000a22 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     a22:	48c9                	li	a7,18
 ecall
     a24:	00000073          	ecall
 ret
     a28:	8082                	ret

0000000000000a2a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     a2a:	48a1                	li	a7,8
 ecall
     a2c:	00000073          	ecall
 ret
     a30:	8082                	ret

0000000000000a32 <link>:
.global link
link:
 li a7, SYS_link
     a32:	48cd                	li	a7,19
 ecall
     a34:	00000073          	ecall
 ret
     a38:	8082                	ret

0000000000000a3a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     a3a:	48d1                	li	a7,20
 ecall
     a3c:	00000073          	ecall
 ret
     a40:	8082                	ret

0000000000000a42 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     a42:	48a5                	li	a7,9
 ecall
     a44:	00000073          	ecall
 ret
     a48:	8082                	ret

0000000000000a4a <dup>:
.global dup
dup:
 li a7, SYS_dup
     a4a:	48a9                	li	a7,10
 ecall
     a4c:	00000073          	ecall
 ret
     a50:	8082                	ret

0000000000000a52 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     a52:	48ad                	li	a7,11
 ecall
     a54:	00000073          	ecall
 ret
     a58:	8082                	ret

0000000000000a5a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     a5a:	48b1                	li	a7,12
 ecall
     a5c:	00000073          	ecall
 ret
     a60:	8082                	ret

0000000000000a62 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     a62:	48b5                	li	a7,13
 ecall
     a64:	00000073          	ecall
 ret
     a68:	8082                	ret

0000000000000a6a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     a6a:	48b9                	li	a7,14
 ecall
     a6c:	00000073          	ecall
 ret
     a70:	8082                	ret

0000000000000a72 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     a72:	48d9                	li	a7,22
 ecall
     a74:	00000073          	ecall
 ret
     a78:	8082                	ret

0000000000000a7a <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     a7a:	48dd                	li	a7,23
 ecall
     a7c:	00000073          	ecall
 ret
     a80:	8082                	ret

0000000000000a82 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     a82:	48e1                	li	a7,24
 ecall
     a84:	00000073          	ecall
 ret
     a88:	8082                	ret

0000000000000a8a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     a8a:	48e5                	li	a7,25
 ecall
     a8c:	00000073          	ecall
 ret
     a90:	8082                	ret

0000000000000a92 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     a92:	1101                	addi	sp,sp,-32
     a94:	ec06                	sd	ra,24(sp)
     a96:	e822                	sd	s0,16(sp)
     a98:	1000                	addi	s0,sp,32
     a9a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     a9e:	4605                	li	a2,1
     aa0:	fef40593          	addi	a1,s0,-17
     aa4:	00000097          	auipc	ra,0x0
     aa8:	f4e080e7          	jalr	-178(ra) # 9f2 <write>
}
     aac:	60e2                	ld	ra,24(sp)
     aae:	6442                	ld	s0,16(sp)
     ab0:	6105                	addi	sp,sp,32
     ab2:	8082                	ret

0000000000000ab4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ab4:	7139                	addi	sp,sp,-64
     ab6:	fc06                	sd	ra,56(sp)
     ab8:	f822                	sd	s0,48(sp)
     aba:	f04a                	sd	s2,32(sp)
     abc:	ec4e                	sd	s3,24(sp)
     abe:	0080                	addi	s0,sp,64
     ac0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ac2:	cad9                	beqz	a3,b58 <printint+0xa4>
     ac4:	01f5d79b          	srliw	a5,a1,0x1f
     ac8:	cbc1                	beqz	a5,b58 <printint+0xa4>
    neg = 1;
    x = -xx;
     aca:	40b005bb          	negw	a1,a1
    neg = 1;
     ace:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     ad0:	fc040993          	addi	s3,s0,-64
  neg = 0;
     ad4:	86ce                	mv	a3,s3
  i = 0;
     ad6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ad8:	00001817          	auipc	a6,0x1
     adc:	b5080813          	addi	a6,a6,-1200 # 1628 <digits>
     ae0:	88ba                	mv	a7,a4
     ae2:	0017051b          	addiw	a0,a4,1
     ae6:	872a                	mv	a4,a0
     ae8:	02c5f7bb          	remuw	a5,a1,a2
     aec:	1782                	slli	a5,a5,0x20
     aee:	9381                	srli	a5,a5,0x20
     af0:	97c2                	add	a5,a5,a6
     af2:	0007c783          	lbu	a5,0(a5)
     af6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     afa:	87ae                	mv	a5,a1
     afc:	02c5d5bb          	divuw	a1,a1,a2
     b00:	0685                	addi	a3,a3,1
     b02:	fcc7ffe3          	bgeu	a5,a2,ae0 <printint+0x2c>
  if(neg)
     b06:	00030c63          	beqz	t1,b1e <printint+0x6a>
    buf[i++] = '-';
     b0a:	fd050793          	addi	a5,a0,-48
     b0e:	00878533          	add	a0,a5,s0
     b12:	02d00793          	li	a5,45
     b16:	fef50823          	sb	a5,-16(a0)
     b1a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     b1e:	02e05763          	blez	a4,b4c <printint+0x98>
     b22:	f426                	sd	s1,40(sp)
     b24:	377d                	addiw	a4,a4,-1
     b26:	00e984b3          	add	s1,s3,a4
     b2a:	19fd                	addi	s3,s3,-1
     b2c:	99ba                	add	s3,s3,a4
     b2e:	1702                	slli	a4,a4,0x20
     b30:	9301                	srli	a4,a4,0x20
     b32:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b36:	0004c583          	lbu	a1,0(s1)
     b3a:	854a                	mv	a0,s2
     b3c:	00000097          	auipc	ra,0x0
     b40:	f56080e7          	jalr	-170(ra) # a92 <putc>
  while(--i >= 0)
     b44:	14fd                	addi	s1,s1,-1
     b46:	ff3498e3          	bne	s1,s3,b36 <printint+0x82>
     b4a:	74a2                	ld	s1,40(sp)
}
     b4c:	70e2                	ld	ra,56(sp)
     b4e:	7442                	ld	s0,48(sp)
     b50:	7902                	ld	s2,32(sp)
     b52:	69e2                	ld	s3,24(sp)
     b54:	6121                	addi	sp,sp,64
     b56:	8082                	ret
  neg = 0;
     b58:	4301                	li	t1,0
     b5a:	bf9d                	j	ad0 <printint+0x1c>

0000000000000b5c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b5c:	715d                	addi	sp,sp,-80
     b5e:	e486                	sd	ra,72(sp)
     b60:	e0a2                	sd	s0,64(sp)
     b62:	f84a                	sd	s2,48(sp)
     b64:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     b66:	0005c903          	lbu	s2,0(a1)
     b6a:	1a090b63          	beqz	s2,d20 <vprintf+0x1c4>
     b6e:	fc26                	sd	s1,56(sp)
     b70:	f44e                	sd	s3,40(sp)
     b72:	f052                	sd	s4,32(sp)
     b74:	ec56                	sd	s5,24(sp)
     b76:	e85a                	sd	s6,16(sp)
     b78:	e45e                	sd	s7,8(sp)
     b7a:	8aaa                	mv	s5,a0
     b7c:	8bb2                	mv	s7,a2
     b7e:	00158493          	addi	s1,a1,1
  state = 0;
     b82:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     b84:	02500a13          	li	s4,37
     b88:	4b55                	li	s6,21
     b8a:	a839                	j	ba8 <vprintf+0x4c>
        putc(fd, c);
     b8c:	85ca                	mv	a1,s2
     b8e:	8556                	mv	a0,s5
     b90:	00000097          	auipc	ra,0x0
     b94:	f02080e7          	jalr	-254(ra) # a92 <putc>
     b98:	a019                	j	b9e <vprintf+0x42>
    } else if(state == '%'){
     b9a:	01498d63          	beq	s3,s4,bb4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     b9e:	0485                	addi	s1,s1,1
     ba0:	fff4c903          	lbu	s2,-1(s1)
     ba4:	16090863          	beqz	s2,d14 <vprintf+0x1b8>
    if(state == 0){
     ba8:	fe0999e3          	bnez	s3,b9a <vprintf+0x3e>
      if(c == '%'){
     bac:	ff4910e3          	bne	s2,s4,b8c <vprintf+0x30>
        state = '%';
     bb0:	89d2                	mv	s3,s4
     bb2:	b7f5                	j	b9e <vprintf+0x42>
      if(c == 'd'){
     bb4:	13490563          	beq	s2,s4,cde <vprintf+0x182>
     bb8:	f9d9079b          	addiw	a5,s2,-99
     bbc:	0ff7f793          	zext.b	a5,a5
     bc0:	12fb6863          	bltu	s6,a5,cf0 <vprintf+0x194>
     bc4:	f9d9079b          	addiw	a5,s2,-99
     bc8:	0ff7f713          	zext.b	a4,a5
     bcc:	12eb6263          	bltu	s6,a4,cf0 <vprintf+0x194>
     bd0:	00271793          	slli	a5,a4,0x2
     bd4:	00001717          	auipc	a4,0x1
     bd8:	9fc70713          	addi	a4,a4,-1540 # 15d0 <ithread_join+0x4bc>
     bdc:	97ba                	add	a5,a5,a4
     bde:	439c                	lw	a5,0(a5)
     be0:	97ba                	add	a5,a5,a4
     be2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     be4:	008b8913          	addi	s2,s7,8
     be8:	4685                	li	a3,1
     bea:	4629                	li	a2,10
     bec:	000ba583          	lw	a1,0(s7)
     bf0:	8556                	mv	a0,s5
     bf2:	00000097          	auipc	ra,0x0
     bf6:	ec2080e7          	jalr	-318(ra) # ab4 <printint>
     bfa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     bfc:	4981                	li	s3,0
     bfe:	b745                	j	b9e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c00:	008b8913          	addi	s2,s7,8
     c04:	4681                	li	a3,0
     c06:	4629                	li	a2,10
     c08:	000ba583          	lw	a1,0(s7)
     c0c:	8556                	mv	a0,s5
     c0e:	00000097          	auipc	ra,0x0
     c12:	ea6080e7          	jalr	-346(ra) # ab4 <printint>
     c16:	8bca                	mv	s7,s2
      state = 0;
     c18:	4981                	li	s3,0
     c1a:	b751                	j	b9e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     c1c:	008b8913          	addi	s2,s7,8
     c20:	4681                	li	a3,0
     c22:	4641                	li	a2,16
     c24:	000ba583          	lw	a1,0(s7)
     c28:	8556                	mv	a0,s5
     c2a:	00000097          	auipc	ra,0x0
     c2e:	e8a080e7          	jalr	-374(ra) # ab4 <printint>
     c32:	8bca                	mv	s7,s2
      state = 0;
     c34:	4981                	li	s3,0
     c36:	b7a5                	j	b9e <vprintf+0x42>
     c38:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     c3a:	008b8793          	addi	a5,s7,8
     c3e:	8c3e                	mv	s8,a5
     c40:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     c44:	03000593          	li	a1,48
     c48:	8556                	mv	a0,s5
     c4a:	00000097          	auipc	ra,0x0
     c4e:	e48080e7          	jalr	-440(ra) # a92 <putc>
  putc(fd, 'x');
     c52:	07800593          	li	a1,120
     c56:	8556                	mv	a0,s5
     c58:	00000097          	auipc	ra,0x0
     c5c:	e3a080e7          	jalr	-454(ra) # a92 <putc>
     c60:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     c62:	00001b97          	auipc	s7,0x1
     c66:	9c6b8b93          	addi	s7,s7,-1594 # 1628 <digits>
     c6a:	03c9d793          	srli	a5,s3,0x3c
     c6e:	97de                	add	a5,a5,s7
     c70:	0007c583          	lbu	a1,0(a5)
     c74:	8556                	mv	a0,s5
     c76:	00000097          	auipc	ra,0x0
     c7a:	e1c080e7          	jalr	-484(ra) # a92 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     c7e:	0992                	slli	s3,s3,0x4
     c80:	397d                	addiw	s2,s2,-1
     c82:	fe0914e3          	bnez	s2,c6a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     c86:	8be2                	mv	s7,s8
      state = 0;
     c88:	4981                	li	s3,0
     c8a:	6c02                	ld	s8,0(sp)
     c8c:	bf09                	j	b9e <vprintf+0x42>
        s = va_arg(ap, char*);
     c8e:	008b8993          	addi	s3,s7,8
     c92:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     c96:	02090163          	beqz	s2,cb8 <vprintf+0x15c>
        while(*s != 0){
     c9a:	00094583          	lbu	a1,0(s2)
     c9e:	c9a5                	beqz	a1,d0e <vprintf+0x1b2>
          putc(fd, *s);
     ca0:	8556                	mv	a0,s5
     ca2:	00000097          	auipc	ra,0x0
     ca6:	df0080e7          	jalr	-528(ra) # a92 <putc>
          s++;
     caa:	0905                	addi	s2,s2,1
        while(*s != 0){
     cac:	00094583          	lbu	a1,0(s2)
     cb0:	f9e5                	bnez	a1,ca0 <vprintf+0x144>
        s = va_arg(ap, char*);
     cb2:	8bce                	mv	s7,s3
      state = 0;
     cb4:	4981                	li	s3,0
     cb6:	b5e5                	j	b9e <vprintf+0x42>
          s = "(null)";
     cb8:	00001917          	auipc	s2,0x1
     cbc:	8c890913          	addi	s2,s2,-1848 # 1580 <ithread_join+0x46c>
        while(*s != 0){
     cc0:	02800593          	li	a1,40
     cc4:	bff1                	j	ca0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     cc6:	008b8913          	addi	s2,s7,8
     cca:	000bc583          	lbu	a1,0(s7)
     cce:	8556                	mv	a0,s5
     cd0:	00000097          	auipc	ra,0x0
     cd4:	dc2080e7          	jalr	-574(ra) # a92 <putc>
     cd8:	8bca                	mv	s7,s2
      state = 0;
     cda:	4981                	li	s3,0
     cdc:	b5c9                	j	b9e <vprintf+0x42>
        putc(fd, c);
     cde:	02500593          	li	a1,37
     ce2:	8556                	mv	a0,s5
     ce4:	00000097          	auipc	ra,0x0
     ce8:	dae080e7          	jalr	-594(ra) # a92 <putc>
      state = 0;
     cec:	4981                	li	s3,0
     cee:	bd45                	j	b9e <vprintf+0x42>
        putc(fd, '%');
     cf0:	02500593          	li	a1,37
     cf4:	8556                	mv	a0,s5
     cf6:	00000097          	auipc	ra,0x0
     cfa:	d9c080e7          	jalr	-612(ra) # a92 <putc>
        putc(fd, c);
     cfe:	85ca                	mv	a1,s2
     d00:	8556                	mv	a0,s5
     d02:	00000097          	auipc	ra,0x0
     d06:	d90080e7          	jalr	-624(ra) # a92 <putc>
      state = 0;
     d0a:	4981                	li	s3,0
     d0c:	bd49                	j	b9e <vprintf+0x42>
        s = va_arg(ap, char*);
     d0e:	8bce                	mv	s7,s3
      state = 0;
     d10:	4981                	li	s3,0
     d12:	b571                	j	b9e <vprintf+0x42>
     d14:	74e2                	ld	s1,56(sp)
     d16:	79a2                	ld	s3,40(sp)
     d18:	7a02                	ld	s4,32(sp)
     d1a:	6ae2                	ld	s5,24(sp)
     d1c:	6b42                	ld	s6,16(sp)
     d1e:	6ba2                	ld	s7,8(sp)
    }
  }
}
     d20:	60a6                	ld	ra,72(sp)
     d22:	6406                	ld	s0,64(sp)
     d24:	7942                	ld	s2,48(sp)
     d26:	6161                	addi	sp,sp,80
     d28:	8082                	ret

0000000000000d2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d2a:	715d                	addi	sp,sp,-80
     d2c:	ec06                	sd	ra,24(sp)
     d2e:	e822                	sd	s0,16(sp)
     d30:	1000                	addi	s0,sp,32
     d32:	e010                	sd	a2,0(s0)
     d34:	e414                	sd	a3,8(s0)
     d36:	e818                	sd	a4,16(s0)
     d38:	ec1c                	sd	a5,24(s0)
     d3a:	03043023          	sd	a6,32(s0)
     d3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d42:	8622                	mv	a2,s0
     d44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d48:	00000097          	auipc	ra,0x0
     d4c:	e14080e7          	jalr	-492(ra) # b5c <vprintf>
}
     d50:	60e2                	ld	ra,24(sp)
     d52:	6442                	ld	s0,16(sp)
     d54:	6161                	addi	sp,sp,80
     d56:	8082                	ret

0000000000000d58 <printf>:

void
printf(const char *fmt, ...)
{
     d58:	711d                	addi	sp,sp,-96
     d5a:	ec06                	sd	ra,24(sp)
     d5c:	e822                	sd	s0,16(sp)
     d5e:	1000                	addi	s0,sp,32
     d60:	e40c                	sd	a1,8(s0)
     d62:	e810                	sd	a2,16(s0)
     d64:	ec14                	sd	a3,24(s0)
     d66:	f018                	sd	a4,32(s0)
     d68:	f41c                	sd	a5,40(s0)
     d6a:	03043823          	sd	a6,48(s0)
     d6e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d72:	00840613          	addi	a2,s0,8
     d76:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     d7a:	85aa                	mv	a1,a0
     d7c:	4505                	li	a0,1
     d7e:	00000097          	auipc	ra,0x0
     d82:	dde080e7          	jalr	-546(ra) # b5c <vprintf>
}
     d86:	60e2                	ld	ra,24(sp)
     d88:	6442                	ld	s0,16(sp)
     d8a:	6125                	addi	sp,sp,96
     d8c:	8082                	ret

0000000000000d8e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     d8e:	1141                	addi	sp,sp,-16
     d90:	e406                	sd	ra,8(sp)
     d92:	e022                	sd	s0,0(sp)
     d94:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     d96:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     d9a:	00002797          	auipc	a5,0x2
     d9e:	a4e7b783          	ld	a5,-1458(a5) # 27e8 <freep>
     da2:	a039                	j	db0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     da4:	6398                	ld	a4,0(a5)
     da6:	00e7e463          	bltu	a5,a4,dae <free+0x20>
     daa:	00e6ea63          	bltu	a3,a4,dbe <free+0x30>
{
     dae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     db0:	fed7fae3          	bgeu	a5,a3,da4 <free+0x16>
     db4:	6398                	ld	a4,0(a5)
     db6:	00e6e463          	bltu	a3,a4,dbe <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dba:	fee7eae3          	bltu	a5,a4,dae <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     dbe:	ff852583          	lw	a1,-8(a0)
     dc2:	6390                	ld	a2,0(a5)
     dc4:	02059813          	slli	a6,a1,0x20
     dc8:	01c85713          	srli	a4,a6,0x1c
     dcc:	9736                	add	a4,a4,a3
     dce:	02e60563          	beq	a2,a4,df8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     dd2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     dd6:	4790                	lw	a2,8(a5)
     dd8:	02061593          	slli	a1,a2,0x20
     ddc:	01c5d713          	srli	a4,a1,0x1c
     de0:	973e                	add	a4,a4,a5
     de2:	02e68263          	beq	a3,a4,e06 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     de6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     de8:	00002717          	auipc	a4,0x2
     dec:	a0f73023          	sd	a5,-1536(a4) # 27e8 <freep>
}
     df0:	60a2                	ld	ra,8(sp)
     df2:	6402                	ld	s0,0(sp)
     df4:	0141                	addi	sp,sp,16
     df6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
     df8:	4618                	lw	a4,8(a2)
     dfa:	9f2d                	addw	a4,a4,a1
     dfc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e00:	6398                	ld	a4,0(a5)
     e02:	6310                	ld	a2,0(a4)
     e04:	b7f9                	j	dd2 <free+0x44>
    p->s.size += bp->s.size;
     e06:	ff852703          	lw	a4,-8(a0)
     e0a:	9f31                	addw	a4,a4,a2
     e0c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e0e:	ff053683          	ld	a3,-16(a0)
     e12:	bfd1                	j	de6 <free+0x58>

0000000000000e14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e14:	7139                	addi	sp,sp,-64
     e16:	fc06                	sd	ra,56(sp)
     e18:	f822                	sd	s0,48(sp)
     e1a:	f04a                	sd	s2,32(sp)
     e1c:	ec4e                	sd	s3,24(sp)
     e1e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e20:	02051993          	slli	s3,a0,0x20
     e24:	0209d993          	srli	s3,s3,0x20
     e28:	09bd                	addi	s3,s3,15
     e2a:	0049d993          	srli	s3,s3,0x4
     e2e:	2985                	addiw	s3,s3,1
     e30:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     e32:	00002517          	auipc	a0,0x2
     e36:	9b653503          	ld	a0,-1610(a0) # 27e8 <freep>
     e3a:	c905                	beqz	a0,e6a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e3e:	4798                	lw	a4,8(a5)
     e40:	09377a63          	bgeu	a4,s3,ed4 <malloc+0xc0>
     e44:	f426                	sd	s1,40(sp)
     e46:	e852                	sd	s4,16(sp)
     e48:	e456                	sd	s5,8(sp)
     e4a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     e4c:	8a4e                	mv	s4,s3
     e4e:	6705                	lui	a4,0x1
     e50:	00e9f363          	bgeu	s3,a4,e56 <malloc+0x42>
     e54:	6a05                	lui	s4,0x1
     e56:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     e5a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     e5e:	00002497          	auipc	s1,0x2
     e62:	98a48493          	addi	s1,s1,-1654 # 27e8 <freep>
  if(p == (char*)-1)
     e66:	5afd                	li	s5,-1
     e68:	a089                	j	eaa <malloc+0x96>
     e6a:	f426                	sd	s1,40(sp)
     e6c:	e852                	sd	s4,16(sp)
     e6e:	e456                	sd	s5,8(sp)
     e70:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     e72:	00002797          	auipc	a5,0x2
     e76:	98e78793          	addi	a5,a5,-1650 # 2800 <base>
     e7a:	00002717          	auipc	a4,0x2
     e7e:	96f73723          	sd	a5,-1682(a4) # 27e8 <freep>
     e82:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     e84:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     e88:	b7d1                	j	e4c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
     e8a:	6398                	ld	a4,0(a5)
     e8c:	e118                	sd	a4,0(a0)
     e8e:	a8b9                	j	eec <malloc+0xd8>
  hp->s.size = nu;
     e90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     e94:	0541                	addi	a0,a0,16
     e96:	00000097          	auipc	ra,0x0
     e9a:	ef8080e7          	jalr	-264(ra) # d8e <free>
  return freep;
     e9e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
     ea0:	c135                	beqz	a0,f04 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ea2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     ea4:	4798                	lw	a4,8(a5)
     ea6:	03277363          	bgeu	a4,s2,ecc <malloc+0xb8>
    if(p == freep)
     eaa:	6098                	ld	a4,0(s1)
     eac:	853e                	mv	a0,a5
     eae:	fef71ae3          	bne	a4,a5,ea2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
     eb2:	8552                	mv	a0,s4
     eb4:	00000097          	auipc	ra,0x0
     eb8:	ba6080e7          	jalr	-1114(ra) # a5a <sbrk>
  if(p == (char*)-1)
     ebc:	fd551ae3          	bne	a0,s5,e90 <malloc+0x7c>
        return 0;
     ec0:	4501                	li	a0,0
     ec2:	74a2                	ld	s1,40(sp)
     ec4:	6a42                	ld	s4,16(sp)
     ec6:	6aa2                	ld	s5,8(sp)
     ec8:	6b02                	ld	s6,0(sp)
     eca:	a03d                	j	ef8 <malloc+0xe4>
     ecc:	74a2                	ld	s1,40(sp)
     ece:	6a42                	ld	s4,16(sp)
     ed0:	6aa2                	ld	s5,8(sp)
     ed2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     ed4:	fae90be3          	beq	s2,a4,e8a <malloc+0x76>
        p->s.size -= nunits;
     ed8:	4137073b          	subw	a4,a4,s3
     edc:	c798                	sw	a4,8(a5)
        p += p->s.size;
     ede:	02071693          	slli	a3,a4,0x20
     ee2:	01c6d713          	srli	a4,a3,0x1c
     ee6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     ee8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     eec:	00002717          	auipc	a4,0x2
     ef0:	8ea73e23          	sd	a0,-1796(a4) # 27e8 <freep>
      return (void*)(p + 1);
     ef4:	01078513          	addi	a0,a5,16
  }
}
     ef8:	70e2                	ld	ra,56(sp)
     efa:	7442                	ld	s0,48(sp)
     efc:	7902                	ld	s2,32(sp)
     efe:	69e2                	ld	s3,24(sp)
     f00:	6121                	addi	sp,sp,64
     f02:	8082                	ret
     f04:	74a2                	ld	s1,40(sp)
     f06:	6a42                	ld	s4,16(sp)
     f08:	6aa2                	ld	s5,8(sp)
     f0a:	6b02                	ld	s6,0(sp)
     f0c:	b7f5                	j	ef8 <malloc+0xe4>

0000000000000f0e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     f0e:	1141                	addi	sp,sp,-16
     f10:	e406                	sd	ra,8(sp)
     f12:	e022                	sd	s0,0(sp)
     f14:	0800                	addi	s0,sp,16
  thread_exit(status);
     f16:	00000097          	auipc	ra,0x0
     f1a:	b74080e7          	jalr	-1164(ra) # a8a <thread_exit>
}
     f1e:	60a2                	ld	ra,8(sp)
     f20:	6402                	ld	s0,0(sp)
     f22:	0141                	addi	sp,sp,16
     f24:	8082                	ret

0000000000000f26 <free_stacks>:
int free_stacks() {
     f26:	7179                	addi	sp,sp,-48
     f28:	f406                	sd	ra,40(sp)
     f2a:	f022                	sd	s0,32(sp)
     f2c:	ec26                	sd	s1,24(sp)
     f2e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f30:	00002797          	auipc	a5,0x2
     f34:	8c87a783          	lw	a5,-1848(a5) # 27f8 <num_threads>
     f38:	04f05063          	blez	a5,f78 <free_stacks+0x52>
     f3c:	e84a                	sd	s2,16(sp)
     f3e:	e44e                	sd	s3,8(sp)
     f40:	4481                	li	s1,0
    free(stacks[i]);
     f42:	00002997          	auipc	s3,0x2
     f46:	8ae98993          	addi	s3,s3,-1874 # 27f0 <stacks>
  for (int i = 0; i < num_threads; i++) {
     f4a:	00002917          	auipc	s2,0x2
     f4e:	8ae90913          	addi	s2,s2,-1874 # 27f8 <num_threads>
    free(stacks[i]);
     f52:	0009b783          	ld	a5,0(s3)
     f56:	00349713          	slli	a4,s1,0x3
     f5a:	97ba                	add	a5,a5,a4
     f5c:	6388                	ld	a0,0(a5)
     f5e:	00000097          	auipc	ra,0x0
     f62:	e30080e7          	jalr	-464(ra) # d8e <free>
  for (int i = 0; i < num_threads; i++) {
     f66:	0485                	addi	s1,s1,1
     f68:	00092703          	lw	a4,0(s2)
     f6c:	0004879b          	sext.w	a5,s1
     f70:	fee7c1e3          	blt	a5,a4,f52 <free_stacks+0x2c>
     f74:	6942                	ld	s2,16(sp)
     f76:	69a2                	ld	s3,8(sp)
  free(stacks);
     f78:	00002497          	auipc	s1,0x2
     f7c:	87848493          	addi	s1,s1,-1928 # 27f0 <stacks>
     f80:	6088                	ld	a0,0(s1)
     f82:	00000097          	auipc	ra,0x0
     f86:	e0c080e7          	jalr	-500(ra) # d8e <free>
  stacks = 0;
     f8a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     f8e:	00002797          	auipc	a5,0x2
     f92:	8607a523          	sw	zero,-1942(a5) # 27f8 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     f96:	47a1                	li	a5,8
     f98:	00002717          	auipc	a4,0x2
     f9c:	84f72023          	sw	a5,-1984(a4) # 27d8 <max_stacks>
  threads_done = 0;
     fa0:	00002797          	auipc	a5,0x2
     fa4:	8407ae23          	sw	zero,-1956(a5) # 27fc <threads_done>
}
     fa8:	4501                	li	a0,0
     faa:	70a2                	ld	ra,40(sp)
     fac:	7402                	ld	s0,32(sp)
     fae:	64e2                	ld	s1,24(sp)
     fb0:	6145                	addi	sp,sp,48
     fb2:	8082                	ret

0000000000000fb4 <expand_num_threads>:
int expand_num_threads() {
     fb4:	1101                	addi	sp,sp,-32
     fb6:	ec06                	sd	ra,24(sp)
     fb8:	e822                	sd	s0,16(sp)
     fba:	e426                	sd	s1,8(sp)
     fbc:	e04a                	sd	s2,0(sp)
     fbe:	1000                	addi	s0,sp,32
  max_stacks *= 2;
     fc0:	00002797          	auipc	a5,0x2
     fc4:	81878793          	addi	a5,a5,-2024 # 27d8 <max_stacks>
     fc8:	4388                	lw	a0,0(a5)
     fca:	0015151b          	slliw	a0,a0,0x1
     fce:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
     fd0:	0035151b          	slliw	a0,a0,0x3
     fd4:	00000097          	auipc	ra,0x0
     fd8:	e40080e7          	jalr	-448(ra) # e14 <malloc>
     fdc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
     fde:	00002617          	auipc	a2,0x2
     fe2:	81a62603          	lw	a2,-2022(a2) # 27f8 <num_threads>
     fe6:	00002497          	auipc	s1,0x2
     fea:	80a48493          	addi	s1,s1,-2038 # 27f0 <stacks>
     fee:	0036161b          	slliw	a2,a2,0x3
     ff2:	608c                	ld	a1,0(s1)
     ff4:	00000097          	auipc	ra,0x0
     ff8:	928080e7          	jalr	-1752(ra) # 91c <memmove>
  free(stacks);
     ffc:	6088                	ld	a0,0(s1)
     ffe:	00000097          	auipc	ra,0x0
    1002:	d90080e7          	jalr	-624(ra) # d8e <free>
  stacks = new_stacks;
    1006:	0124b023          	sd	s2,0(s1)
}
    100a:	4501                	li	a0,0
    100c:	60e2                	ld	ra,24(sp)
    100e:	6442                	ld	s0,16(sp)
    1010:	64a2                	ld	s1,8(sp)
    1012:	6902                	ld	s2,0(sp)
    1014:	6105                	addi	sp,sp,32
    1016:	8082                	ret

0000000000001018 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1018:	7179                	addi	sp,sp,-48
    101a:	f406                	sd	ra,40(sp)
    101c:	f022                	sd	s0,32(sp)
    101e:	e84a                	sd	s2,16(sp)
    1020:	e44e                	sd	s3,8(sp)
    1022:	1800                	addi	s0,sp,48
    1024:	892a                	mv	s2,a0
    1026:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1028:	00001797          	auipc	a5,0x1
    102c:	7c87b783          	ld	a5,1992(a5) # 27f0 <stacks>
    1030:	c3d9                	beqz	a5,10b6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1032:	00001797          	auipc	a5,0x1
    1036:	7a67a783          	lw	a5,1958(a5) # 27d8 <max_stacks>
    103a:	00001717          	auipc	a4,0x1
    103e:	7be72703          	lw	a4,1982(a4) # 27f8 <num_threads>
    1042:	0af71463          	bne	a4,a5,10ea <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
    1046:	04000713          	li	a4,64
    104a:	08e78563          	beq	a5,a4,10d4 <ithread_create+0xbc>
    104e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    1050:	00000097          	auipc	ra,0x0
    1054:	f64080e7          	jalr	-156(ra) # fb4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    1058:	6505                	lui	a0,0x1
    105a:	00000097          	auipc	ra,0x0
    105e:	dba080e7          	jalr	-582(ra) # e14 <malloc>
    1062:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    1064:	00001717          	auipc	a4,0x1
    1068:	79472703          	lw	a4,1940(a4) # 27f8 <num_threads>
    106c:	070e                	slli	a4,a4,0x3
    106e:	00001797          	auipc	a5,0x1
    1072:	7827b783          	ld	a5,1922(a5) # 27f0 <stacks>
    1076:	97ba                	add	a5,a5,a4
    1078:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    107a:	00000697          	auipc	a3,0x0
    107e:	e9468693          	addi	a3,a3,-364 # f0e <ithread_exit>
    1082:	862a                	mv	a2,a0
    1084:	85ce                	mv	a1,s3
    1086:	854a                	mv	a0,s2
    1088:	00000097          	auipc	ra,0x0
    108c:	9f2080e7          	jalr	-1550(ra) # a7a <create_thread>
    1090:	892a                	mv	s2,a0
  if (res != -1) {
    1092:	57fd                	li	a5,-1
    1094:	04f50d63          	beq	a0,a5,10ee <ithread_create+0xd6>
    num_threads++;
    1098:	00001717          	auipc	a4,0x1
    109c:	76070713          	addi	a4,a4,1888 # 27f8 <num_threads>
    10a0:	431c                	lw	a5,0(a4)
    10a2:	2785                	addiw	a5,a5,1
    10a4:	c31c                	sw	a5,0(a4)
    10a6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    10a8:	854a                	mv	a0,s2
    10aa:	70a2                	ld	ra,40(sp)
    10ac:	7402                	ld	s0,32(sp)
    10ae:	6942                	ld	s2,16(sp)
    10b0:	69a2                	ld	s3,8(sp)
    10b2:	6145                	addi	sp,sp,48
    10b4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    10b6:	00001517          	auipc	a0,0x1
    10ba:	72252503          	lw	a0,1826(a0) # 27d8 <max_stacks>
    10be:	0035151b          	slliw	a0,a0,0x3
    10c2:	00000097          	auipc	ra,0x0
    10c6:	d52080e7          	jalr	-686(ra) # e14 <malloc>
    10ca:	00001797          	auipc	a5,0x1
    10ce:	72a7b323          	sd	a0,1830(a5) # 27f0 <stacks>
    10d2:	b785                	j	1032 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    10d4:	00000517          	auipc	a0,0x0
    10d8:	4b450513          	addi	a0,a0,1204 # 1588 <ithread_join+0x474>
    10dc:	00000097          	auipc	ra,0x0
    10e0:	c7c080e7          	jalr	-900(ra) # d58 <printf>
      return -1;
    10e4:	57fd                	li	a5,-1
    10e6:	893e                	mv	s2,a5
    10e8:	b7c1                	j	10a8 <ithread_create+0x90>
    10ea:	ec26                	sd	s1,24(sp)
    10ec:	b7b5                	j	1058 <ithread_create+0x40>
    free(stack_ptr);
    10ee:	8526                	mv	a0,s1
    10f0:	00000097          	auipc	ra,0x0
    10f4:	c9e080e7          	jalr	-866(ra) # d8e <free>
    stacks[num_threads] = 0;
    10f8:	00001717          	auipc	a4,0x1
    10fc:	70072703          	lw	a4,1792(a4) # 27f8 <num_threads>
    1100:	070e                	slli	a4,a4,0x3
    1102:	00001797          	auipc	a5,0x1
    1106:	6ee7b783          	ld	a5,1774(a5) # 27f0 <stacks>
    110a:	97ba                	add	a5,a5,a4
    110c:	0007b023          	sd	zero,0(a5)
    1110:	64e2                	ld	s1,24(sp)
    1112:	bf59                	j	10a8 <ithread_create+0x90>

0000000000001114 <ithread_join>:

int ithread_join(int thread_id) {
    1114:	1101                	addi	sp,sp,-32
    1116:	ec06                	sd	ra,24(sp)
    1118:	e822                	sd	s0,16(sp)
    111a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    111c:	fec40593          	addi	a1,s0,-20
    1120:	00000097          	auipc	ra,0x0
    1124:	962080e7          	jalr	-1694(ra) # a82 <join_thread>
  threads_done++;
    1128:	00001717          	auipc	a4,0x1
    112c:	6d470713          	addi	a4,a4,1748 # 27fc <threads_done>
    1130:	431c                	lw	a5,0(a4)
    1132:	2785                	addiw	a5,a5,1
    1134:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1136:	00001717          	auipc	a4,0x1
    113a:	6c272703          	lw	a4,1730(a4) # 27f8 <num_threads>
    113e:	00f70863          	beq	a4,a5,114e <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
    1142:	fec42503          	lw	a0,-20(s0)
    1146:	60e2                	ld	ra,24(sp)
    1148:	6442                	ld	s0,16(sp)
    114a:	6105                	addi	sp,sp,32
    114c:	8082                	ret
    free_stacks();
    114e:	00000097          	auipc	ra,0x0
    1152:	dd8080e7          	jalr	-552(ra) # f26 <free_stacks>
    1156:	b7f5                	j	1142 <ithread_join+0x2e>
