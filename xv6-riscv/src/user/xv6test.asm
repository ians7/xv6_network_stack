
src/user/_xv6test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_func_shared>:
  printf("Thread %d is running\n", val);
  free(arg);
  return (void *)(uintptr_t)(val + 1);
}

void* thread_func_shared(void *arg) {
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
  int i;
  for (i = 0; i < 50; i++) {
       6:	00002717          	auipc	a4,0x2
       a:	00a72703          	lw	a4,10(a4) # 2010 <shared_counter>
       e:	0017079b          	addiw	a5,a4,1
      12:	0337071b          	addiw	a4,a4,51
      16:	0007869b          	sext.w	a3,a5
      1a:	2785                	addiw	a5,a5,1
      1c:	fee79de3          	bne	a5,a4,16 <thread_func_shared+0x16>
      20:	00002797          	auipc	a5,0x2
      24:	fed7a823          	sw	a3,-16(a5) # 2010 <shared_counter>
    shared_counter++;
  }

  return 0;
}
      28:	4501                	li	a0,0
      2a:	6422                	ld	s0,8(sp)
      2c:	0141                	addi	sp,sp,16
      2e:	8082                	ret

0000000000000030 <exit_all>:
void *exit_all(void *args) {
      30:	1141                	addi	sp,sp,-16
      32:	e406                	sd	ra,8(sp)
      34:	e022                	sd	s0,0(sp)
      36:	0800                	addi	s0,sp,16
  if (val == 9) {
      38:	4118                	lw	a4,0(a0)
      3a:	47a5                	li	a5,9
      3c:	02f70563          	beq	a4,a5,66 <exit_all+0x36>
  sleep(100);
      40:	06400513          	li	a0,100
      44:	00001097          	auipc	ra,0x1
      48:	a06080e7          	jalr	-1530(ra) # a4a <sleep>
  printf("Test 6 FAILED: exit_all failed\n");
      4c:	00001517          	auipc	a0,0x1
      50:	15450513          	addi	a0,a0,340 # 11a0 <ithread_join+0x52>
      54:	00001097          	auipc	ra,0x1
      58:	d3c080e7          	jalr	-708(ra) # d90 <printf>
}
      5c:	4501                	li	a0,0
      5e:	60a2                	ld	ra,8(sp)
      60:	6402                	ld	s0,0(sp)
      62:	0141                	addi	sp,sp,16
      64:	8082                	ret
    sleep(5);
      66:	4515                	li	a0,5
      68:	00001097          	auipc	ra,0x1
      6c:	9e2080e7          	jalr	-1566(ra) # a4a <sleep>
    exit(0);
      70:	4501                	li	a0,0
      72:	00001097          	auipc	ra,0x1
      76:	948080e7          	jalr	-1720(ra) # 9ba <exit>

000000000000007a <prop_mem_dealloc2>:
{
      7a:	1101                	addi	sp,sp,-32
      7c:	ec06                	sd	ra,24(sp)
      7e:	e822                	sd	s0,16(sp)
      80:	e426                	sd	s1,8(sp)
      82:	1000                	addi	s0,sp,32
  sleep(60); // wait for allocation
      84:	03c00513          	li	a0,60
      88:	00001097          	auipc	ra,0x1
      8c:	9c2080e7          	jalr	-1598(ra) # a4a <sleep>
  int val = p[0]; // should be 42 before deallocation
      90:	00002497          	auipc	s1,0x2
      94:	f7048493          	addi	s1,s1,-144 # 2000 <p>
      98:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
      9a:	438c                	lw	a1,0(a5)
      9c:	00001517          	auipc	a0,0x1
      a0:	12450513          	addi	a0,a0,292 # 11c0 <ithread_join+0x72>
      a4:	00001097          	auipc	ra,0x1
      a8:	cec080e7          	jalr	-788(ra) # d90 <printf>
  sleep(40); // wait for deallocation
      ac:	02800513          	li	a0,40
      b0:	00001097          	auipc	ra,0x1
      b4:	99a080e7          	jalr	-1638(ra) # a4a <sleep>
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
      b8:	6098                	ld	a4,0(s1)
      ba:	37ab77b7          	lui	a5,0x37ab7
      be:	078a                	slli	a5,a5,0x2
      c0:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4ebf>
      c4:	04f70763          	beq	a4,a5,112 <prop_mem_dealloc2+0x98>
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
      c8:	00001517          	auipc	a0,0x1
      cc:	13050513          	addi	a0,a0,304 # 11f8 <ithread_join+0xaa>
      d0:	00001097          	auipc	ra,0x1
      d4:	cc0080e7          	jalr	-832(ra) # d90 <printf>
  fail = p[0]; // this should ideally trap or fail
      d8:	00002797          	auipc	a5,0x2
      dc:	f287b783          	ld	a5,-216(a5) # 2000 <p>
      e0:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e2:	85a6                	mv	a1,s1
      e4:	00001517          	auipc	a0,0x1
      e8:	14450513          	addi	a0,a0,324 # 1228 <ithread_join+0xda>
      ec:	00001097          	auipc	ra,0x1
      f0:	ca4080e7          	jalr	-860(ra) # d90 <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f4:	85a6                	mv	a1,s1
      f6:	00001517          	auipc	a0,0x1
      fa:	14a50513          	addi	a0,a0,330 # 1240 <ithread_join+0xf2>
      fe:	00001097          	auipc	ra,0x1
     102:	c92080e7          	jalr	-878(ra) # d90 <printf>
}
     106:	4501                	li	a0,0
     108:	60e2                	ld	ra,24(sp)
     10a:	6442                	ld	s0,16(sp)
     10c:	64a2                	ld	s1,8(sp)
     10e:	6105                	addi	sp,sp,32
     110:	8082                	ret
    printf("FAIL: p is invalid\n");
     112:	00001517          	auipc	a0,0x1
     116:	0ce50513          	addi	a0,a0,206 # 11e0 <ithread_join+0x92>
     11a:	00001097          	auipc	ra,0x1
     11e:	c76080e7          	jalr	-906(ra) # d90 <printf>
    return 0;
     122:	b7d5                	j	106 <prop_mem_dealloc2+0x8c>

0000000000000124 <prop_mem_alloc2>:
  p[1] = 2;
  return 0;
}

void *prop_mem_alloc2(void *arg)
{
     124:	1141                	addi	sp,sp,-16
     126:	e406                	sd	ra,8(sp)
     128:	e022                	sd	s0,0(sp)
     12a:	0800                	addi	s0,sp,16
  sleep(50);
     12c:	03200513          	li	a0,50
     130:	00001097          	auipc	ra,0x1
     134:	91a080e7          	jalr	-1766(ra) # a4a <sleep>
  if(p == (int *)0xdeadbeef) {
     138:	00002717          	auipc	a4,0x2
     13c:	ec873703          	ld	a4,-312(a4) # 2000 <p>
     140:	37ab77b7          	lui	a5,0x37ab7
     144:	078a                	slli	a5,a5,0x2
     146:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4ebf>
     14a:	02f70763          	beq	a4,a5,178 <prop_mem_alloc2+0x54>
    printf("FAIL: p == 0xdeadbeef\n");
    return 0;
  }

  if(p[0] == 3 && p[1] == 2) {
     14e:	4314                	lw	a3,0(a4)
     150:	478d                	li	a5,3
     152:	00f69663          	bne	a3,a5,15e <prop_mem_alloc2+0x3a>
     156:	4358                	lw	a4,4(a4)
     158:	4789                	li	a5,2
     15a:	02f70863          	beq	a4,a5,18a <prop_mem_alloc2+0x66>
    printf("PASSED\n");
    // SUCCESS
  } else {
    printf("FAIL: values did not change for siblings\n");
     15e:	00001517          	auipc	a0,0x1
     162:	13250513          	addi	a0,a0,306 # 1290 <ithread_join+0x142>
     166:	00001097          	auipc	ra,0x1
     16a:	c2a080e7          	jalr	-982(ra) # d90 <printf>
    // FAIL
  }
  return 0;
}
     16e:	4501                	li	a0,0
     170:	60a2                	ld	ra,8(sp)
     172:	6402                	ld	s0,0(sp)
     174:	0141                	addi	sp,sp,16
     176:	8082                	ret
    printf("FAIL: p == 0xdeadbeef\n");
     178:	00001517          	auipc	a0,0x1
     17c:	0f850513          	addi	a0,a0,248 # 1270 <ithread_join+0x122>
     180:	00001097          	auipc	ra,0x1
     184:	c10080e7          	jalr	-1008(ra) # d90 <printf>
    return 0;
     188:	b7dd                	j	16e <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	0fe50513          	addi	a0,a0,254 # 1288 <ithread_join+0x13a>
     192:	00001097          	auipc	ra,0x1
     196:	bfe080e7          	jalr	-1026(ra) # d90 <printf>
     19a:	bfd1                	j	16e <prop_mem_alloc2+0x4a>

000000000000019c <prop_mem_dealloc1>:
{
     19c:	1101                	addi	sp,sp,-32
     19e:	ec06                	sd	ra,24(sp)
     1a0:	e822                	sd	s0,16(sp)
     1a2:	e426                	sd	s1,8(sp)
     1a4:	1000                	addi	s0,sp,32
  p = (int *)sbrk(4096);  // allocate a page
     1a6:	6505                	lui	a0,0x1
     1a8:	00001097          	auipc	ra,0x1
     1ac:	89a080e7          	jalr	-1894(ra) # a42 <sbrk>
     1b0:	00002497          	auipc	s1,0x2
     1b4:	e5048493          	addi	s1,s1,-432 # 2000 <p>
     1b8:	e088                	sd	a0,0(s1)
  p[0] = 42;
     1ba:	02a00793          	li	a5,42
     1be:	c11c                	sw	a5,0(a0)
  sleep(80);              // allow thread 2 to read
     1c0:	05000513          	li	a0,80
     1c4:	00001097          	auipc	ra,0x1
     1c8:	886080e7          	jalr	-1914(ra) # a4a <sleep>
  p = (int *)sbrk(-4096);            // deallocate
     1cc:	757d                	lui	a0,0xfffff
     1ce:	00001097          	auipc	ra,0x1
     1d2:	874080e7          	jalr	-1932(ra) # a42 <sbrk>
     1d6:	e088                	sd	a0,0(s1)
}
     1d8:	4501                	li	a0,0
     1da:	60e2                	ld	ra,24(sp)
     1dc:	6442                	ld	s0,16(sp)
     1de:	64a2                	ld	s1,8(sp)
     1e0:	6105                	addi	sp,sp,32
     1e2:	8082                	ret

00000000000001e4 <prop_mem_alloc1>:
{
     1e4:	1141                	addi	sp,sp,-16
     1e6:	e406                	sd	ra,8(sp)
     1e8:	e022                	sd	s0,0(sp)
     1ea:	0800                	addi	s0,sp,16
  p = (int *)sbrk(4096);
     1ec:	6505                	lui	a0,0x1
     1ee:	00001097          	auipc	ra,0x1
     1f2:	854080e7          	jalr	-1964(ra) # a42 <sbrk>
     1f6:	00002797          	auipc	a5,0x2
     1fa:	e0a78793          	addi	a5,a5,-502 # 2000 <p>
     1fe:	e388                	sd	a0,0(a5)
  p[0] = 3;
     200:	470d                	li	a4,3
     202:	c118                	sw	a4,0(a0)
  p[1] = 2;
     204:	639c                	ld	a5,0(a5)
     206:	4709                	li	a4,2
     208:	c3d8                	sw	a4,4(a5)
}
     20a:	4501                	li	a0,0
     20c:	60a2                	ld	ra,8(sp)
     20e:	6402                	ld	s0,0(sp)
     210:	0141                	addi	sp,sp,16
     212:	8082                	ret

0000000000000214 <thread_func_basic>:
void* thread_func_basic(void *arg) {
     214:	1101                	addi	sp,sp,-32
     216:	ec06                	sd	ra,24(sp)
     218:	e822                	sd	s0,16(sp)
     21a:	e426                	sd	s1,8(sp)
     21c:	e04a                	sd	s2,0(sp)
     21e:	1000                	addi	s0,sp,32
     220:	84aa                	mv	s1,a0
  int val = *(int*)arg;
     222:	00052903          	lw	s2,0(a0) # 1000 <expand_num_threads+0x10>
  printf("Thread %d is running\n", val);
     226:	85ca                	mv	a1,s2
     228:	00001517          	auipc	a0,0x1
     22c:	09850513          	addi	a0,a0,152 # 12c0 <ithread_join+0x172>
     230:	00001097          	auipc	ra,0x1
     234:	b60080e7          	jalr	-1184(ra) # d90 <printf>
  free(arg);
     238:	8526                	mv	a0,s1
     23a:	00001097          	auipc	ra,0x1
     23e:	b8c080e7          	jalr	-1140(ra) # dc6 <free>
}
     242:	0019051b          	addiw	a0,s2,1
     246:	60e2                	ld	ra,24(sp)
     248:	6442                	ld	s0,16(sp)
     24a:	64a2                	ld	s1,8(sp)
     24c:	6902                	ld	s2,0(sp)
     24e:	6105                	addi	sp,sp,32
     250:	8082                	ret

0000000000000252 <thread_func_exit>:
void* thread_func_exit(void *arg) {
     252:	1141                	addi	sp,sp,-16
     254:	e406                	sd	ra,8(sp)
     256:	e022                	sd	s0,0(sp)
     258:	0800                	addi	s0,sp,16
  ithread_exit(0);
     25a:	4501                	li	a0,0
     25c:	00001097          	auipc	ra,0x1
     260:	cec080e7          	jalr	-788(ra) # f48 <ithread_exit>
}
     264:	4501                	li	a0,0
     266:	60a2                	ld	ra,8(sp)
     268:	6402                	ld	s0,0(sp)
     26a:	0141                	addi	sp,sp,16
     26c:	8082                	ret

000000000000026e <test_thread_create>:
void test_thread_create() {
     26e:	1101                	addi	sp,sp,-32
     270:	ec06                	sd	ra,24(sp)
     272:	e822                	sd	s0,16(sp)
     274:	1000                	addi	s0,sp,32
  printf("Test 1: Thread creation\n");
     276:	00001517          	auipc	a0,0x1
     27a:	06250513          	addi	a0,a0,98 # 12d8 <ithread_join+0x18a>
     27e:	00001097          	auipc	ra,0x1
     282:	b12080e7          	jalr	-1262(ra) # d90 <printf>
  int *arg = malloc(sizeof(int));
     286:	4511                	li	a0,4
     288:	00001097          	auipc	ra,0x1
     28c:	bc0080e7          	jalr	-1088(ra) # e48 <malloc>
     290:	85aa                	mv	a1,a0
  *arg = 0;
     292:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     296:	00000517          	auipc	a0,0x0
     29a:	f7e50513          	addi	a0,a0,-130 # 214 <thread_func_basic>
     29e:	00001097          	auipc	ra,0x1
     2a2:	db6080e7          	jalr	-586(ra) # 1054 <ithread_create>
  if (tid < 0) {
     2a6:	02054763          	bltz	a0,2d4 <test_thread_create+0x66>
     2aa:	e426                	sd	s1,8(sp)
     2ac:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2ae:	85aa                	mv	a1,a0
     2b0:	00001517          	auipc	a0,0x1
     2b4:	07050513          	addi	a0,a0,112 # 1320 <ithread_join+0x1d2>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	ad8080e7          	jalr	-1320(ra) # d90 <printf>
    ithread_join(tid);
     2c0:	8526                	mv	a0,s1
     2c2:	00001097          	auipc	ra,0x1
     2c6:	e8c080e7          	jalr	-372(ra) # 114e <ithread_join>
     2ca:	64a2                	ld	s1,8(sp)
}
     2cc:	60e2                	ld	ra,24(sp)
     2ce:	6442                	ld	s0,16(sp)
     2d0:	6105                	addi	sp,sp,32
     2d2:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d4:	00001517          	auipc	a0,0x1
     2d8:	02450513          	addi	a0,a0,36 # 12f8 <ithread_join+0x1aa>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	ab4080e7          	jalr	-1356(ra) # d90 <printf>
     2e4:	b7e5                	j	2cc <test_thread_create+0x5e>

00000000000002e6 <test_global_pointer_dealloc>:
void test_global_pointer_dealloc() {
     2e6:	1101                	addi	sp,sp,-32
     2e8:	ec06                	sd	ra,24(sp)
     2ea:	e822                	sd	s0,16(sp)
     2ec:	e426                	sd	s1,8(sp)
     2ee:	e04a                	sd	s2,0(sp)
     2f0:	1000                	addi	s0,sp,32
  printf("Test 7: sbrk(-) Test\n");
     2f2:	00001517          	auipc	a0,0x1
     2f6:	05e50513          	addi	a0,a0,94 # 1350 <ithread_join+0x202>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	a96080e7          	jalr	-1386(ra) # d90 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     302:	4581                	li	a1,0
     304:	00000517          	auipc	a0,0x0
     308:	e9850513          	addi	a0,a0,-360 # 19c <prop_mem_dealloc1>
     30c:	00001097          	auipc	ra,0x1
     310:	d48080e7          	jalr	-696(ra) # 1054 <ithread_create>
     314:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     316:	4581                	li	a1,0
     318:	00000517          	auipc	a0,0x0
     31c:	d6250513          	addi	a0,a0,-670 # 7a <prop_mem_dealloc2>
     320:	00001097          	auipc	ra,0x1
     324:	d34080e7          	jalr	-716(ra) # 1054 <ithread_create>
     328:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32a:	854a                	mv	a0,s2
     32c:	00001097          	auipc	ra,0x1
     330:	e22080e7          	jalr	-478(ra) # 114e <ithread_join>
  ithread_join(tid2);
     334:	8526                	mv	a0,s1
     336:	00001097          	auipc	ra,0x1
     33a:	e18080e7          	jalr	-488(ra) # 114e <ithread_join>
}
     33e:	60e2                	ld	ra,24(sp)
     340:	6442                	ld	s0,16(sp)
     342:	64a2                	ld	s1,8(sp)
     344:	6902                	ld	s2,0(sp)
     346:	6105                	addi	sp,sp,32
     348:	8082                	ret

000000000000034a <test_global_pointer_alloc>:

void test_global_pointer_alloc() {
     34a:	1101                	addi	sp,sp,-32
     34c:	ec06                	sd	ra,24(sp)
     34e:	e822                	sd	s0,16(sp)
     350:	e426                	sd	s1,8(sp)
     352:	e04a                	sd	s2,0(sp)
     354:	1000                	addi	s0,sp,32
  printf("Test 6: sbrk(+) Test\n");
     356:	00001517          	auipc	a0,0x1
     35a:	01250513          	addi	a0,a0,18 # 1368 <ithread_join+0x21a>
     35e:	00001097          	auipc	ra,0x1
     362:	a32080e7          	jalr	-1486(ra) # d90 <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     366:	4581                	li	a1,0
     368:	00000517          	auipc	a0,0x0
     36c:	e7c50513          	addi	a0,a0,-388 # 1e4 <prop_mem_alloc1>
     370:	00001097          	auipc	ra,0x1
     374:	ce4080e7          	jalr	-796(ra) # 1054 <ithread_create>
     378:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37a:	4581                	li	a1,0
     37c:	00000517          	auipc	a0,0x0
     380:	da850513          	addi	a0,a0,-600 # 124 <prop_mem_alloc2>
     384:	00001097          	auipc	ra,0x1
     388:	cd0080e7          	jalr	-816(ra) # 1054 <ithread_create>
     38c:	84aa                	mv	s1,a0
  ithread_join(tid1);
     38e:	854a                	mv	a0,s2
     390:	00001097          	auipc	ra,0x1
     394:	dbe080e7          	jalr	-578(ra) # 114e <ithread_join>
  ithread_join(tid2);
     398:	8526                	mv	a0,s1
     39a:	00001097          	auipc	ra,0x1
     39e:	db4080e7          	jalr	-588(ra) # 114e <ithread_join>

}
     3a2:	60e2                	ld	ra,24(sp)
     3a4:	6442                	ld	s0,16(sp)
     3a6:	64a2                	ld	s1,8(sp)
     3a8:	6902                	ld	s2,0(sp)
     3aa:	6105                	addi	sp,sp,32
     3ac:	8082                	ret

00000000000003ae <test_thread_join>:

//test joining of threads

void test_thread_join() {
     3ae:	1141                	addi	sp,sp,-16
     3b0:	e406                	sd	ra,8(sp)
     3b2:	e022                	sd	s0,0(sp)
     3b4:	0800                	addi	s0,sp,16
  printf("Test 2: Joining threads\n");
     3b6:	00001517          	auipc	a0,0x1
     3ba:	fca50513          	addi	a0,a0,-54 # 1380 <ithread_join+0x232>
     3be:	00001097          	auipc	ra,0x1
     3c2:	9d2080e7          	jalr	-1582(ra) # d90 <printf>

  int *arg = malloc(sizeof(int));
     3c6:	4511                	li	a0,4
     3c8:	00001097          	auipc	ra,0x1
     3cc:	a80080e7          	jalr	-1408(ra) # e48 <malloc>
     3d0:	85aa                	mv	a1,a0
  *arg = 100;
     3d2:	06400793          	li	a5,100
     3d6:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3d8:	00000517          	auipc	a0,0x0
     3dc:	e3c50513          	addi	a0,a0,-452 # 214 <thread_func_basic>
     3e0:	00001097          	auipc	ra,0x1
     3e4:	c74080e7          	jalr	-908(ra) # 1054 <ithread_create>

  if (tid < 0) {
     3e8:	02054763          	bltz	a0,416 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ec:	00001097          	auipc	ra,0x1
     3f0:	d62080e7          	jalr	-670(ra) # 114e <ithread_join>
     3f4:	85aa                	mv	a1,a0
  if (status == 101) {
     3f6:	06500793          	li	a5,101
     3fa:	02f50763          	beq	a0,a5,428 <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     3fe:	00001517          	auipc	a0,0x1
     402:	00250513          	addi	a0,a0,2 # 1400 <ithread_join+0x2b2>
     406:	00001097          	auipc	ra,0x1
     40a:	98a080e7          	jalr	-1654(ra) # d90 <printf>
  }
}
     40e:	60a2                	ld	ra,8(sp)
     410:	6402                	ld	s0,0(sp)
     412:	0141                	addi	sp,sp,16
     414:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     416:	00001517          	auipc	a0,0x1
     41a:	f8a50513          	addi	a0,a0,-118 # 13a0 <ithread_join+0x252>
     41e:	00001097          	auipc	ra,0x1
     422:	972080e7          	jalr	-1678(ra) # d90 <printf>
    return;
     426:	b7e5                	j	40e <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     428:	06500593          	li	a1,101
     42c:	00001517          	auipc	a0,0x1
     430:	fa450513          	addi	a0,a0,-92 # 13d0 <ithread_join+0x282>
     434:	00001097          	auipc	ra,0x1
     438:	95c080e7          	jalr	-1700(ra) # d90 <printf>
     43c:	bfc9                	j	40e <test_thread_join+0x60>

000000000000043e <test_shared_memory>:


//test shared memory

void test_shared_memory() {
     43e:	7139                	addi	sp,sp,-64
     440:	fc06                	sd	ra,56(sp)
     442:	f822                	sd	s0,48(sp)
     444:	f426                	sd	s1,40(sp)
     446:	f04a                	sd	s2,32(sp)
     448:	ec4e                	sd	s3,24(sp)
     44a:	e852                	sd	s4,16(sp)
     44c:	0080                	addi	s0,sp,64
  printf("Test 3: Shared memory between threads\n");
     44e:	00001517          	auipc	a0,0x1
     452:	fda50513          	addi	a0,a0,-38 # 1428 <ithread_join+0x2da>
     456:	00001097          	auipc	ra,0x1
     45a:	93a080e7          	jalr	-1734(ra) # d90 <printf>

  shared_counter = 0;
     45e:	00002797          	auipc	a5,0x2
     462:	ba07a923          	sw	zero,-1102(a5) # 2010 <shared_counter>
  int tids[4];
  for (int i = 0; i < 4; i++) {
     466:	fc040493          	addi	s1,s0,-64
     46a:	fd040993          	addi	s3,s0,-48
  shared_counter = 0;
     46e:	8926                	mv	s2,s1
    tids[i] = ithread_create(thread_func_shared, 0);
     470:	00000a17          	auipc	s4,0x0
     474:	b90a0a13          	addi	s4,s4,-1136 # 0 <thread_func_shared>
     478:	4581                	li	a1,0
     47a:	8552                	mv	a0,s4
     47c:	00001097          	auipc	ra,0x1
     480:	bd8080e7          	jalr	-1064(ra) # 1054 <ithread_create>
     484:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     488:	0911                	addi	s2,s2,4
     48a:	ff3917e3          	bne	s2,s3,478 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48e:	4088                	lw	a0,0(s1)
     490:	00001097          	auipc	ra,0x1
     494:	cbe080e7          	jalr	-834(ra) # 114e <ithread_join>
  for (int i = 0; i < 4; i++) {
     498:	0491                	addi	s1,s1,4
     49a:	ff349ae3          	bne	s1,s3,48e <test_shared_memory+0x50>
  }

  if (shared_counter == 200) {
     49e:	00002597          	auipc	a1,0x2
     4a2:	b725a583          	lw	a1,-1166(a1) # 2010 <shared_counter>
     4a6:	0c800793          	li	a5,200
     4aa:	02f58263          	beq	a1,a5,4ce <test_shared_memory+0x90>
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
  } else {
    printf("Test 3 FAILED - shared_counter = %d\n", shared_counter);
     4ae:	00001517          	auipc	a0,0x1
     4b2:	fca50513          	addi	a0,a0,-54 # 1478 <ithread_join+0x32a>
     4b6:	00001097          	auipc	ra,0x1
     4ba:	8da080e7          	jalr	-1830(ra) # d90 <printf>
  }
}
     4be:	70e2                	ld	ra,56(sp)
     4c0:	7442                	ld	s0,48(sp)
     4c2:	74a2                	ld	s1,40(sp)
     4c4:	7902                	ld	s2,32(sp)
     4c6:	69e2                	ld	s3,24(sp)
     4c8:	6a42                	ld	s4,16(sp)
     4ca:	6121                	addi	sp,sp,64
     4cc:	8082                	ret
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
     4ce:	0c800593          	li	a1,200
     4d2:	00001517          	auipc	a0,0x1
     4d6:	f7e50513          	addi	a0,a0,-130 # 1450 <ithread_join+0x302>
     4da:	00001097          	auipc	ra,0x1
     4de:	8b6080e7          	jalr	-1866(ra) # d90 <printf>
     4e2:	bff1                	j	4be <test_shared_memory+0x80>

00000000000004e4 <test_exit>:

//test exit off of return

void test_exit() {
     4e4:	1141                	addi	sp,sp,-16
     4e6:	e406                	sd	ra,8(sp)
     4e8:	e022                	sd	s0,0(sp)
     4ea:	0800                	addi	s0,sp,16
  printf("Test 4: Graceful exit via ithread_exit\n");
     4ec:	00001517          	auipc	a0,0x1
     4f0:	fb450513          	addi	a0,a0,-76 # 14a0 <ithread_join+0x352>
     4f4:	00001097          	auipc	ra,0x1
     4f8:	89c080e7          	jalr	-1892(ra) # d90 <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4fc:	4581                	li	a1,0
     4fe:	00000517          	auipc	a0,0x0
     502:	d5450513          	addi	a0,a0,-684 # 252 <thread_func_exit>
     506:	00001097          	auipc	ra,0x1
     50a:	b4e080e7          	jalr	-1202(ra) # 1054 <ithread_create>
  int status = ithread_join(tid);
     50e:	00001097          	auipc	ra,0x1
     512:	c40080e7          	jalr	-960(ra) # 114e <ithread_join>
     516:	85aa                	mv	a1,a0

  if (status == 0) {
     518:	ed09                	bnez	a0,532 <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     51a:	00001517          	auipc	a0,0x1
     51e:	fae50513          	addi	a0,a0,-82 # 14c8 <ithread_join+0x37a>
     522:	00001097          	auipc	ra,0x1
     526:	86e080e7          	jalr	-1938(ra) # d90 <printf>
  } else {
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
  }
}
     52a:	60a2                	ld	ra,8(sp)
     52c:	6402                	ld	s0,0(sp)
     52e:	0141                	addi	sp,sp,16
     530:	8082                	ret
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
     532:	00001517          	auipc	a0,0x1
     536:	fd650513          	addi	a0,a0,-42 # 1508 <ithread_join+0x3ba>
     53a:	00001097          	auipc	ra,0x1
     53e:	856080e7          	jalr	-1962(ra) # d90 <printf>
}
     542:	b7e5                	j	52a <test_exit+0x46>

0000000000000544 <test_exit_all>:

void test_exit_all() {
     544:	7119                	addi	sp,sp,-128
     546:	fc86                	sd	ra,120(sp)
     548:	f8a2                	sd	s0,112(sp)
     54a:	f4a6                	sd	s1,104(sp)
     54c:	f0ca                	sd	s2,96(sp)
     54e:	ecce                	sd	s3,88(sp)
     550:	e8d2                	sd	s4,80(sp)
     552:	e4d6                	sd	s5,72(sp)
     554:	e0da                	sd	s6,64(sp)
     556:	fc5e                	sd	s7,56(sp)
     558:	0100                	addi	s0,sp,128
  printf("Test 5: Graceful exit of all threads via exit\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	fde50513          	addi	a0,a0,-34 # 1538 <ithread_join+0x3ea>
     562:	00001097          	auipc	ra,0x1
     566:	82e080e7          	jalr	-2002(ra) # d90 <printf>
  int *num = malloc(10*sizeof(int));
     56a:	02800513          	li	a0,40
     56e:	00001097          	auipc	ra,0x1
     572:	8da080e7          	jalr	-1830(ra) # e48 <malloc>
     576:	8baa                	mv	s7,a0
  int tids[10];
  for (int i = 0; i < 10; i++) {
     578:	89aa                	mv	s3,a0
     57a:	f8840493          	addi	s1,s0,-120
  int *num = malloc(10*sizeof(int));
     57e:	8a26                	mv	s4,s1
  for (int i = 0; i < 10; i++) {
     580:	4901                	li	s2,0
    num[i] = i;
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     582:	00000b17          	auipc	s6,0x0
     586:	aaeb0b13          	addi	s6,s6,-1362 # 30 <exit_all>
  for (int i = 0; i < 10; i++) {
     58a:	4aa9                	li	s5,10
    num[i] = i;
     58c:	0129a023          	sw	s2,0(s3)
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     590:	85ce                	mv	a1,s3
     592:	855a                	mv	a0,s6
     594:	00001097          	auipc	ra,0x1
     598:	ac0080e7          	jalr	-1344(ra) # 1054 <ithread_create>
     59c:	00aa2023          	sw	a0,0(s4)
  for (int i = 0; i < 10; i++) {
     5a0:	2905                	addiw	s2,s2,1
     5a2:	0991                	addi	s3,s3,4
     5a4:	0a11                	addi	s4,s4,4
     5a6:	ff5913e3          	bne	s2,s5,58c <test_exit_all+0x48>
     5aa:	02848913          	addi	s2,s1,40
  }
  for (int i = 0; i < 10; i++) {
    ithread_join(tids[i]);
     5ae:	4088                	lw	a0,0(s1)
     5b0:	00001097          	auipc	ra,0x1
     5b4:	b9e080e7          	jalr	-1122(ra) # 114e <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b8:	0491                	addi	s1,s1,4
     5ba:	ff249ae3          	bne	s1,s2,5ae <test_exit_all+0x6a>
  }
  free(num);
     5be:	855e                	mv	a0,s7
     5c0:	00001097          	auipc	ra,0x1
     5c4:	806080e7          	jalr	-2042(ra) # dc6 <free>
}
     5c8:	70e6                	ld	ra,120(sp)
     5ca:	7446                	ld	s0,112(sp)
     5cc:	74a6                	ld	s1,104(sp)
     5ce:	7906                	ld	s2,96(sp)
     5d0:	69e6                	ld	s3,88(sp)
     5d2:	6a46                	ld	s4,80(sp)
     5d4:	6aa6                	ld	s5,72(sp)
     5d6:	6b06                	ld	s6,64(sp)
     5d8:	7be2                	ld	s7,56(sp)
     5da:	6109                	addi	sp,sp,128
     5dc:	8082                	ret

00000000000005de <main>:

int main(int argc, char *argv[]) {
     5de:	1101                	addi	sp,sp,-32
     5e0:	ec06                	sd	ra,24(sp)
     5e2:	e822                	sd	s0,16(sp)
     5e4:	1000                	addi	s0,sp,32
  if (argc > 2) {
     5e6:	4789                	li	a5,2
     5e8:	02a7d163          	bge	a5,a0,60a <main+0x2c>
     5ec:	e426                	sd	s1,8(sp)
    printf("Needs the format: xv6test (1-7)\n", argv[0]);
     5ee:	618c                	ld	a1,0(a1)
     5f0:	00001517          	auipc	a0,0x1
     5f4:	f7850513          	addi	a0,a0,-136 # 1568 <ithread_join+0x41a>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	798080e7          	jalr	1944(ra) # d90 <printf>
    exit(1);
     600:	4505                	li	a0,1
     602:	00000097          	auipc	ra,0x0
     606:	3b8080e7          	jalr	952(ra) # 9ba <exit>
     60a:	e426                	sd	s1,8(sp)
     60c:	84aa                	mv	s1,a0
  }

  int test = atoi(argv[1]);
     60e:	6588                	ld	a0,8(a1)
     610:	00000097          	auipc	ra,0x0
     614:	2b0080e7          	jalr	688(ra) # 8c0 <atoi>
  if(argc == 2){ 
     618:	4789                	li	a5,2
     61a:	08f49063          	bne	s1,a5,69a <main+0xbc>
  switch (test) {
     61e:	357d                	addiw	a0,a0,-1
     620:	0005071b          	sext.w	a4,a0
     624:	4799                	li	a5,6
     626:	06e7e163          	bltu	a5,a4,688 <main+0xaa>
     62a:	02051793          	slli	a5,a0,0x20
     62e:	01e7d513          	srli	a0,a5,0x1e
     632:	00001717          	auipc	a4,0x1
     636:	fc270713          	addi	a4,a4,-62 # 15f4 <ithread_join+0x4a6>
     63a:	953a                	add	a0,a0,a4
     63c:	411c                	lw	a5,0(a0)
     63e:	97ba                	add	a5,a5,a4
     640:	8782                	jr	a5
    case 1:
      test_thread_create();
     642:	00000097          	auipc	ra,0x0
     646:	c2c080e7          	jalr	-980(ra) # 26e <test_thread_create>
      break;
     64a:	a0c5                	j	72a <main+0x14c>
    case 2:
      test_thread_join();
     64c:	00000097          	auipc	ra,0x0
     650:	d62080e7          	jalr	-670(ra) # 3ae <test_thread_join>
      break;
     654:	a8d9                	j	72a <main+0x14c>
    case 3:
      test_shared_memory();
     656:	00000097          	auipc	ra,0x0
     65a:	de8080e7          	jalr	-536(ra) # 43e <test_shared_memory>
      break;
     65e:	a0f1                	j	72a <main+0x14c>
    case 4:
      test_exit();
     660:	00000097          	auipc	ra,0x0
     664:	e84080e7          	jalr	-380(ra) # 4e4 <test_exit>
      break;
     668:	a0c9                	j	72a <main+0x14c>
    case 5:
      test_exit_all();
     66a:	00000097          	auipc	ra,0x0
     66e:	eda080e7          	jalr	-294(ra) # 544 <test_exit_all>
      break;
     672:	a865                	j	72a <main+0x14c>
    case 6:
      test_global_pointer_alloc();
     674:	00000097          	auipc	ra,0x0
     678:	cd6080e7          	jalr	-810(ra) # 34a <test_global_pointer_alloc>
      break;
     67c:	a07d                	j	72a <main+0x14c>
    case 7:
      test_global_pointer_dealloc();
     67e:	00000097          	auipc	ra,0x0
     682:	c68080e7          	jalr	-920(ra) # 2e6 <test_global_pointer_dealloc>
      break;
     686:	a055                	j	72a <main+0x14c>
    default:
      printf("Invalid test number. Choose 1-5.\n");
     688:	00001517          	auipc	a0,0x1
     68c:	f0850513          	addi	a0,a0,-248 # 1590 <ithread_join+0x442>
     690:	00000097          	auipc	ra,0x0
     694:	700080e7          	jalr	1792(ra) # d90 <printf>
     698:	a849                	j	72a <main+0x14c>
  }
  }else{
   test_thread_create();
     69a:	00000097          	auipc	ra,0x0
     69e:	bd4080e7          	jalr	-1068(ra) # 26e <test_thread_create>
   printf("\n");
     6a2:	00001517          	auipc	a0,0x1
     6a6:	f1650513          	addi	a0,a0,-234 # 15b8 <ithread_join+0x46a>
     6aa:	00000097          	auipc	ra,0x0
     6ae:	6e6080e7          	jalr	1766(ra) # d90 <printf>
   test_thread_join();
     6b2:	00000097          	auipc	ra,0x0
     6b6:	cfc080e7          	jalr	-772(ra) # 3ae <test_thread_join>
   printf("\n");
     6ba:	00001517          	auipc	a0,0x1
     6be:	efe50513          	addi	a0,a0,-258 # 15b8 <ithread_join+0x46a>
     6c2:	00000097          	auipc	ra,0x0
     6c6:	6ce080e7          	jalr	1742(ra) # d90 <printf>
   test_shared_memory();
     6ca:	00000097          	auipc	ra,0x0
     6ce:	d74080e7          	jalr	-652(ra) # 43e <test_shared_memory>
   printf("\n");
     6d2:	00001517          	auipc	a0,0x1
     6d6:	ee650513          	addi	a0,a0,-282 # 15b8 <ithread_join+0x46a>
     6da:	00000097          	auipc	ra,0x0
     6de:	6b6080e7          	jalr	1718(ra) # d90 <printf>
   test_exit();
     6e2:	00000097          	auipc	ra,0x0
     6e6:	e02080e7          	jalr	-510(ra) # 4e4 <test_exit>
   printf("\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	ece50513          	addi	a0,a0,-306 # 15b8 <ithread_join+0x46a>
     6f2:	00000097          	auipc	ra,0x0
     6f6:	69e080e7          	jalr	1694(ra) # d90 <printf>
   // test_exit_all();
   printf("\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	ebe50513          	addi	a0,a0,-322 # 15b8 <ithread_join+0x46a>
     702:	00000097          	auipc	ra,0x0
     706:	68e080e7          	jalr	1678(ra) # d90 <printf>
   test_global_pointer_alloc();
     70a:	00000097          	auipc	ra,0x0
     70e:	c40080e7          	jalr	-960(ra) # 34a <test_global_pointer_alloc>
   printf("\n");
     712:	00001517          	auipc	a0,0x1
     716:	ea650513          	addi	a0,a0,-346 # 15b8 <ithread_join+0x46a>
     71a:	00000097          	auipc	ra,0x0
     71e:	676080e7          	jalr	1654(ra) # d90 <printf>
   test_global_pointer_dealloc();
     722:	00000097          	auipc	ra,0x0
     726:	bc4080e7          	jalr	-1084(ra) # 2e6 <test_global_pointer_dealloc>
  }

  exit(0);
     72a:	4501                	li	a0,0
     72c:	00000097          	auipc	ra,0x0
     730:	28e080e7          	jalr	654(ra) # 9ba <exit>

0000000000000734 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     734:	1141                	addi	sp,sp,-16
     736:	e406                	sd	ra,8(sp)
     738:	e022                	sd	s0,0(sp)
     73a:	0800                	addi	s0,sp,16
  extern int main();
  main();
     73c:	00000097          	auipc	ra,0x0
     740:	ea2080e7          	jalr	-350(ra) # 5de <main>
  exit(0);
     744:	4501                	li	a0,0
     746:	00000097          	auipc	ra,0x0
     74a:	274080e7          	jalr	628(ra) # 9ba <exit>

000000000000074e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     74e:	1141                	addi	sp,sp,-16
     750:	e422                	sd	s0,8(sp)
     752:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     754:	87aa                	mv	a5,a0
     756:	0585                	addi	a1,a1,1
     758:	0785                	addi	a5,a5,1
     75a:	fff5c703          	lbu	a4,-1(a1)
     75e:	fee78fa3          	sb	a4,-1(a5)
     762:	fb75                	bnez	a4,756 <strcpy+0x8>
    ;
  return os;
}
     764:	6422                	ld	s0,8(sp)
     766:	0141                	addi	sp,sp,16
     768:	8082                	ret

000000000000076a <strcmp>:

int
strcmp(const char *p, const char *q)
{
     76a:	1141                	addi	sp,sp,-16
     76c:	e422                	sd	s0,8(sp)
     76e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     770:	00054783          	lbu	a5,0(a0)
     774:	cb91                	beqz	a5,788 <strcmp+0x1e>
     776:	0005c703          	lbu	a4,0(a1)
     77a:	00f71763          	bne	a4,a5,788 <strcmp+0x1e>
    p++, q++;
     77e:	0505                	addi	a0,a0,1
     780:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     782:	00054783          	lbu	a5,0(a0)
     786:	fbe5                	bnez	a5,776 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     788:	0005c503          	lbu	a0,0(a1)
}
     78c:	40a7853b          	subw	a0,a5,a0
     790:	6422                	ld	s0,8(sp)
     792:	0141                	addi	sp,sp,16
     794:	8082                	ret

0000000000000796 <strlen>:

uint
strlen(const char *s)
{
     796:	1141                	addi	sp,sp,-16
     798:	e422                	sd	s0,8(sp)
     79a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     79c:	00054783          	lbu	a5,0(a0)
     7a0:	cf91                	beqz	a5,7bc <strlen+0x26>
     7a2:	0505                	addi	a0,a0,1
     7a4:	87aa                	mv	a5,a0
     7a6:	86be                	mv	a3,a5
     7a8:	0785                	addi	a5,a5,1
     7aa:	fff7c703          	lbu	a4,-1(a5)
     7ae:	ff65                	bnez	a4,7a6 <strlen+0x10>
     7b0:	40a6853b          	subw	a0,a3,a0
     7b4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     7b6:	6422                	ld	s0,8(sp)
     7b8:	0141                	addi	sp,sp,16
     7ba:	8082                	ret
  for(n = 0; s[n]; n++)
     7bc:	4501                	li	a0,0
     7be:	bfe5                	j	7b6 <strlen+0x20>

00000000000007c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     7c0:	1141                	addi	sp,sp,-16
     7c2:	e422                	sd	s0,8(sp)
     7c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     7c6:	ca19                	beqz	a2,7dc <memset+0x1c>
     7c8:	87aa                	mv	a5,a0
     7ca:	1602                	slli	a2,a2,0x20
     7cc:	9201                	srli	a2,a2,0x20
     7ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     7d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     7d6:	0785                	addi	a5,a5,1
     7d8:	fee79de3          	bne	a5,a4,7d2 <memset+0x12>
  }
  return dst;
}
     7dc:	6422                	ld	s0,8(sp)
     7de:	0141                	addi	sp,sp,16
     7e0:	8082                	ret

00000000000007e2 <strchr>:

char*
strchr(const char *s, char c)
{
     7e2:	1141                	addi	sp,sp,-16
     7e4:	e422                	sd	s0,8(sp)
     7e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     7e8:	00054783          	lbu	a5,0(a0)
     7ec:	cb99                	beqz	a5,802 <strchr+0x20>
    if(*s == c)
     7ee:	00f58763          	beq	a1,a5,7fc <strchr+0x1a>
  for(; *s; s++)
     7f2:	0505                	addi	a0,a0,1
     7f4:	00054783          	lbu	a5,0(a0)
     7f8:	fbfd                	bnez	a5,7ee <strchr+0xc>
      return (char*)s;
  return 0;
     7fa:	4501                	li	a0,0
}
     7fc:	6422                	ld	s0,8(sp)
     7fe:	0141                	addi	sp,sp,16
     800:	8082                	ret
  return 0;
     802:	4501                	li	a0,0
     804:	bfe5                	j	7fc <strchr+0x1a>

0000000000000806 <gets>:

char*
gets(char *buf, int max)
{
     806:	711d                	addi	sp,sp,-96
     808:	ec86                	sd	ra,88(sp)
     80a:	e8a2                	sd	s0,80(sp)
     80c:	e4a6                	sd	s1,72(sp)
     80e:	e0ca                	sd	s2,64(sp)
     810:	fc4e                	sd	s3,56(sp)
     812:	f852                	sd	s4,48(sp)
     814:	f456                	sd	s5,40(sp)
     816:	f05a                	sd	s6,32(sp)
     818:	ec5e                	sd	s7,24(sp)
     81a:	1080                	addi	s0,sp,96
     81c:	8baa                	mv	s7,a0
     81e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     820:	892a                	mv	s2,a0
     822:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     824:	4aa9                	li	s5,10
     826:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     828:	89a6                	mv	s3,s1
     82a:	2485                	addiw	s1,s1,1
     82c:	0344d863          	bge	s1,s4,85c <gets+0x56>
    cc = read(0, &c, 1);
     830:	4605                	li	a2,1
     832:	faf40593          	addi	a1,s0,-81
     836:	4501                	li	a0,0
     838:	00000097          	auipc	ra,0x0
     83c:	19a080e7          	jalr	410(ra) # 9d2 <read>
    if(cc < 1)
     840:	00a05e63          	blez	a0,85c <gets+0x56>
    buf[i++] = c;
     844:	faf44783          	lbu	a5,-81(s0)
     848:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     84c:	01578763          	beq	a5,s5,85a <gets+0x54>
     850:	0905                	addi	s2,s2,1
     852:	fd679be3          	bne	a5,s6,828 <gets+0x22>
    buf[i++] = c;
     856:	89a6                	mv	s3,s1
     858:	a011                	j	85c <gets+0x56>
     85a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     85c:	99de                	add	s3,s3,s7
     85e:	00098023          	sb	zero,0(s3)
  return buf;
}
     862:	855e                	mv	a0,s7
     864:	60e6                	ld	ra,88(sp)
     866:	6446                	ld	s0,80(sp)
     868:	64a6                	ld	s1,72(sp)
     86a:	6906                	ld	s2,64(sp)
     86c:	79e2                	ld	s3,56(sp)
     86e:	7a42                	ld	s4,48(sp)
     870:	7aa2                	ld	s5,40(sp)
     872:	7b02                	ld	s6,32(sp)
     874:	6be2                	ld	s7,24(sp)
     876:	6125                	addi	sp,sp,96
     878:	8082                	ret

000000000000087a <stat>:

int
stat(const char *n, struct stat *st)
{
     87a:	1101                	addi	sp,sp,-32
     87c:	ec06                	sd	ra,24(sp)
     87e:	e822                	sd	s0,16(sp)
     880:	e04a                	sd	s2,0(sp)
     882:	1000                	addi	s0,sp,32
     884:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     886:	4581                	li	a1,0
     888:	00000097          	auipc	ra,0x0
     88c:	172080e7          	jalr	370(ra) # 9fa <open>
  if(fd < 0)
     890:	02054663          	bltz	a0,8bc <stat+0x42>
     894:	e426                	sd	s1,8(sp)
     896:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     898:	85ca                	mv	a1,s2
     89a:	00000097          	auipc	ra,0x0
     89e:	178080e7          	jalr	376(ra) # a12 <fstat>
     8a2:	892a                	mv	s2,a0
  close(fd);
     8a4:	8526                	mv	a0,s1
     8a6:	00000097          	auipc	ra,0x0
     8aa:	13c080e7          	jalr	316(ra) # 9e2 <close>
  return r;
     8ae:	64a2                	ld	s1,8(sp)
}
     8b0:	854a                	mv	a0,s2
     8b2:	60e2                	ld	ra,24(sp)
     8b4:	6442                	ld	s0,16(sp)
     8b6:	6902                	ld	s2,0(sp)
     8b8:	6105                	addi	sp,sp,32
     8ba:	8082                	ret
    return -1;
     8bc:	597d                	li	s2,-1
     8be:	bfcd                	j	8b0 <stat+0x36>

00000000000008c0 <atoi>:

int
atoi(const char *s)
{
     8c0:	1141                	addi	sp,sp,-16
     8c2:	e422                	sd	s0,8(sp)
     8c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     8c6:	00054683          	lbu	a3,0(a0)
     8ca:	fd06879b          	addiw	a5,a3,-48
     8ce:	0ff7f793          	zext.b	a5,a5
     8d2:	4625                	li	a2,9
     8d4:	02f66863          	bltu	a2,a5,904 <atoi+0x44>
     8d8:	872a                	mv	a4,a0
  n = 0;
     8da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     8dc:	0705                	addi	a4,a4,1
     8de:	0025179b          	slliw	a5,a0,0x2
     8e2:	9fa9                	addw	a5,a5,a0
     8e4:	0017979b          	slliw	a5,a5,0x1
     8e8:	9fb5                	addw	a5,a5,a3
     8ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     8ee:	00074683          	lbu	a3,0(a4)
     8f2:	fd06879b          	addiw	a5,a3,-48
     8f6:	0ff7f793          	zext.b	a5,a5
     8fa:	fef671e3          	bgeu	a2,a5,8dc <atoi+0x1c>
  return n;
}
     8fe:	6422                	ld	s0,8(sp)
     900:	0141                	addi	sp,sp,16
     902:	8082                	ret
  n = 0;
     904:	4501                	li	a0,0
     906:	bfe5                	j	8fe <atoi+0x3e>

0000000000000908 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     908:	1141                	addi	sp,sp,-16
     90a:	e422                	sd	s0,8(sp)
     90c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     90e:	02b57463          	bgeu	a0,a1,936 <memmove+0x2e>
    while(n-- > 0)
     912:	00c05f63          	blez	a2,930 <memmove+0x28>
     916:	1602                	slli	a2,a2,0x20
     918:	9201                	srli	a2,a2,0x20
     91a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     91e:	872a                	mv	a4,a0
      *dst++ = *src++;
     920:	0585                	addi	a1,a1,1
     922:	0705                	addi	a4,a4,1
     924:	fff5c683          	lbu	a3,-1(a1)
     928:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     92c:	fef71ae3          	bne	a4,a5,920 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     930:	6422                	ld	s0,8(sp)
     932:	0141                	addi	sp,sp,16
     934:	8082                	ret
    dst += n;
     936:	00c50733          	add	a4,a0,a2
    src += n;
     93a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     93c:	fec05ae3          	blez	a2,930 <memmove+0x28>
     940:	fff6079b          	addiw	a5,a2,-1
     944:	1782                	slli	a5,a5,0x20
     946:	9381                	srli	a5,a5,0x20
     948:	fff7c793          	not	a5,a5
     94c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     94e:	15fd                	addi	a1,a1,-1
     950:	177d                	addi	a4,a4,-1
     952:	0005c683          	lbu	a3,0(a1)
     956:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     95a:	fee79ae3          	bne	a5,a4,94e <memmove+0x46>
     95e:	bfc9                	j	930 <memmove+0x28>

0000000000000960 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     960:	1141                	addi	sp,sp,-16
     962:	e422                	sd	s0,8(sp)
     964:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     966:	ca05                	beqz	a2,996 <memcmp+0x36>
     968:	fff6069b          	addiw	a3,a2,-1
     96c:	1682                	slli	a3,a3,0x20
     96e:	9281                	srli	a3,a3,0x20
     970:	0685                	addi	a3,a3,1
     972:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     974:	00054783          	lbu	a5,0(a0)
     978:	0005c703          	lbu	a4,0(a1)
     97c:	00e79863          	bne	a5,a4,98c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     980:	0505                	addi	a0,a0,1
    p2++;
     982:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     984:	fed518e3          	bne	a0,a3,974 <memcmp+0x14>
  }
  return 0;
     988:	4501                	li	a0,0
     98a:	a019                	j	990 <memcmp+0x30>
      return *p1 - *p2;
     98c:	40e7853b          	subw	a0,a5,a4
}
     990:	6422                	ld	s0,8(sp)
     992:	0141                	addi	sp,sp,16
     994:	8082                	ret
  return 0;
     996:	4501                	li	a0,0
     998:	bfe5                	j	990 <memcmp+0x30>

000000000000099a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     99a:	1141                	addi	sp,sp,-16
     99c:	e406                	sd	ra,8(sp)
     99e:	e022                	sd	s0,0(sp)
     9a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     9a2:	00000097          	auipc	ra,0x0
     9a6:	f66080e7          	jalr	-154(ra) # 908 <memmove>
}
     9aa:	60a2                	ld	ra,8(sp)
     9ac:	6402                	ld	s0,0(sp)
     9ae:	0141                	addi	sp,sp,16
     9b0:	8082                	ret

00000000000009b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     9b2:	4885                	li	a7,1
 ecall
     9b4:	00000073          	ecall
 ret
     9b8:	8082                	ret

00000000000009ba <exit>:
.global exit
exit:
 li a7, SYS_exit
     9ba:	4889                	li	a7,2
 ecall
     9bc:	00000073          	ecall
 ret
     9c0:	8082                	ret

00000000000009c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     9c2:	488d                	li	a7,3
 ecall
     9c4:	00000073          	ecall
 ret
     9c8:	8082                	ret

00000000000009ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     9ca:	4891                	li	a7,4
 ecall
     9cc:	00000073          	ecall
 ret
     9d0:	8082                	ret

00000000000009d2 <read>:
.global read
read:
 li a7, SYS_read
     9d2:	4895                	li	a7,5
 ecall
     9d4:	00000073          	ecall
 ret
     9d8:	8082                	ret

00000000000009da <write>:
.global write
write:
 li a7, SYS_write
     9da:	48c1                	li	a7,16
 ecall
     9dc:	00000073          	ecall
 ret
     9e0:	8082                	ret

00000000000009e2 <close>:
.global close
close:
 li a7, SYS_close
     9e2:	48d5                	li	a7,21
 ecall
     9e4:	00000073          	ecall
 ret
     9e8:	8082                	ret

00000000000009ea <kill>:
.global kill
kill:
 li a7, SYS_kill
     9ea:	4899                	li	a7,6
 ecall
     9ec:	00000073          	ecall
 ret
     9f0:	8082                	ret

00000000000009f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     9f2:	489d                	li	a7,7
 ecall
     9f4:	00000073          	ecall
 ret
     9f8:	8082                	ret

00000000000009fa <open>:
.global open
open:
 li a7, SYS_open
     9fa:	48bd                	li	a7,15
 ecall
     9fc:	00000073          	ecall
 ret
     a00:	8082                	ret

0000000000000a02 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     a02:	48c5                	li	a7,17
 ecall
     a04:	00000073          	ecall
 ret
     a08:	8082                	ret

0000000000000a0a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     a0a:	48c9                	li	a7,18
 ecall
     a0c:	00000073          	ecall
 ret
     a10:	8082                	ret

0000000000000a12 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     a12:	48a1                	li	a7,8
 ecall
     a14:	00000073          	ecall
 ret
     a18:	8082                	ret

0000000000000a1a <link>:
.global link
link:
 li a7, SYS_link
     a1a:	48cd                	li	a7,19
 ecall
     a1c:	00000073          	ecall
 ret
     a20:	8082                	ret

0000000000000a22 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     a22:	48d1                	li	a7,20
 ecall
     a24:	00000073          	ecall
 ret
     a28:	8082                	ret

0000000000000a2a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     a2a:	48a5                	li	a7,9
 ecall
     a2c:	00000073          	ecall
 ret
     a30:	8082                	ret

0000000000000a32 <dup>:
.global dup
dup:
 li a7, SYS_dup
     a32:	48a9                	li	a7,10
 ecall
     a34:	00000073          	ecall
 ret
     a38:	8082                	ret

0000000000000a3a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     a3a:	48ad                	li	a7,11
 ecall
     a3c:	00000073          	ecall
 ret
     a40:	8082                	ret

0000000000000a42 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     a42:	48b1                	li	a7,12
 ecall
     a44:	00000073          	ecall
 ret
     a48:	8082                	ret

0000000000000a4a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     a4a:	48b5                	li	a7,13
 ecall
     a4c:	00000073          	ecall
 ret
     a50:	8082                	ret

0000000000000a52 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     a52:	48b9                	li	a7,14
 ecall
     a54:	00000073          	ecall
 ret
     a58:	8082                	ret

0000000000000a5a <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     a5a:	48d9                	li	a7,22
 ecall
     a5c:	00000073          	ecall
 ret
     a60:	8082                	ret

0000000000000a62 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     a62:	48dd                	li	a7,23
 ecall
     a64:	00000073          	ecall
 ret
     a68:	8082                	ret

0000000000000a6a <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     a6a:	48e1                	li	a7,24
 ecall
     a6c:	00000073          	ecall
 ret
     a70:	8082                	ret

0000000000000a72 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     a72:	48e5                	li	a7,25
 ecall
     a74:	00000073          	ecall
 ret
     a78:	8082                	ret

0000000000000a7a <socket>:
.global socket
socket:
 li a7, SYS_socket
     a7a:	48e9                	li	a7,26
 ecall
     a7c:	00000073          	ecall
 ret
     a80:	8082                	ret

0000000000000a82 <bind>:
.global bind
bind:
 li a7, SYS_bind
     a82:	48ed                	li	a7,27
 ecall
     a84:	00000073          	ecall
 ret
     a88:	8082                	ret

0000000000000a8a <accept>:
.global accept
accept:
 li a7, SYS_accept
     a8a:	48f5                	li	a7,29
 ecall
     a8c:	00000073          	ecall
 ret
     a90:	8082                	ret

0000000000000a92 <listen>:
.global listen
listen:
 li a7, SYS_listen
     a92:	48f1                	li	a7,28
 ecall
     a94:	00000073          	ecall
 ret
     a98:	8082                	ret

0000000000000a9a <connect>:
.global connect
connect:
 li a7, SYS_connect
     a9a:	48f9                	li	a7,30
 ecall
     a9c:	00000073          	ecall
 ret
     aa0:	8082                	ret

0000000000000aa2 <send>:
.global send
send:
 li a7, SYS_send
     aa2:	48fd                	li	a7,31
 ecall
     aa4:	00000073          	ecall
 ret
     aa8:	8082                	ret

0000000000000aaa <recv>:
.global recv
recv:
 li a7, SYS_recv
     aaa:	02000893          	li	a7,32
 ecall
     aae:	00000073          	ecall
 ret
     ab2:	8082                	ret

0000000000000ab4 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     ab4:	02100893          	li	a7,33
 ecall
     ab8:	00000073          	ecall
 ret
     abc:	8082                	ret

0000000000000abe <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
     abe:	02200893          	li	a7,34
 ecall
     ac2:	00000073          	ecall
 ret
     ac6:	8082                	ret

0000000000000ac8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ac8:	1101                	addi	sp,sp,-32
     aca:	ec06                	sd	ra,24(sp)
     acc:	e822                	sd	s0,16(sp)
     ace:	1000                	addi	s0,sp,32
     ad0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ad4:	4605                	li	a2,1
     ad6:	fef40593          	addi	a1,s0,-17
     ada:	00000097          	auipc	ra,0x0
     ade:	f00080e7          	jalr	-256(ra) # 9da <write>
}
     ae2:	60e2                	ld	ra,24(sp)
     ae4:	6442                	ld	s0,16(sp)
     ae6:	6105                	addi	sp,sp,32
     ae8:	8082                	ret

0000000000000aea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     aea:	7139                	addi	sp,sp,-64
     aec:	fc06                	sd	ra,56(sp)
     aee:	f822                	sd	s0,48(sp)
     af0:	f426                	sd	s1,40(sp)
     af2:	0080                	addi	s0,sp,64
     af4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     af6:	c299                	beqz	a3,afc <printint+0x12>
     af8:	0805cb63          	bltz	a1,b8e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     afc:	2581                	sext.w	a1,a1
  neg = 0;
     afe:	4881                	li	a7,0
     b00:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     b04:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     b06:	2601                	sext.w	a2,a2
     b08:	00001517          	auipc	a0,0x1
     b0c:	b6050513          	addi	a0,a0,-1184 # 1668 <digits>
     b10:	883a                	mv	a6,a4
     b12:	2705                	addiw	a4,a4,1
     b14:	02c5f7bb          	remuw	a5,a1,a2
     b18:	1782                	slli	a5,a5,0x20
     b1a:	9381                	srli	a5,a5,0x20
     b1c:	97aa                	add	a5,a5,a0
     b1e:	0007c783          	lbu	a5,0(a5)
     b22:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     b26:	0005879b          	sext.w	a5,a1
     b2a:	02c5d5bb          	divuw	a1,a1,a2
     b2e:	0685                	addi	a3,a3,1
     b30:	fec7f0e3          	bgeu	a5,a2,b10 <printint+0x26>
  if(neg)
     b34:	00088c63          	beqz	a7,b4c <printint+0x62>
    buf[i++] = '-';
     b38:	fd070793          	addi	a5,a4,-48
     b3c:	00878733          	add	a4,a5,s0
     b40:	02d00793          	li	a5,45
     b44:	fef70823          	sb	a5,-16(a4)
     b48:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     b4c:	02e05c63          	blez	a4,b84 <printint+0x9a>
     b50:	f04a                	sd	s2,32(sp)
     b52:	ec4e                	sd	s3,24(sp)
     b54:	fc040793          	addi	a5,s0,-64
     b58:	00e78933          	add	s2,a5,a4
     b5c:	fff78993          	addi	s3,a5,-1
     b60:	99ba                	add	s3,s3,a4
     b62:	377d                	addiw	a4,a4,-1
     b64:	1702                	slli	a4,a4,0x20
     b66:	9301                	srli	a4,a4,0x20
     b68:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b6c:	fff94583          	lbu	a1,-1(s2)
     b70:	8526                	mv	a0,s1
     b72:	00000097          	auipc	ra,0x0
     b76:	f56080e7          	jalr	-170(ra) # ac8 <putc>
  while(--i >= 0)
     b7a:	197d                	addi	s2,s2,-1
     b7c:	ff3918e3          	bne	s2,s3,b6c <printint+0x82>
     b80:	7902                	ld	s2,32(sp)
     b82:	69e2                	ld	s3,24(sp)
}
     b84:	70e2                	ld	ra,56(sp)
     b86:	7442                	ld	s0,48(sp)
     b88:	74a2                	ld	s1,40(sp)
     b8a:	6121                	addi	sp,sp,64
     b8c:	8082                	ret
    x = -xx;
     b8e:	40b005bb          	negw	a1,a1
    neg = 1;
     b92:	4885                	li	a7,1
    x = -xx;
     b94:	b7b5                	j	b00 <printint+0x16>

0000000000000b96 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b96:	715d                	addi	sp,sp,-80
     b98:	e486                	sd	ra,72(sp)
     b9a:	e0a2                	sd	s0,64(sp)
     b9c:	f84a                	sd	s2,48(sp)
     b9e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ba0:	0005c903          	lbu	s2,0(a1)
     ba4:	1a090a63          	beqz	s2,d58 <vprintf+0x1c2>
     ba8:	fc26                	sd	s1,56(sp)
     baa:	f44e                	sd	s3,40(sp)
     bac:	f052                	sd	s4,32(sp)
     bae:	ec56                	sd	s5,24(sp)
     bb0:	e85a                	sd	s6,16(sp)
     bb2:	e45e                	sd	s7,8(sp)
     bb4:	8aaa                	mv	s5,a0
     bb6:	8bb2                	mv	s7,a2
     bb8:	00158493          	addi	s1,a1,1
  state = 0;
     bbc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     bbe:	02500a13          	li	s4,37
     bc2:	4b55                	li	s6,21
     bc4:	a839                	j	be2 <vprintf+0x4c>
        putc(fd, c);
     bc6:	85ca                	mv	a1,s2
     bc8:	8556                	mv	a0,s5
     bca:	00000097          	auipc	ra,0x0
     bce:	efe080e7          	jalr	-258(ra) # ac8 <putc>
     bd2:	a019                	j	bd8 <vprintf+0x42>
    } else if(state == '%'){
     bd4:	01498d63          	beq	s3,s4,bee <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     bd8:	0485                	addi	s1,s1,1
     bda:	fff4c903          	lbu	s2,-1(s1)
     bde:	16090763          	beqz	s2,d4c <vprintf+0x1b6>
    if(state == 0){
     be2:	fe0999e3          	bnez	s3,bd4 <vprintf+0x3e>
      if(c == '%'){
     be6:	ff4910e3          	bne	s2,s4,bc6 <vprintf+0x30>
        state = '%';
     bea:	89d2                	mv	s3,s4
     bec:	b7f5                	j	bd8 <vprintf+0x42>
      if(c == 'd'){
     bee:	13490463          	beq	s2,s4,d16 <vprintf+0x180>
     bf2:	f9d9079b          	addiw	a5,s2,-99
     bf6:	0ff7f793          	zext.b	a5,a5
     bfa:	12fb6763          	bltu	s6,a5,d28 <vprintf+0x192>
     bfe:	f9d9079b          	addiw	a5,s2,-99
     c02:	0ff7f713          	zext.b	a4,a5
     c06:	12eb6163          	bltu	s6,a4,d28 <vprintf+0x192>
     c0a:	00271793          	slli	a5,a4,0x2
     c0e:	00001717          	auipc	a4,0x1
     c12:	a0270713          	addi	a4,a4,-1534 # 1610 <ithread_join+0x4c2>
     c16:	97ba                	add	a5,a5,a4
     c18:	439c                	lw	a5,0(a5)
     c1a:	97ba                	add	a5,a5,a4
     c1c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     c1e:	008b8913          	addi	s2,s7,8
     c22:	4685                	li	a3,1
     c24:	4629                	li	a2,10
     c26:	000ba583          	lw	a1,0(s7)
     c2a:	8556                	mv	a0,s5
     c2c:	00000097          	auipc	ra,0x0
     c30:	ebe080e7          	jalr	-322(ra) # aea <printint>
     c34:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     c36:	4981                	li	s3,0
     c38:	b745                	j	bd8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c3a:	008b8913          	addi	s2,s7,8
     c3e:	4681                	li	a3,0
     c40:	4629                	li	a2,10
     c42:	000ba583          	lw	a1,0(s7)
     c46:	8556                	mv	a0,s5
     c48:	00000097          	auipc	ra,0x0
     c4c:	ea2080e7          	jalr	-350(ra) # aea <printint>
     c50:	8bca                	mv	s7,s2
      state = 0;
     c52:	4981                	li	s3,0
     c54:	b751                	j	bd8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     c56:	008b8913          	addi	s2,s7,8
     c5a:	4681                	li	a3,0
     c5c:	4641                	li	a2,16
     c5e:	000ba583          	lw	a1,0(s7)
     c62:	8556                	mv	a0,s5
     c64:	00000097          	auipc	ra,0x0
     c68:	e86080e7          	jalr	-378(ra) # aea <printint>
     c6c:	8bca                	mv	s7,s2
      state = 0;
     c6e:	4981                	li	s3,0
     c70:	b7a5                	j	bd8 <vprintf+0x42>
     c72:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     c74:	008b8c13          	addi	s8,s7,8
     c78:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     c7c:	03000593          	li	a1,48
     c80:	8556                	mv	a0,s5
     c82:	00000097          	auipc	ra,0x0
     c86:	e46080e7          	jalr	-442(ra) # ac8 <putc>
  putc(fd, 'x');
     c8a:	07800593          	li	a1,120
     c8e:	8556                	mv	a0,s5
     c90:	00000097          	auipc	ra,0x0
     c94:	e38080e7          	jalr	-456(ra) # ac8 <putc>
     c98:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     c9a:	00001b97          	auipc	s7,0x1
     c9e:	9ceb8b93          	addi	s7,s7,-1586 # 1668 <digits>
     ca2:	03c9d793          	srli	a5,s3,0x3c
     ca6:	97de                	add	a5,a5,s7
     ca8:	0007c583          	lbu	a1,0(a5)
     cac:	8556                	mv	a0,s5
     cae:	00000097          	auipc	ra,0x0
     cb2:	e1a080e7          	jalr	-486(ra) # ac8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     cb6:	0992                	slli	s3,s3,0x4
     cb8:	397d                	addiw	s2,s2,-1
     cba:	fe0914e3          	bnez	s2,ca2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     cbe:	8be2                	mv	s7,s8
      state = 0;
     cc0:	4981                	li	s3,0
     cc2:	6c02                	ld	s8,0(sp)
     cc4:	bf11                	j	bd8 <vprintf+0x42>
        s = va_arg(ap, char*);
     cc6:	008b8993          	addi	s3,s7,8
     cca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     cce:	02090163          	beqz	s2,cf0 <vprintf+0x15a>
        while(*s != 0){
     cd2:	00094583          	lbu	a1,0(s2)
     cd6:	c9a5                	beqz	a1,d46 <vprintf+0x1b0>
          putc(fd, *s);
     cd8:	8556                	mv	a0,s5
     cda:	00000097          	auipc	ra,0x0
     cde:	dee080e7          	jalr	-530(ra) # ac8 <putc>
          s++;
     ce2:	0905                	addi	s2,s2,1
        while(*s != 0){
     ce4:	00094583          	lbu	a1,0(s2)
     ce8:	f9e5                	bnez	a1,cd8 <vprintf+0x142>
        s = va_arg(ap, char*);
     cea:	8bce                	mv	s7,s3
      state = 0;
     cec:	4981                	li	s3,0
     cee:	b5ed                	j	bd8 <vprintf+0x42>
          s = "(null)";
     cf0:	00001917          	auipc	s2,0x1
     cf4:	8d090913          	addi	s2,s2,-1840 # 15c0 <ithread_join+0x472>
        while(*s != 0){
     cf8:	02800593          	li	a1,40
     cfc:	bff1                	j	cd8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     cfe:	008b8913          	addi	s2,s7,8
     d02:	000bc583          	lbu	a1,0(s7)
     d06:	8556                	mv	a0,s5
     d08:	00000097          	auipc	ra,0x0
     d0c:	dc0080e7          	jalr	-576(ra) # ac8 <putc>
     d10:	8bca                	mv	s7,s2
      state = 0;
     d12:	4981                	li	s3,0
     d14:	b5d1                	j	bd8 <vprintf+0x42>
        putc(fd, c);
     d16:	02500593          	li	a1,37
     d1a:	8556                	mv	a0,s5
     d1c:	00000097          	auipc	ra,0x0
     d20:	dac080e7          	jalr	-596(ra) # ac8 <putc>
      state = 0;
     d24:	4981                	li	s3,0
     d26:	bd4d                	j	bd8 <vprintf+0x42>
        putc(fd, '%');
     d28:	02500593          	li	a1,37
     d2c:	8556                	mv	a0,s5
     d2e:	00000097          	auipc	ra,0x0
     d32:	d9a080e7          	jalr	-614(ra) # ac8 <putc>
        putc(fd, c);
     d36:	85ca                	mv	a1,s2
     d38:	8556                	mv	a0,s5
     d3a:	00000097          	auipc	ra,0x0
     d3e:	d8e080e7          	jalr	-626(ra) # ac8 <putc>
      state = 0;
     d42:	4981                	li	s3,0
     d44:	bd51                	j	bd8 <vprintf+0x42>
        s = va_arg(ap, char*);
     d46:	8bce                	mv	s7,s3
      state = 0;
     d48:	4981                	li	s3,0
     d4a:	b579                	j	bd8 <vprintf+0x42>
     d4c:	74e2                	ld	s1,56(sp)
     d4e:	79a2                	ld	s3,40(sp)
     d50:	7a02                	ld	s4,32(sp)
     d52:	6ae2                	ld	s5,24(sp)
     d54:	6b42                	ld	s6,16(sp)
     d56:	6ba2                	ld	s7,8(sp)
    }
  }
}
     d58:	60a6                	ld	ra,72(sp)
     d5a:	6406                	ld	s0,64(sp)
     d5c:	7942                	ld	s2,48(sp)
     d5e:	6161                	addi	sp,sp,80
     d60:	8082                	ret

0000000000000d62 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d62:	715d                	addi	sp,sp,-80
     d64:	ec06                	sd	ra,24(sp)
     d66:	e822                	sd	s0,16(sp)
     d68:	1000                	addi	s0,sp,32
     d6a:	e010                	sd	a2,0(s0)
     d6c:	e414                	sd	a3,8(s0)
     d6e:	e818                	sd	a4,16(s0)
     d70:	ec1c                	sd	a5,24(s0)
     d72:	03043023          	sd	a6,32(s0)
     d76:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d7a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d7e:	8622                	mv	a2,s0
     d80:	00000097          	auipc	ra,0x0
     d84:	e16080e7          	jalr	-490(ra) # b96 <vprintf>
}
     d88:	60e2                	ld	ra,24(sp)
     d8a:	6442                	ld	s0,16(sp)
     d8c:	6161                	addi	sp,sp,80
     d8e:	8082                	ret

0000000000000d90 <printf>:

void
printf(const char *fmt, ...)
{
     d90:	711d                	addi	sp,sp,-96
     d92:	ec06                	sd	ra,24(sp)
     d94:	e822                	sd	s0,16(sp)
     d96:	1000                	addi	s0,sp,32
     d98:	e40c                	sd	a1,8(s0)
     d9a:	e810                	sd	a2,16(s0)
     d9c:	ec14                	sd	a3,24(s0)
     d9e:	f018                	sd	a4,32(s0)
     da0:	f41c                	sd	a5,40(s0)
     da2:	03043823          	sd	a6,48(s0)
     da6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     daa:	00840613          	addi	a2,s0,8
     dae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     db2:	85aa                	mv	a1,a0
     db4:	4505                	li	a0,1
     db6:	00000097          	auipc	ra,0x0
     dba:	de0080e7          	jalr	-544(ra) # b96 <vprintf>
}
     dbe:	60e2                	ld	ra,24(sp)
     dc0:	6442                	ld	s0,16(sp)
     dc2:	6125                	addi	sp,sp,96
     dc4:	8082                	ret

0000000000000dc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     dc6:	1141                	addi	sp,sp,-16
     dc8:	e422                	sd	s0,8(sp)
     dca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dcc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dd0:	00001797          	auipc	a5,0x1
     dd4:	2487b783          	ld	a5,584(a5) # 2018 <freep>
     dd8:	a02d                	j	e02 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     dda:	4618                	lw	a4,8(a2)
     ddc:	9f2d                	addw	a4,a4,a1
     dde:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     de2:	6398                	ld	a4,0(a5)
     de4:	6310                	ld	a2,0(a4)
     de6:	a83d                	j	e24 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     de8:	ff852703          	lw	a4,-8(a0)
     dec:	9f31                	addw	a4,a4,a2
     dee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     df0:	ff053683          	ld	a3,-16(a0)
     df4:	a091                	j	e38 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     df6:	6398                	ld	a4,0(a5)
     df8:	00e7e463          	bltu	a5,a4,e00 <free+0x3a>
     dfc:	00e6ea63          	bltu	a3,a4,e10 <free+0x4a>
{
     e00:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e02:	fed7fae3          	bgeu	a5,a3,df6 <free+0x30>
     e06:	6398                	ld	a4,0(a5)
     e08:	00e6e463          	bltu	a3,a4,e10 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e0c:	fee7eae3          	bltu	a5,a4,e00 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     e10:	ff852583          	lw	a1,-8(a0)
     e14:	6390                	ld	a2,0(a5)
     e16:	02059813          	slli	a6,a1,0x20
     e1a:	01c85713          	srli	a4,a6,0x1c
     e1e:	9736                	add	a4,a4,a3
     e20:	fae60de3          	beq	a2,a4,dda <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     e24:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     e28:	4790                	lw	a2,8(a5)
     e2a:	02061593          	slli	a1,a2,0x20
     e2e:	01c5d713          	srli	a4,a1,0x1c
     e32:	973e                	add	a4,a4,a5
     e34:	fae68ae3          	beq	a3,a4,de8 <free+0x22>
    p->s.ptr = bp->s.ptr;
     e38:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     e3a:	00001717          	auipc	a4,0x1
     e3e:	1cf73f23          	sd	a5,478(a4) # 2018 <freep>
}
     e42:	6422                	ld	s0,8(sp)
     e44:	0141                	addi	sp,sp,16
     e46:	8082                	ret

0000000000000e48 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e48:	7139                	addi	sp,sp,-64
     e4a:	fc06                	sd	ra,56(sp)
     e4c:	f822                	sd	s0,48(sp)
     e4e:	f426                	sd	s1,40(sp)
     e50:	ec4e                	sd	s3,24(sp)
     e52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e54:	02051493          	slli	s1,a0,0x20
     e58:	9081                	srli	s1,s1,0x20
     e5a:	04bd                	addi	s1,s1,15
     e5c:	8091                	srli	s1,s1,0x4
     e5e:	0014899b          	addiw	s3,s1,1
     e62:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     e64:	00001517          	auipc	a0,0x1
     e68:	1b453503          	ld	a0,436(a0) # 2018 <freep>
     e6c:	c915                	beqz	a0,ea0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e70:	4798                	lw	a4,8(a5)
     e72:	08977e63          	bgeu	a4,s1,f0e <malloc+0xc6>
     e76:	f04a                	sd	s2,32(sp)
     e78:	e852                	sd	s4,16(sp)
     e7a:	e456                	sd	s5,8(sp)
     e7c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     e7e:	8a4e                	mv	s4,s3
     e80:	0009871b          	sext.w	a4,s3
     e84:	6685                	lui	a3,0x1
     e86:	00d77363          	bgeu	a4,a3,e8c <malloc+0x44>
     e8a:	6a05                	lui	s4,0x1
     e8c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     e90:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     e94:	00001917          	auipc	s2,0x1
     e98:	18490913          	addi	s2,s2,388 # 2018 <freep>
  if(p == (char*)-1)
     e9c:	5afd                	li	s5,-1
     e9e:	a091                	j	ee2 <malloc+0x9a>
     ea0:	f04a                	sd	s2,32(sp)
     ea2:	e852                	sd	s4,16(sp)
     ea4:	e456                	sd	s5,8(sp)
     ea6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     ea8:	00001797          	auipc	a5,0x1
     eac:	18878793          	addi	a5,a5,392 # 2030 <base>
     eb0:	00001717          	auipc	a4,0x1
     eb4:	16f73423          	sd	a5,360(a4) # 2018 <freep>
     eb8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     eba:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     ebe:	b7c1                	j	e7e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
     ec0:	6398                	ld	a4,0(a5)
     ec2:	e118                	sd	a4,0(a0)
     ec4:	a08d                	j	f26 <malloc+0xde>
  hp->s.size = nu;
     ec6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     eca:	0541                	addi	a0,a0,16
     ecc:	00000097          	auipc	ra,0x0
     ed0:	efa080e7          	jalr	-262(ra) # dc6 <free>
  return freep;
     ed4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     ed8:	c13d                	beqz	a0,f3e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     eda:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     edc:	4798                	lw	a4,8(a5)
     ede:	02977463          	bgeu	a4,s1,f06 <malloc+0xbe>
    if(p == freep)
     ee2:	00093703          	ld	a4,0(s2)
     ee6:	853e                	mv	a0,a5
     ee8:	fef719e3          	bne	a4,a5,eda <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
     eec:	8552                	mv	a0,s4
     eee:	00000097          	auipc	ra,0x0
     ef2:	b54080e7          	jalr	-1196(ra) # a42 <sbrk>
  if(p == (char*)-1)
     ef6:	fd5518e3          	bne	a0,s5,ec6 <malloc+0x7e>
        return 0;
     efa:	4501                	li	a0,0
     efc:	7902                	ld	s2,32(sp)
     efe:	6a42                	ld	s4,16(sp)
     f00:	6aa2                	ld	s5,8(sp)
     f02:	6b02                	ld	s6,0(sp)
     f04:	a03d                	j	f32 <malloc+0xea>
     f06:	7902                	ld	s2,32(sp)
     f08:	6a42                	ld	s4,16(sp)
     f0a:	6aa2                	ld	s5,8(sp)
     f0c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     f0e:	fae489e3          	beq	s1,a4,ec0 <malloc+0x78>
        p->s.size -= nunits;
     f12:	4137073b          	subw	a4,a4,s3
     f16:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f18:	02071693          	slli	a3,a4,0x20
     f1c:	01c6d713          	srli	a4,a3,0x1c
     f20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     f22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     f26:	00001717          	auipc	a4,0x1
     f2a:	0ea73923          	sd	a0,242(a4) # 2018 <freep>
      return (void*)(p + 1);
     f2e:	01078513          	addi	a0,a5,16
  }
}
     f32:	70e2                	ld	ra,56(sp)
     f34:	7442                	ld	s0,48(sp)
     f36:	74a2                	ld	s1,40(sp)
     f38:	69e2                	ld	s3,24(sp)
     f3a:	6121                	addi	sp,sp,64
     f3c:	8082                	ret
     f3e:	7902                	ld	s2,32(sp)
     f40:	6a42                	ld	s4,16(sp)
     f42:	6aa2                	ld	s5,8(sp)
     f44:	6b02                	ld	s6,0(sp)
     f46:	b7f5                	j	f32 <malloc+0xea>

0000000000000f48 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     f48:	1141                	addi	sp,sp,-16
     f4a:	e406                	sd	ra,8(sp)
     f4c:	e022                	sd	s0,0(sp)
     f4e:	0800                	addi	s0,sp,16
  thread_exit(status);
     f50:	2501                	sext.w	a0,a0
     f52:	00000097          	auipc	ra,0x0
     f56:	b20080e7          	jalr	-1248(ra) # a72 <thread_exit>
}
     f5a:	60a2                	ld	ra,8(sp)
     f5c:	6402                	ld	s0,0(sp)
     f5e:	0141                	addi	sp,sp,16
     f60:	8082                	ret

0000000000000f62 <free_stacks>:
int free_stacks() {
     f62:	7179                	addi	sp,sp,-48
     f64:	f406                	sd	ra,40(sp)
     f66:	f022                	sd	s0,32(sp)
     f68:	ec26                	sd	s1,24(sp)
     f6a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f6c:	00001797          	auipc	a5,0x1
     f70:	0bc7a783          	lw	a5,188(a5) # 2028 <num_threads>
     f74:	04f05063          	blez	a5,fb4 <free_stacks+0x52>
     f78:	e84a                	sd	s2,16(sp)
     f7a:	e44e                	sd	s3,8(sp)
     f7c:	4481                	li	s1,0
    free(stacks[i]);
     f7e:	00001997          	auipc	s3,0x1
     f82:	0a298993          	addi	s3,s3,162 # 2020 <stacks>
  for (int i = 0; i < num_threads; i++) {
     f86:	00001917          	auipc	s2,0x1
     f8a:	0a290913          	addi	s2,s2,162 # 2028 <num_threads>
    free(stacks[i]);
     f8e:	0009b783          	ld	a5,0(s3)
     f92:	00349713          	slli	a4,s1,0x3
     f96:	97ba                	add	a5,a5,a4
     f98:	6388                	ld	a0,0(a5)
     f9a:	00000097          	auipc	ra,0x0
     f9e:	e2c080e7          	jalr	-468(ra) # dc6 <free>
  for (int i = 0; i < num_threads; i++) {
     fa2:	0485                	addi	s1,s1,1
     fa4:	00092703          	lw	a4,0(s2)
     fa8:	0004879b          	sext.w	a5,s1
     fac:	fee7c1e3          	blt	a5,a4,f8e <free_stacks+0x2c>
     fb0:	6942                	ld	s2,16(sp)
     fb2:	69a2                	ld	s3,8(sp)
  free(stacks);
     fb4:	00001497          	auipc	s1,0x1
     fb8:	06c48493          	addi	s1,s1,108 # 2020 <stacks>
     fbc:	6088                	ld	a0,0(s1)
     fbe:	00000097          	auipc	ra,0x0
     fc2:	e08080e7          	jalr	-504(ra) # dc6 <free>
  stacks = 0;
     fc6:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     fca:	00001797          	auipc	a5,0x1
     fce:	0407af23          	sw	zero,94(a5) # 2028 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     fd2:	47a1                	li	a5,8
     fd4:	00001717          	auipc	a4,0x1
     fd8:	02f72a23          	sw	a5,52(a4) # 2008 <max_stacks>
  threads_done = 0;
     fdc:	00001797          	auipc	a5,0x1
     fe0:	0407a823          	sw	zero,80(a5) # 202c <threads_done>
}
     fe4:	4501                	li	a0,0
     fe6:	70a2                	ld	ra,40(sp)
     fe8:	7402                	ld	s0,32(sp)
     fea:	64e2                	ld	s1,24(sp)
     fec:	6145                	addi	sp,sp,48
     fee:	8082                	ret

0000000000000ff0 <expand_num_threads>:
int expand_num_threads() {
     ff0:	1101                	addi	sp,sp,-32
     ff2:	ec06                	sd	ra,24(sp)
     ff4:	e822                	sd	s0,16(sp)
     ff6:	e426                	sd	s1,8(sp)
     ff8:	e04a                	sd	s2,0(sp)
     ffa:	1000                	addi	s0,sp,32
  max_stacks *= 2;
     ffc:	00001797          	auipc	a5,0x1
    1000:	00c78793          	addi	a5,a5,12 # 2008 <max_stacks>
    1004:	4388                	lw	a0,0(a5)
    1006:	0015151b          	slliw	a0,a0,0x1
    100a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    100c:	0035151b          	slliw	a0,a0,0x3
    1010:	00000097          	auipc	ra,0x0
    1014:	e38080e7          	jalr	-456(ra) # e48 <malloc>
    1018:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    101a:	00001617          	auipc	a2,0x1
    101e:	00e62603          	lw	a2,14(a2) # 2028 <num_threads>
    1022:	00001497          	auipc	s1,0x1
    1026:	ffe48493          	addi	s1,s1,-2 # 2020 <stacks>
    102a:	0036161b          	slliw	a2,a2,0x3
    102e:	608c                	ld	a1,0(s1)
    1030:	00000097          	auipc	ra,0x0
    1034:	8d8080e7          	jalr	-1832(ra) # 908 <memmove>
  free(stacks);
    1038:	6088                	ld	a0,0(s1)
    103a:	00000097          	auipc	ra,0x0
    103e:	d8c080e7          	jalr	-628(ra) # dc6 <free>
  stacks = new_stacks;
    1042:	0124b023          	sd	s2,0(s1)
}
    1046:	4501                	li	a0,0
    1048:	60e2                	ld	ra,24(sp)
    104a:	6442                	ld	s0,16(sp)
    104c:	64a2                	ld	s1,8(sp)
    104e:	6902                	ld	s2,0(sp)
    1050:	6105                	addi	sp,sp,32
    1052:	8082                	ret

0000000000001054 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1054:	7179                	addi	sp,sp,-48
    1056:	f406                	sd	ra,40(sp)
    1058:	f022                	sd	s0,32(sp)
    105a:	e84a                	sd	s2,16(sp)
    105c:	e44e                	sd	s3,8(sp)
    105e:	1800                	addi	s0,sp,48
    1060:	892a                	mv	s2,a0
    1062:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1064:	00001797          	auipc	a5,0x1
    1068:	fbc7b783          	ld	a5,-68(a5) # 2020 <stacks>
    106c:	c3d9                	beqz	a5,10f2 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    106e:	00001797          	auipc	a5,0x1
    1072:	f9a7a783          	lw	a5,-102(a5) # 2008 <max_stacks>
    1076:	00001717          	auipc	a4,0x1
    107a:	fb272703          	lw	a4,-78(a4) # 2028 <num_threads>
    107e:	0af71363          	bne	a4,a5,1124 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    1082:	04000713          	li	a4,64
    1086:	08e78563          	beq	a5,a4,1110 <ithread_create+0xbc>
    108a:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    108c:	00000097          	auipc	ra,0x0
    1090:	f64080e7          	jalr	-156(ra) # ff0 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    1094:	6505                	lui	a0,0x1
    1096:	00000097          	auipc	ra,0x0
    109a:	db2080e7          	jalr	-590(ra) # e48 <malloc>
    109e:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    10a0:	00001717          	auipc	a4,0x1
    10a4:	f8872703          	lw	a4,-120(a4) # 2028 <num_threads>
    10a8:	070e                	slli	a4,a4,0x3
    10aa:	00001797          	auipc	a5,0x1
    10ae:	f767b783          	ld	a5,-138(a5) # 2020 <stacks>
    10b2:	97ba                	add	a5,a5,a4
    10b4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    10b6:	00000697          	auipc	a3,0x0
    10ba:	e9268693          	addi	a3,a3,-366 # f48 <ithread_exit>
    10be:	862a                	mv	a2,a0
    10c0:	85ce                	mv	a1,s3
    10c2:	854a                	mv	a0,s2
    10c4:	00000097          	auipc	ra,0x0
    10c8:	99e080e7          	jalr	-1634(ra) # a62 <create_thread>
    10cc:	892a                	mv	s2,a0
  if (res != -1) {
    10ce:	57fd                	li	a5,-1
    10d0:	04f50c63          	beq	a0,a5,1128 <ithread_create+0xd4>
    num_threads++;
    10d4:	00001717          	auipc	a4,0x1
    10d8:	f5470713          	addi	a4,a4,-172 # 2028 <num_threads>
    10dc:	431c                	lw	a5,0(a4)
    10de:	2785                	addiw	a5,a5,1
    10e0:	c31c                	sw	a5,0(a4)
    10e2:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    10e4:	854a                	mv	a0,s2
    10e6:	70a2                	ld	ra,40(sp)
    10e8:	7402                	ld	s0,32(sp)
    10ea:	6942                	ld	s2,16(sp)
    10ec:	69a2                	ld	s3,8(sp)
    10ee:	6145                	addi	sp,sp,48
    10f0:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    10f2:	00001517          	auipc	a0,0x1
    10f6:	f1652503          	lw	a0,-234(a0) # 2008 <max_stacks>
    10fa:	0035151b          	slliw	a0,a0,0x3
    10fe:	00000097          	auipc	ra,0x0
    1102:	d4a080e7          	jalr	-694(ra) # e48 <malloc>
    1106:	00001797          	auipc	a5,0x1
    110a:	f0a7bd23          	sd	a0,-230(a5) # 2020 <stacks>
    110e:	b785                	j	106e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    1110:	00000517          	auipc	a0,0x0
    1114:	4b850513          	addi	a0,a0,1208 # 15c8 <ithread_join+0x47a>
    1118:	00000097          	auipc	ra,0x0
    111c:	c78080e7          	jalr	-904(ra) # d90 <printf>
      return -1;
    1120:	597d                	li	s2,-1
    1122:	b7c9                	j	10e4 <ithread_create+0x90>
    1124:	ec26                	sd	s1,24(sp)
    1126:	b7bd                	j	1094 <ithread_create+0x40>
    free(stack_ptr);
    1128:	8526                	mv	a0,s1
    112a:	00000097          	auipc	ra,0x0
    112e:	c9c080e7          	jalr	-868(ra) # dc6 <free>
    stacks[num_threads] = 0;
    1132:	00001717          	auipc	a4,0x1
    1136:	ef672703          	lw	a4,-266(a4) # 2028 <num_threads>
    113a:	070e                	slli	a4,a4,0x3
    113c:	00001797          	auipc	a5,0x1
    1140:	ee47b783          	ld	a5,-284(a5) # 2020 <stacks>
    1144:	97ba                	add	a5,a5,a4
    1146:	0007b023          	sd	zero,0(a5)
    114a:	64e2                	ld	s1,24(sp)
    114c:	bf61                	j	10e4 <ithread_create+0x90>

000000000000114e <ithread_join>:

int ithread_join(int thread_id) {
    114e:	1101                	addi	sp,sp,-32
    1150:	ec06                	sd	ra,24(sp)
    1152:	e822                	sd	s0,16(sp)
    1154:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1156:	ff040793          	addi	a5,s0,-16
    115a:	ffc7859b          	addiw	a1,a5,-4
    115e:	00000097          	auipc	ra,0x0
    1162:	90c080e7          	jalr	-1780(ra) # a6a <join_thread>
  threads_done++;
    1166:	00001717          	auipc	a4,0x1
    116a:	ec670713          	addi	a4,a4,-314 # 202c <threads_done>
    116e:	431c                	lw	a5,0(a4)
    1170:	2785                	addiw	a5,a5,1
    1172:	0007869b          	sext.w	a3,a5
    1176:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1178:	00001797          	auipc	a5,0x1
    117c:	eb07a783          	lw	a5,-336(a5) # 2028 <num_threads>
    1180:	00d78863          	beq	a5,a3,1190 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
    1184:	fec42503          	lw	a0,-20(s0)
    1188:	60e2                	ld	ra,24(sp)
    118a:	6442                	ld	s0,16(sp)
    118c:	6105                	addi	sp,sp,32
    118e:	8082                	ret
    free_stacks();
    1190:	00000097          	auipc	ra,0x0
    1194:	dd2080e7          	jalr	-558(ra) # f62 <free_stacks>
    1198:	b7f5                	j	1184 <ithread_join+0x36>
