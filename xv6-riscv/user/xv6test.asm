
user/_xv6test:     file format elf64-littleriscv


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
    shared_counter++;
      16:	0007869b          	sext.w	a3,a5
  for (i = 0; i < 50; i++) {
      1a:	2785                	addiw	a5,a5,1
      1c:	fee79de3          	bne	a5,a4,16 <thread_func_shared+0x16>
      20:	00002797          	auipc	a5,0x2
      24:	fed7a823          	sw	a3,-16(a5) # 2010 <shared_counter>
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
      48:	a04080e7          	jalr	-1532(ra) # a48 <sleep>
  printf("Test 6 FAILED: exit_all failed\n");
      4c:	00001517          	auipc	a0,0x1
      50:	0f450513          	addi	a0,a0,244 # 1140 <ithread_join+0x52>
      54:	00001097          	auipc	ra,0x1
      58:	cfe080e7          	jalr	-770(ra) # d52 <printf>
}
      5c:	4501                	li	a0,0
      5e:	60a2                	ld	ra,8(sp)
      60:	6402                	ld	s0,0(sp)
      62:	0141                	addi	sp,sp,16
      64:	8082                	ret
    sleep(5);
      66:	4515                	li	a0,5
      68:	00001097          	auipc	ra,0x1
      6c:	9e0080e7          	jalr	-1568(ra) # a48 <sleep>
    exit(0);
      70:	4501                	li	a0,0
      72:	00001097          	auipc	ra,0x1
      76:	946080e7          	jalr	-1722(ra) # 9b8 <exit>

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
      8c:	9c0080e7          	jalr	-1600(ra) # a48 <sleep>
  int val = p[0]; // should be 42 before deallocation
      90:	00002497          	auipc	s1,0x2
      94:	f7048493          	addi	s1,s1,-144 # 2000 <p>
      98:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
      9a:	438c                	lw	a1,0(a5)
      9c:	00001517          	auipc	a0,0x1
      a0:	0c450513          	addi	a0,a0,196 # 1160 <ithread_join+0x72>
      a4:	00001097          	auipc	ra,0x1
      a8:	cae080e7          	jalr	-850(ra) # d52 <printf>
  sleep(40); // wait for deallocation
      ac:	02800513          	li	a0,40
      b0:	00001097          	auipc	ra,0x1
      b4:	998080e7          	jalr	-1640(ra) # a48 <sleep>
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
      b8:	6098                	ld	a4,0(s1)
      ba:	37ab77b7          	lui	a5,0x37ab7
      be:	078a                	slli	a5,a5,0x2
      c0:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4ebf>
      c4:	04f70763          	beq	a4,a5,112 <prop_mem_dealloc2+0x98>
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
      c8:	00001517          	auipc	a0,0x1
      cc:	0c850513          	addi	a0,a0,200 # 1190 <ithread_join+0xa2>
      d0:	00001097          	auipc	ra,0x1
      d4:	c82080e7          	jalr	-894(ra) # d52 <printf>
  fail = p[0]; // this should ideally trap or fail
      d8:	00002797          	auipc	a5,0x2
      dc:	f287b783          	ld	a5,-216(a5) # 2000 <p>
      e0:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e2:	85a6                	mv	a1,s1
      e4:	00001517          	auipc	a0,0x1
      e8:	0dc50513          	addi	a0,a0,220 # 11c0 <ithread_join+0xd2>
      ec:	00001097          	auipc	ra,0x1
      f0:	c66080e7          	jalr	-922(ra) # d52 <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f4:	85a6                	mv	a1,s1
      f6:	00001517          	auipc	a0,0x1
      fa:	0e250513          	addi	a0,a0,226 # 11d8 <ithread_join+0xea>
      fe:	00001097          	auipc	ra,0x1
     102:	c54080e7          	jalr	-940(ra) # d52 <printf>
}
     106:	4501                	li	a0,0
     108:	60e2                	ld	ra,24(sp)
     10a:	6442                	ld	s0,16(sp)
     10c:	64a2                	ld	s1,8(sp)
     10e:	6105                	addi	sp,sp,32
     110:	8082                	ret
    printf("FAIL: p is invalid\n");
     112:	00001517          	auipc	a0,0x1
     116:	06650513          	addi	a0,a0,102 # 1178 <ithread_join+0x8a>
     11a:	00001097          	auipc	ra,0x1
     11e:	c38080e7          	jalr	-968(ra) # d52 <printf>
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
     134:	918080e7          	jalr	-1768(ra) # a48 <sleep>
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
     162:	0ca50513          	addi	a0,a0,202 # 1228 <ithread_join+0x13a>
     166:	00001097          	auipc	ra,0x1
     16a:	bec080e7          	jalr	-1044(ra) # d52 <printf>
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
     17c:	09050513          	addi	a0,a0,144 # 1208 <ithread_join+0x11a>
     180:	00001097          	auipc	ra,0x1
     184:	bd2080e7          	jalr	-1070(ra) # d52 <printf>
    return 0;
     188:	b7dd                	j	16e <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	09650513          	addi	a0,a0,150 # 1220 <ithread_join+0x132>
     192:	00001097          	auipc	ra,0x1
     196:	bc0080e7          	jalr	-1088(ra) # d52 <printf>
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
     1ac:	898080e7          	jalr	-1896(ra) # a40 <sbrk>
     1b0:	00002497          	auipc	s1,0x2
     1b4:	e5048493          	addi	s1,s1,-432 # 2000 <p>
     1b8:	e088                	sd	a0,0(s1)
  p[0] = 42;
     1ba:	02a00793          	li	a5,42
     1be:	c11c                	sw	a5,0(a0)
  sleep(80);              // allow thread 2 to read
     1c0:	05000513          	li	a0,80
     1c4:	00001097          	auipc	ra,0x1
     1c8:	884080e7          	jalr	-1916(ra) # a48 <sleep>
  p = (int *)sbrk(-4096);            // deallocate
     1cc:	757d                	lui	a0,0xfffff
     1ce:	00001097          	auipc	ra,0x1
     1d2:	872080e7          	jalr	-1934(ra) # a40 <sbrk>
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
     1f2:	852080e7          	jalr	-1966(ra) # a40 <sbrk>
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
     222:	00052903          	lw	s2,0(a0) # 1000 <ithread_create+0x6>
  printf("Thread %d is running\n", val);
     226:	85ca                	mv	a1,s2
     228:	00001517          	auipc	a0,0x1
     22c:	03050513          	addi	a0,a0,48 # 1258 <ithread_join+0x16a>
     230:	00001097          	auipc	ra,0x1
     234:	b22080e7          	jalr	-1246(ra) # d52 <printf>
  free(arg);
     238:	8526                	mv	a0,s1
     23a:	00001097          	auipc	ra,0x1
     23e:	b4e080e7          	jalr	-1202(ra) # d88 <free>
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
     260:	c94080e7          	jalr	-876(ra) # ef0 <ithread_exit>
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
     274:	e426                	sd	s1,8(sp)
     276:	1000                	addi	s0,sp,32
  printf("Test 1: Thread creation\n");
     278:	00001517          	auipc	a0,0x1
     27c:	ff850513          	addi	a0,a0,-8 # 1270 <ithread_join+0x182>
     280:	00001097          	auipc	ra,0x1
     284:	ad2080e7          	jalr	-1326(ra) # d52 <printf>
  int *arg = malloc(sizeof(int));
     288:	4511                	li	a0,4
     28a:	00001097          	auipc	ra,0x1
     28e:	b80080e7          	jalr	-1152(ra) # e0a <malloc>
     292:	85aa                	mv	a1,a0
  *arg = 0;
     294:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     298:	00000517          	auipc	a0,0x0
     29c:	f7c50513          	addi	a0,a0,-132 # 214 <thread_func_basic>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	d5a080e7          	jalr	-678(ra) # ffa <ithread_create>
  if (tid < 0) {
     2a8:	02054663          	bltz	a0,2d4 <test_thread_create+0x66>
     2ac:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2ae:	85aa                	mv	a1,a0
     2b0:	00001517          	auipc	a0,0x1
     2b4:	00850513          	addi	a0,a0,8 # 12b8 <ithread_join+0x1ca>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	a9a080e7          	jalr	-1382(ra) # d52 <printf>
    ithread_join(tid);
     2c0:	8526                	mv	a0,s1
     2c2:	00001097          	auipc	ra,0x1
     2c6:	e2c080e7          	jalr	-468(ra) # 10ee <ithread_join>
}
     2ca:	60e2                	ld	ra,24(sp)
     2cc:	6442                	ld	s0,16(sp)
     2ce:	64a2                	ld	s1,8(sp)
     2d0:	6105                	addi	sp,sp,32
     2d2:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d4:	00001517          	auipc	a0,0x1
     2d8:	fbc50513          	addi	a0,a0,-68 # 1290 <ithread_join+0x1a2>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	a76080e7          	jalr	-1418(ra) # d52 <printf>
     2e4:	b7dd                	j	2ca <test_thread_create+0x5c>

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
     2f6:	ff650513          	addi	a0,a0,-10 # 12e8 <ithread_join+0x1fa>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	a58080e7          	jalr	-1448(ra) # d52 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     302:	4581                	li	a1,0
     304:	00000517          	auipc	a0,0x0
     308:	e9850513          	addi	a0,a0,-360 # 19c <prop_mem_dealloc1>
     30c:	00001097          	auipc	ra,0x1
     310:	cee080e7          	jalr	-786(ra) # ffa <ithread_create>
     314:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     316:	4581                	li	a1,0
     318:	00000517          	auipc	a0,0x0
     31c:	d6250513          	addi	a0,a0,-670 # 7a <prop_mem_dealloc2>
     320:	00001097          	auipc	ra,0x1
     324:	cda080e7          	jalr	-806(ra) # ffa <ithread_create>
     328:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32a:	854a                	mv	a0,s2
     32c:	00001097          	auipc	ra,0x1
     330:	dc2080e7          	jalr	-574(ra) # 10ee <ithread_join>
  ithread_join(tid2);
     334:	8526                	mv	a0,s1
     336:	00001097          	auipc	ra,0x1
     33a:	db8080e7          	jalr	-584(ra) # 10ee <ithread_join>
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
     35a:	faa50513          	addi	a0,a0,-86 # 1300 <ithread_join+0x212>
     35e:	00001097          	auipc	ra,0x1
     362:	9f4080e7          	jalr	-1548(ra) # d52 <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     366:	4581                	li	a1,0
     368:	00000517          	auipc	a0,0x0
     36c:	e7c50513          	addi	a0,a0,-388 # 1e4 <prop_mem_alloc1>
     370:	00001097          	auipc	ra,0x1
     374:	c8a080e7          	jalr	-886(ra) # ffa <ithread_create>
     378:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37a:	4581                	li	a1,0
     37c:	00000517          	auipc	a0,0x0
     380:	da850513          	addi	a0,a0,-600 # 124 <prop_mem_alloc2>
     384:	00001097          	auipc	ra,0x1
     388:	c76080e7          	jalr	-906(ra) # ffa <ithread_create>
     38c:	84aa                	mv	s1,a0
  ithread_join(tid1);
     38e:	854a                	mv	a0,s2
     390:	00001097          	auipc	ra,0x1
     394:	d5e080e7          	jalr	-674(ra) # 10ee <ithread_join>
  ithread_join(tid2);
     398:	8526                	mv	a0,s1
     39a:	00001097          	auipc	ra,0x1
     39e:	d54080e7          	jalr	-684(ra) # 10ee <ithread_join>

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
     3ba:	f6250513          	addi	a0,a0,-158 # 1318 <ithread_join+0x22a>
     3be:	00001097          	auipc	ra,0x1
     3c2:	994080e7          	jalr	-1644(ra) # d52 <printf>

  int *arg = malloc(sizeof(int));
     3c6:	4511                	li	a0,4
     3c8:	00001097          	auipc	ra,0x1
     3cc:	a42080e7          	jalr	-1470(ra) # e0a <malloc>
     3d0:	85aa                	mv	a1,a0
  *arg = 100;
     3d2:	06400793          	li	a5,100
     3d6:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3d8:	00000517          	auipc	a0,0x0
     3dc:	e3c50513          	addi	a0,a0,-452 # 214 <thread_func_basic>
     3e0:	00001097          	auipc	ra,0x1
     3e4:	c1a080e7          	jalr	-998(ra) # ffa <ithread_create>

  if (tid < 0) {
     3e8:	02054763          	bltz	a0,416 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ec:	00001097          	auipc	ra,0x1
     3f0:	d02080e7          	jalr	-766(ra) # 10ee <ithread_join>
     3f4:	85aa                	mv	a1,a0
  if (status == 101) {
     3f6:	06500793          	li	a5,101
     3fa:	02f50763          	beq	a0,a5,428 <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     3fe:	00001517          	auipc	a0,0x1
     402:	f9a50513          	addi	a0,a0,-102 # 1398 <ithread_join+0x2aa>
     406:	00001097          	auipc	ra,0x1
     40a:	94c080e7          	jalr	-1716(ra) # d52 <printf>
  }
}
     40e:	60a2                	ld	ra,8(sp)
     410:	6402                	ld	s0,0(sp)
     412:	0141                	addi	sp,sp,16
     414:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     416:	00001517          	auipc	a0,0x1
     41a:	f2250513          	addi	a0,a0,-222 # 1338 <ithread_join+0x24a>
     41e:	00001097          	auipc	ra,0x1
     422:	934080e7          	jalr	-1740(ra) # d52 <printf>
    return;
     426:	b7e5                	j	40e <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     428:	06500593          	li	a1,101
     42c:	00001517          	auipc	a0,0x1
     430:	f3c50513          	addi	a0,a0,-196 # 1368 <ithread_join+0x27a>
     434:	00001097          	auipc	ra,0x1
     438:	91e080e7          	jalr	-1762(ra) # d52 <printf>
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
     452:	f7250513          	addi	a0,a0,-142 # 13c0 <ithread_join+0x2d2>
     456:	00001097          	auipc	ra,0x1
     45a:	8fc080e7          	jalr	-1796(ra) # d52 <printf>

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
     480:	b7e080e7          	jalr	-1154(ra) # ffa <ithread_create>
     484:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     488:	0911                	addi	s2,s2,4
     48a:	ff3917e3          	bne	s2,s3,478 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48e:	4088                	lw	a0,0(s1)
     490:	00001097          	auipc	ra,0x1
     494:	c5e080e7          	jalr	-930(ra) # 10ee <ithread_join>
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
     4b2:	f6250513          	addi	a0,a0,-158 # 1410 <ithread_join+0x322>
     4b6:	00001097          	auipc	ra,0x1
     4ba:	89c080e7          	jalr	-1892(ra) # d52 <printf>
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
     4d6:	f1650513          	addi	a0,a0,-234 # 13e8 <ithread_join+0x2fa>
     4da:	00001097          	auipc	ra,0x1
     4de:	878080e7          	jalr	-1928(ra) # d52 <printf>
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
     4f0:	f4c50513          	addi	a0,a0,-180 # 1438 <ithread_join+0x34a>
     4f4:	00001097          	auipc	ra,0x1
     4f8:	85e080e7          	jalr	-1954(ra) # d52 <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4fc:	4581                	li	a1,0
     4fe:	00000517          	auipc	a0,0x0
     502:	d5450513          	addi	a0,a0,-684 # 252 <thread_func_exit>
     506:	00001097          	auipc	ra,0x1
     50a:	af4080e7          	jalr	-1292(ra) # ffa <ithread_create>
  int status = ithread_join(tid);
     50e:	00001097          	auipc	ra,0x1
     512:	be0080e7          	jalr	-1056(ra) # 10ee <ithread_join>
     516:	85aa                	mv	a1,a0

  if (status == 0) {
     518:	ed09                	bnez	a0,532 <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     51a:	00001517          	auipc	a0,0x1
     51e:	f4650513          	addi	a0,a0,-186 # 1460 <ithread_join+0x372>
     522:	00001097          	auipc	ra,0x1
     526:	830080e7          	jalr	-2000(ra) # d52 <printf>
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
     536:	f6e50513          	addi	a0,a0,-146 # 14a0 <ithread_join+0x3b2>
     53a:	00001097          	auipc	ra,0x1
     53e:	818080e7          	jalr	-2024(ra) # d52 <printf>
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
     55e:	f7650513          	addi	a0,a0,-138 # 14d0 <ithread_join+0x3e2>
     562:	00000097          	auipc	ra,0x0
     566:	7f0080e7          	jalr	2032(ra) # d52 <printf>
  int *num = malloc(10*sizeof(int));
     56a:	02800513          	li	a0,40
     56e:	00001097          	auipc	ra,0x1
     572:	89c080e7          	jalr	-1892(ra) # e0a <malloc>
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
     598:	a66080e7          	jalr	-1434(ra) # ffa <ithread_create>
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
     5b4:	b3e080e7          	jalr	-1218(ra) # 10ee <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b8:	0491                	addi	s1,s1,4
     5ba:	ff249ae3          	bne	s1,s2,5ae <test_exit_all+0x6a>
  }
  free(num);
     5be:	855e                	mv	a0,s7
     5c0:	00000097          	auipc	ra,0x0
     5c4:	7c8080e7          	jalr	1992(ra) # d88 <free>
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
     5e4:	e426                	sd	s1,8(sp)
     5e6:	1000                	addi	s0,sp,32
  if (argc > 2) {
     5e8:	4789                	li	a5,2
     5ea:	02a7d063          	bge	a5,a0,60a <main+0x2c>
    printf("Needs the format: xv6test (1-7)\n", argv[0]);
     5ee:	618c                	ld	a1,0(a1)
     5f0:	00001517          	auipc	a0,0x1
     5f4:	f1050513          	addi	a0,a0,-240 # 1500 <ithread_join+0x412>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	75a080e7          	jalr	1882(ra) # d52 <printf>
    exit(1);
     600:	4505                	li	a0,1
     602:	00000097          	auipc	ra,0x0
     606:	3b6080e7          	jalr	950(ra) # 9b8 <exit>
     60a:	84aa                	mv	s1,a0
  }

  int test = atoi(argv[1]);
     60c:	6588                	ld	a0,8(a1)
     60e:	00000097          	auipc	ra,0x0
     612:	2b0080e7          	jalr	688(ra) # 8be <atoi>
  if(argc == 2){ 
     616:	4789                	li	a5,2
     618:	08f49063          	bne	s1,a5,698 <main+0xba>
  switch (test) {
     61c:	357d                	addiw	a0,a0,-1
     61e:	0005071b          	sext.w	a4,a0
     622:	4799                	li	a5,6
     624:	06e7e163          	bltu	a5,a4,686 <main+0xa8>
     628:	02051793          	slli	a5,a0,0x20
     62c:	01e7d513          	srli	a0,a5,0x1e
     630:	00001717          	auipc	a4,0x1
     634:	f1c70713          	addi	a4,a4,-228 # 154c <ithread_join+0x45e>
     638:	953a                	add	a0,a0,a4
     63a:	411c                	lw	a5,0(a0)
     63c:	97ba                	add	a5,a5,a4
     63e:	8782                	jr	a5
    case 1:
      test_thread_create();
     640:	00000097          	auipc	ra,0x0
     644:	c2e080e7          	jalr	-978(ra) # 26e <test_thread_create>
      break;
     648:	a0c5                	j	728 <main+0x14a>
    case 2:
      test_thread_join();
     64a:	00000097          	auipc	ra,0x0
     64e:	d64080e7          	jalr	-668(ra) # 3ae <test_thread_join>
      break;
     652:	a8d9                	j	728 <main+0x14a>
    case 3:
      test_shared_memory();
     654:	00000097          	auipc	ra,0x0
     658:	dea080e7          	jalr	-534(ra) # 43e <test_shared_memory>
      break;
     65c:	a0f1                	j	728 <main+0x14a>
    case 4:
      test_exit();
     65e:	00000097          	auipc	ra,0x0
     662:	e86080e7          	jalr	-378(ra) # 4e4 <test_exit>
      break;
     666:	a0c9                	j	728 <main+0x14a>
    case 5:
      test_exit_all();
     668:	00000097          	auipc	ra,0x0
     66c:	edc080e7          	jalr	-292(ra) # 544 <test_exit_all>
      break;
     670:	a865                	j	728 <main+0x14a>
    case 6:
      test_global_pointer_alloc();
     672:	00000097          	auipc	ra,0x0
     676:	cd8080e7          	jalr	-808(ra) # 34a <test_global_pointer_alloc>
      break;
     67a:	a07d                	j	728 <main+0x14a>
    case 7:
      test_global_pointer_dealloc();
     67c:	00000097          	auipc	ra,0x0
     680:	c6a080e7          	jalr	-918(ra) # 2e6 <test_global_pointer_dealloc>
      break;
     684:	a055                	j	728 <main+0x14a>
    default:
      printf("Invalid test number. Choose 1-5.\n");
     686:	00001517          	auipc	a0,0x1
     68a:	ea250513          	addi	a0,a0,-350 # 1528 <ithread_join+0x43a>
     68e:	00000097          	auipc	ra,0x0
     692:	6c4080e7          	jalr	1732(ra) # d52 <printf>
     696:	a849                	j	728 <main+0x14a>
  }
  }else{
   test_thread_create();
     698:	00000097          	auipc	ra,0x0
     69c:	bd6080e7          	jalr	-1066(ra) # 26e <test_thread_create>
   printf("\n");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	ea850513          	addi	a0,a0,-344 # 1548 <ithread_join+0x45a>
     6a8:	00000097          	auipc	ra,0x0
     6ac:	6aa080e7          	jalr	1706(ra) # d52 <printf>
   test_thread_join();
     6b0:	00000097          	auipc	ra,0x0
     6b4:	cfe080e7          	jalr	-770(ra) # 3ae <test_thread_join>
   printf("\n");
     6b8:	00001517          	auipc	a0,0x1
     6bc:	e9050513          	addi	a0,a0,-368 # 1548 <ithread_join+0x45a>
     6c0:	00000097          	auipc	ra,0x0
     6c4:	692080e7          	jalr	1682(ra) # d52 <printf>
   test_shared_memory();
     6c8:	00000097          	auipc	ra,0x0
     6cc:	d76080e7          	jalr	-650(ra) # 43e <test_shared_memory>
   printf("\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	e7850513          	addi	a0,a0,-392 # 1548 <ithread_join+0x45a>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	67a080e7          	jalr	1658(ra) # d52 <printf>
   test_exit();
     6e0:	00000097          	auipc	ra,0x0
     6e4:	e04080e7          	jalr	-508(ra) # 4e4 <test_exit>
   printf("\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	e6050513          	addi	a0,a0,-416 # 1548 <ithread_join+0x45a>
     6f0:	00000097          	auipc	ra,0x0
     6f4:	662080e7          	jalr	1634(ra) # d52 <printf>
   // test_exit_all();
   printf("\n");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	e5050513          	addi	a0,a0,-432 # 1548 <ithread_join+0x45a>
     700:	00000097          	auipc	ra,0x0
     704:	652080e7          	jalr	1618(ra) # d52 <printf>
   test_global_pointer_alloc();
     708:	00000097          	auipc	ra,0x0
     70c:	c42080e7          	jalr	-958(ra) # 34a <test_global_pointer_alloc>
   printf("\n");
     710:	00001517          	auipc	a0,0x1
     714:	e3850513          	addi	a0,a0,-456 # 1548 <ithread_join+0x45a>
     718:	00000097          	auipc	ra,0x0
     71c:	63a080e7          	jalr	1594(ra) # d52 <printf>
   test_global_pointer_dealloc();
     720:	00000097          	auipc	ra,0x0
     724:	bc6080e7          	jalr	-1082(ra) # 2e6 <test_global_pointer_dealloc>
  }

  exit(0);
     728:	4501                	li	a0,0
     72a:	00000097          	auipc	ra,0x0
     72e:	28e080e7          	jalr	654(ra) # 9b8 <exit>

0000000000000732 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     732:	1141                	addi	sp,sp,-16
     734:	e406                	sd	ra,8(sp)
     736:	e022                	sd	s0,0(sp)
     738:	0800                	addi	s0,sp,16
  extern int main();
  main();
     73a:	00000097          	auipc	ra,0x0
     73e:	ea4080e7          	jalr	-348(ra) # 5de <main>
  exit(0);
     742:	4501                	li	a0,0
     744:	00000097          	auipc	ra,0x0
     748:	274080e7          	jalr	628(ra) # 9b8 <exit>

000000000000074c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     74c:	1141                	addi	sp,sp,-16
     74e:	e422                	sd	s0,8(sp)
     750:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     752:	87aa                	mv	a5,a0
     754:	0585                	addi	a1,a1,1
     756:	0785                	addi	a5,a5,1
     758:	fff5c703          	lbu	a4,-1(a1)
     75c:	fee78fa3          	sb	a4,-1(a5)
     760:	fb75                	bnez	a4,754 <strcpy+0x8>
    ;
  return os;
}
     762:	6422                	ld	s0,8(sp)
     764:	0141                	addi	sp,sp,16
     766:	8082                	ret

0000000000000768 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     768:	1141                	addi	sp,sp,-16
     76a:	e422                	sd	s0,8(sp)
     76c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     76e:	00054783          	lbu	a5,0(a0)
     772:	cb91                	beqz	a5,786 <strcmp+0x1e>
     774:	0005c703          	lbu	a4,0(a1)
     778:	00f71763          	bne	a4,a5,786 <strcmp+0x1e>
    p++, q++;
     77c:	0505                	addi	a0,a0,1
     77e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     780:	00054783          	lbu	a5,0(a0)
     784:	fbe5                	bnez	a5,774 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     786:	0005c503          	lbu	a0,0(a1)
}
     78a:	40a7853b          	subw	a0,a5,a0
     78e:	6422                	ld	s0,8(sp)
     790:	0141                	addi	sp,sp,16
     792:	8082                	ret

0000000000000794 <strlen>:

uint
strlen(const char *s)
{
     794:	1141                	addi	sp,sp,-16
     796:	e422                	sd	s0,8(sp)
     798:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     79a:	00054783          	lbu	a5,0(a0)
     79e:	cf91                	beqz	a5,7ba <strlen+0x26>
     7a0:	0505                	addi	a0,a0,1
     7a2:	87aa                	mv	a5,a0
     7a4:	4685                	li	a3,1
     7a6:	9e89                	subw	a3,a3,a0
     7a8:	00f6853b          	addw	a0,a3,a5
     7ac:	0785                	addi	a5,a5,1
     7ae:	fff7c703          	lbu	a4,-1(a5)
     7b2:	fb7d                	bnez	a4,7a8 <strlen+0x14>
    ;
  return n;
}
     7b4:	6422                	ld	s0,8(sp)
     7b6:	0141                	addi	sp,sp,16
     7b8:	8082                	ret
  for(n = 0; s[n]; n++)
     7ba:	4501                	li	a0,0
     7bc:	bfe5                	j	7b4 <strlen+0x20>

00000000000007be <memset>:

void*
memset(void *dst, int c, uint n)
{
     7be:	1141                	addi	sp,sp,-16
     7c0:	e422                	sd	s0,8(sp)
     7c2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     7c4:	ca19                	beqz	a2,7da <memset+0x1c>
     7c6:	87aa                	mv	a5,a0
     7c8:	1602                	slli	a2,a2,0x20
     7ca:	9201                	srli	a2,a2,0x20
     7cc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     7d0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     7d4:	0785                	addi	a5,a5,1
     7d6:	fee79de3          	bne	a5,a4,7d0 <memset+0x12>
  }
  return dst;
}
     7da:	6422                	ld	s0,8(sp)
     7dc:	0141                	addi	sp,sp,16
     7de:	8082                	ret

00000000000007e0 <strchr>:

char*
strchr(const char *s, char c)
{
     7e0:	1141                	addi	sp,sp,-16
     7e2:	e422                	sd	s0,8(sp)
     7e4:	0800                	addi	s0,sp,16
  for(; *s; s++)
     7e6:	00054783          	lbu	a5,0(a0)
     7ea:	cb99                	beqz	a5,800 <strchr+0x20>
    if(*s == c)
     7ec:	00f58763          	beq	a1,a5,7fa <strchr+0x1a>
  for(; *s; s++)
     7f0:	0505                	addi	a0,a0,1
     7f2:	00054783          	lbu	a5,0(a0)
     7f6:	fbfd                	bnez	a5,7ec <strchr+0xc>
      return (char*)s;
  return 0;
     7f8:	4501                	li	a0,0
}
     7fa:	6422                	ld	s0,8(sp)
     7fc:	0141                	addi	sp,sp,16
     7fe:	8082                	ret
  return 0;
     800:	4501                	li	a0,0
     802:	bfe5                	j	7fa <strchr+0x1a>

0000000000000804 <gets>:

char*
gets(char *buf, int max)
{
     804:	711d                	addi	sp,sp,-96
     806:	ec86                	sd	ra,88(sp)
     808:	e8a2                	sd	s0,80(sp)
     80a:	e4a6                	sd	s1,72(sp)
     80c:	e0ca                	sd	s2,64(sp)
     80e:	fc4e                	sd	s3,56(sp)
     810:	f852                	sd	s4,48(sp)
     812:	f456                	sd	s5,40(sp)
     814:	f05a                	sd	s6,32(sp)
     816:	ec5e                	sd	s7,24(sp)
     818:	1080                	addi	s0,sp,96
     81a:	8baa                	mv	s7,a0
     81c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     81e:	892a                	mv	s2,a0
     820:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     822:	4aa9                	li	s5,10
     824:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     826:	89a6                	mv	s3,s1
     828:	2485                	addiw	s1,s1,1
     82a:	0344d863          	bge	s1,s4,85a <gets+0x56>
    cc = read(0, &c, 1);
     82e:	4605                	li	a2,1
     830:	faf40593          	addi	a1,s0,-81
     834:	4501                	li	a0,0
     836:	00000097          	auipc	ra,0x0
     83a:	19a080e7          	jalr	410(ra) # 9d0 <read>
    if(cc < 1)
     83e:	00a05e63          	blez	a0,85a <gets+0x56>
    buf[i++] = c;
     842:	faf44783          	lbu	a5,-81(s0)
     846:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     84a:	01578763          	beq	a5,s5,858 <gets+0x54>
     84e:	0905                	addi	s2,s2,1
     850:	fd679be3          	bne	a5,s6,826 <gets+0x22>
  for(i=0; i+1 < max; ){
     854:	89a6                	mv	s3,s1
     856:	a011                	j	85a <gets+0x56>
     858:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     85a:	99de                	add	s3,s3,s7
     85c:	00098023          	sb	zero,0(s3)
  return buf;
}
     860:	855e                	mv	a0,s7
     862:	60e6                	ld	ra,88(sp)
     864:	6446                	ld	s0,80(sp)
     866:	64a6                	ld	s1,72(sp)
     868:	6906                	ld	s2,64(sp)
     86a:	79e2                	ld	s3,56(sp)
     86c:	7a42                	ld	s4,48(sp)
     86e:	7aa2                	ld	s5,40(sp)
     870:	7b02                	ld	s6,32(sp)
     872:	6be2                	ld	s7,24(sp)
     874:	6125                	addi	sp,sp,96
     876:	8082                	ret

0000000000000878 <stat>:

int
stat(const char *n, struct stat *st)
{
     878:	1101                	addi	sp,sp,-32
     87a:	ec06                	sd	ra,24(sp)
     87c:	e822                	sd	s0,16(sp)
     87e:	e426                	sd	s1,8(sp)
     880:	e04a                	sd	s2,0(sp)
     882:	1000                	addi	s0,sp,32
     884:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     886:	4581                	li	a1,0
     888:	00000097          	auipc	ra,0x0
     88c:	170080e7          	jalr	368(ra) # 9f8 <open>
  if(fd < 0)
     890:	02054563          	bltz	a0,8ba <stat+0x42>
     894:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     896:	85ca                	mv	a1,s2
     898:	00000097          	auipc	ra,0x0
     89c:	178080e7          	jalr	376(ra) # a10 <fstat>
     8a0:	892a                	mv	s2,a0
  close(fd);
     8a2:	8526                	mv	a0,s1
     8a4:	00000097          	auipc	ra,0x0
     8a8:	13c080e7          	jalr	316(ra) # 9e0 <close>
  return r;
}
     8ac:	854a                	mv	a0,s2
     8ae:	60e2                	ld	ra,24(sp)
     8b0:	6442                	ld	s0,16(sp)
     8b2:	64a2                	ld	s1,8(sp)
     8b4:	6902                	ld	s2,0(sp)
     8b6:	6105                	addi	sp,sp,32
     8b8:	8082                	ret
    return -1;
     8ba:	597d                	li	s2,-1
     8bc:	bfc5                	j	8ac <stat+0x34>

00000000000008be <atoi>:

int
atoi(const char *s)
{
     8be:	1141                	addi	sp,sp,-16
     8c0:	e422                	sd	s0,8(sp)
     8c2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     8c4:	00054683          	lbu	a3,0(a0)
     8c8:	fd06879b          	addiw	a5,a3,-48
     8cc:	0ff7f793          	zext.b	a5,a5
     8d0:	4625                	li	a2,9
     8d2:	02f66863          	bltu	a2,a5,902 <atoi+0x44>
     8d6:	872a                	mv	a4,a0
  n = 0;
     8d8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     8da:	0705                	addi	a4,a4,1
     8dc:	0025179b          	slliw	a5,a0,0x2
     8e0:	9fa9                	addw	a5,a5,a0
     8e2:	0017979b          	slliw	a5,a5,0x1
     8e6:	9fb5                	addw	a5,a5,a3
     8e8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     8ec:	00074683          	lbu	a3,0(a4)
     8f0:	fd06879b          	addiw	a5,a3,-48
     8f4:	0ff7f793          	zext.b	a5,a5
     8f8:	fef671e3          	bgeu	a2,a5,8da <atoi+0x1c>
  return n;
}
     8fc:	6422                	ld	s0,8(sp)
     8fe:	0141                	addi	sp,sp,16
     900:	8082                	ret
  n = 0;
     902:	4501                	li	a0,0
     904:	bfe5                	j	8fc <atoi+0x3e>

0000000000000906 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     906:	1141                	addi	sp,sp,-16
     908:	e422                	sd	s0,8(sp)
     90a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     90c:	02b57463          	bgeu	a0,a1,934 <memmove+0x2e>
    while(n-- > 0)
     910:	00c05f63          	blez	a2,92e <memmove+0x28>
     914:	1602                	slli	a2,a2,0x20
     916:	9201                	srli	a2,a2,0x20
     918:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     91c:	872a                	mv	a4,a0
      *dst++ = *src++;
     91e:	0585                	addi	a1,a1,1
     920:	0705                	addi	a4,a4,1
     922:	fff5c683          	lbu	a3,-1(a1)
     926:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     92a:	fee79ae3          	bne	a5,a4,91e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     92e:	6422                	ld	s0,8(sp)
     930:	0141                	addi	sp,sp,16
     932:	8082                	ret
    dst += n;
     934:	00c50733          	add	a4,a0,a2
    src += n;
     938:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     93a:	fec05ae3          	blez	a2,92e <memmove+0x28>
     93e:	fff6079b          	addiw	a5,a2,-1
     942:	1782                	slli	a5,a5,0x20
     944:	9381                	srli	a5,a5,0x20
     946:	fff7c793          	not	a5,a5
     94a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     94c:	15fd                	addi	a1,a1,-1
     94e:	177d                	addi	a4,a4,-1
     950:	0005c683          	lbu	a3,0(a1)
     954:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     958:	fee79ae3          	bne	a5,a4,94c <memmove+0x46>
     95c:	bfc9                	j	92e <memmove+0x28>

000000000000095e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     95e:	1141                	addi	sp,sp,-16
     960:	e422                	sd	s0,8(sp)
     962:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     964:	ca05                	beqz	a2,994 <memcmp+0x36>
     966:	fff6069b          	addiw	a3,a2,-1
     96a:	1682                	slli	a3,a3,0x20
     96c:	9281                	srli	a3,a3,0x20
     96e:	0685                	addi	a3,a3,1
     970:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     972:	00054783          	lbu	a5,0(a0)
     976:	0005c703          	lbu	a4,0(a1)
     97a:	00e79863          	bne	a5,a4,98a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     97e:	0505                	addi	a0,a0,1
    p2++;
     980:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     982:	fed518e3          	bne	a0,a3,972 <memcmp+0x14>
  }
  return 0;
     986:	4501                	li	a0,0
     988:	a019                	j	98e <memcmp+0x30>
      return *p1 - *p2;
     98a:	40e7853b          	subw	a0,a5,a4
}
     98e:	6422                	ld	s0,8(sp)
     990:	0141                	addi	sp,sp,16
     992:	8082                	ret
  return 0;
     994:	4501                	li	a0,0
     996:	bfe5                	j	98e <memcmp+0x30>

0000000000000998 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     998:	1141                	addi	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     9a0:	00000097          	auipc	ra,0x0
     9a4:	f66080e7          	jalr	-154(ra) # 906 <memmove>
}
     9a8:	60a2                	ld	ra,8(sp)
     9aa:	6402                	ld	s0,0(sp)
     9ac:	0141                	addi	sp,sp,16
     9ae:	8082                	ret

00000000000009b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     9b0:	4885                	li	a7,1
 ecall
     9b2:	00000073          	ecall
 ret
     9b6:	8082                	ret

00000000000009b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     9b8:	4889                	li	a7,2
 ecall
     9ba:	00000073          	ecall
 ret
     9be:	8082                	ret

00000000000009c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     9c0:	488d                	li	a7,3
 ecall
     9c2:	00000073          	ecall
 ret
     9c6:	8082                	ret

00000000000009c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     9c8:	4891                	li	a7,4
 ecall
     9ca:	00000073          	ecall
 ret
     9ce:	8082                	ret

00000000000009d0 <read>:
.global read
read:
 li a7, SYS_read
     9d0:	4895                	li	a7,5
 ecall
     9d2:	00000073          	ecall
 ret
     9d6:	8082                	ret

00000000000009d8 <write>:
.global write
write:
 li a7, SYS_write
     9d8:	48c1                	li	a7,16
 ecall
     9da:	00000073          	ecall
 ret
     9de:	8082                	ret

00000000000009e0 <close>:
.global close
close:
 li a7, SYS_close
     9e0:	48d5                	li	a7,21
 ecall
     9e2:	00000073          	ecall
 ret
     9e6:	8082                	ret

00000000000009e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
     9e8:	4899                	li	a7,6
 ecall
     9ea:	00000073          	ecall
 ret
     9ee:	8082                	ret

00000000000009f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
     9f0:	489d                	li	a7,7
 ecall
     9f2:	00000073          	ecall
 ret
     9f6:	8082                	ret

00000000000009f8 <open>:
.global open
open:
 li a7, SYS_open
     9f8:	48bd                	li	a7,15
 ecall
     9fa:	00000073          	ecall
 ret
     9fe:	8082                	ret

0000000000000a00 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     a00:	48c5                	li	a7,17
 ecall
     a02:	00000073          	ecall
 ret
     a06:	8082                	ret

0000000000000a08 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     a08:	48c9                	li	a7,18
 ecall
     a0a:	00000073          	ecall
 ret
     a0e:	8082                	ret

0000000000000a10 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     a10:	48a1                	li	a7,8
 ecall
     a12:	00000073          	ecall
 ret
     a16:	8082                	ret

0000000000000a18 <link>:
.global link
link:
 li a7, SYS_link
     a18:	48cd                	li	a7,19
 ecall
     a1a:	00000073          	ecall
 ret
     a1e:	8082                	ret

0000000000000a20 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     a20:	48d1                	li	a7,20
 ecall
     a22:	00000073          	ecall
 ret
     a26:	8082                	ret

0000000000000a28 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     a28:	48a5                	li	a7,9
 ecall
     a2a:	00000073          	ecall
 ret
     a2e:	8082                	ret

0000000000000a30 <dup>:
.global dup
dup:
 li a7, SYS_dup
     a30:	48a9                	li	a7,10
 ecall
     a32:	00000073          	ecall
 ret
     a36:	8082                	ret

0000000000000a38 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     a38:	48ad                	li	a7,11
 ecall
     a3a:	00000073          	ecall
 ret
     a3e:	8082                	ret

0000000000000a40 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     a40:	48b1                	li	a7,12
 ecall
     a42:	00000073          	ecall
 ret
     a46:	8082                	ret

0000000000000a48 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     a48:	48b5                	li	a7,13
 ecall
     a4a:	00000073          	ecall
 ret
     a4e:	8082                	ret

0000000000000a50 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     a50:	48b9                	li	a7,14
 ecall
     a52:	00000073          	ecall
 ret
     a56:	8082                	ret

0000000000000a58 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     a58:	48d9                	li	a7,22
 ecall
     a5a:	00000073          	ecall
 ret
     a5e:	8082                	ret

0000000000000a60 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     a60:	48dd                	li	a7,23
 ecall
     a62:	00000073          	ecall
 ret
     a66:	8082                	ret

0000000000000a68 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     a68:	48e1                	li	a7,24
 ecall
     a6a:	00000073          	ecall
 ret
     a6e:	8082                	ret

0000000000000a70 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     a70:	48e5                	li	a7,25
 ecall
     a72:	00000073          	ecall
 ret
     a76:	8082                	ret

0000000000000a78 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     a78:	1101                	addi	sp,sp,-32
     a7a:	ec06                	sd	ra,24(sp)
     a7c:	e822                	sd	s0,16(sp)
     a7e:	1000                	addi	s0,sp,32
     a80:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     a84:	4605                	li	a2,1
     a86:	fef40593          	addi	a1,s0,-17
     a8a:	00000097          	auipc	ra,0x0
     a8e:	f4e080e7          	jalr	-178(ra) # 9d8 <write>
}
     a92:	60e2                	ld	ra,24(sp)
     a94:	6442                	ld	s0,16(sp)
     a96:	6105                	addi	sp,sp,32
     a98:	8082                	ret

0000000000000a9a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     a9a:	7139                	addi	sp,sp,-64
     a9c:	fc06                	sd	ra,56(sp)
     a9e:	f822                	sd	s0,48(sp)
     aa0:	f426                	sd	s1,40(sp)
     aa2:	f04a                	sd	s2,32(sp)
     aa4:	ec4e                	sd	s3,24(sp)
     aa6:	0080                	addi	s0,sp,64
     aa8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     aaa:	c299                	beqz	a3,ab0 <printint+0x16>
     aac:	0805c963          	bltz	a1,b3e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ab0:	2581                	sext.w	a1,a1
  neg = 0;
     ab2:	4881                	li	a7,0
     ab4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ab8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     aba:	2601                	sext.w	a2,a2
     abc:	00001517          	auipc	a0,0x1
     ac0:	b0c50513          	addi	a0,a0,-1268 # 15c8 <digits>
     ac4:	883a                	mv	a6,a4
     ac6:	2705                	addiw	a4,a4,1
     ac8:	02c5f7bb          	remuw	a5,a1,a2
     acc:	1782                	slli	a5,a5,0x20
     ace:	9381                	srli	a5,a5,0x20
     ad0:	97aa                	add	a5,a5,a0
     ad2:	0007c783          	lbu	a5,0(a5)
     ad6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ada:	0005879b          	sext.w	a5,a1
     ade:	02c5d5bb          	divuw	a1,a1,a2
     ae2:	0685                	addi	a3,a3,1
     ae4:	fec7f0e3          	bgeu	a5,a2,ac4 <printint+0x2a>
  if(neg)
     ae8:	00088c63          	beqz	a7,b00 <printint+0x66>
    buf[i++] = '-';
     aec:	fd070793          	addi	a5,a4,-48
     af0:	00878733          	add	a4,a5,s0
     af4:	02d00793          	li	a5,45
     af8:	fef70823          	sb	a5,-16(a4)
     afc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     b00:	02e05863          	blez	a4,b30 <printint+0x96>
     b04:	fc040793          	addi	a5,s0,-64
     b08:	00e78933          	add	s2,a5,a4
     b0c:	fff78993          	addi	s3,a5,-1
     b10:	99ba                	add	s3,s3,a4
     b12:	377d                	addiw	a4,a4,-1
     b14:	1702                	slli	a4,a4,0x20
     b16:	9301                	srli	a4,a4,0x20
     b18:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b1c:	fff94583          	lbu	a1,-1(s2)
     b20:	8526                	mv	a0,s1
     b22:	00000097          	auipc	ra,0x0
     b26:	f56080e7          	jalr	-170(ra) # a78 <putc>
  while(--i >= 0)
     b2a:	197d                	addi	s2,s2,-1
     b2c:	ff3918e3          	bne	s2,s3,b1c <printint+0x82>
}
     b30:	70e2                	ld	ra,56(sp)
     b32:	7442                	ld	s0,48(sp)
     b34:	74a2                	ld	s1,40(sp)
     b36:	7902                	ld	s2,32(sp)
     b38:	69e2                	ld	s3,24(sp)
     b3a:	6121                	addi	sp,sp,64
     b3c:	8082                	ret
    x = -xx;
     b3e:	40b005bb          	negw	a1,a1
    neg = 1;
     b42:	4885                	li	a7,1
    x = -xx;
     b44:	bf85                	j	ab4 <printint+0x1a>

0000000000000b46 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b46:	7119                	addi	sp,sp,-128
     b48:	fc86                	sd	ra,120(sp)
     b4a:	f8a2                	sd	s0,112(sp)
     b4c:	f4a6                	sd	s1,104(sp)
     b4e:	f0ca                	sd	s2,96(sp)
     b50:	ecce                	sd	s3,88(sp)
     b52:	e8d2                	sd	s4,80(sp)
     b54:	e4d6                	sd	s5,72(sp)
     b56:	e0da                	sd	s6,64(sp)
     b58:	fc5e                	sd	s7,56(sp)
     b5a:	f862                	sd	s8,48(sp)
     b5c:	f466                	sd	s9,40(sp)
     b5e:	f06a                	sd	s10,32(sp)
     b60:	ec6e                	sd	s11,24(sp)
     b62:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     b64:	0005c903          	lbu	s2,0(a1)
     b68:	18090f63          	beqz	s2,d06 <vprintf+0x1c0>
     b6c:	8aaa                	mv	s5,a0
     b6e:	8b32                	mv	s6,a2
     b70:	00158493          	addi	s1,a1,1
  state = 0;
     b74:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     b76:	02500a13          	li	s4,37
     b7a:	4c55                	li	s8,21
     b7c:	00001c97          	auipc	s9,0x1
     b80:	9f4c8c93          	addi	s9,s9,-1548 # 1570 <ithread_join+0x482>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     b84:	02800d93          	li	s11,40
  putc(fd, 'x');
     b88:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     b8a:	00001b97          	auipc	s7,0x1
     b8e:	a3eb8b93          	addi	s7,s7,-1474 # 15c8 <digits>
     b92:	a839                	j	bb0 <vprintf+0x6a>
        putc(fd, c);
     b94:	85ca                	mv	a1,s2
     b96:	8556                	mv	a0,s5
     b98:	00000097          	auipc	ra,0x0
     b9c:	ee0080e7          	jalr	-288(ra) # a78 <putc>
     ba0:	a019                	j	ba6 <vprintf+0x60>
    } else if(state == '%'){
     ba2:	01498d63          	beq	s3,s4,bbc <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     ba6:	0485                	addi	s1,s1,1
     ba8:	fff4c903          	lbu	s2,-1(s1)
     bac:	14090d63          	beqz	s2,d06 <vprintf+0x1c0>
    if(state == 0){
     bb0:	fe0999e3          	bnez	s3,ba2 <vprintf+0x5c>
      if(c == '%'){
     bb4:	ff4910e3          	bne	s2,s4,b94 <vprintf+0x4e>
        state = '%';
     bb8:	89d2                	mv	s3,s4
     bba:	b7f5                	j	ba6 <vprintf+0x60>
      if(c == 'd'){
     bbc:	11490c63          	beq	s2,s4,cd4 <vprintf+0x18e>
     bc0:	f9d9079b          	addiw	a5,s2,-99
     bc4:	0ff7f793          	zext.b	a5,a5
     bc8:	10fc6e63          	bltu	s8,a5,ce4 <vprintf+0x19e>
     bcc:	f9d9079b          	addiw	a5,s2,-99
     bd0:	0ff7f713          	zext.b	a4,a5
     bd4:	10ec6863          	bltu	s8,a4,ce4 <vprintf+0x19e>
     bd8:	00271793          	slli	a5,a4,0x2
     bdc:	97e6                	add	a5,a5,s9
     bde:	439c                	lw	a5,0(a5)
     be0:	97e6                	add	a5,a5,s9
     be2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     be4:	008b0913          	addi	s2,s6,8
     be8:	4685                	li	a3,1
     bea:	4629                	li	a2,10
     bec:	000b2583          	lw	a1,0(s6)
     bf0:	8556                	mv	a0,s5
     bf2:	00000097          	auipc	ra,0x0
     bf6:	ea8080e7          	jalr	-344(ra) # a9a <printint>
     bfa:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     bfc:	4981                	li	s3,0
     bfe:	b765                	j	ba6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c00:	008b0913          	addi	s2,s6,8
     c04:	4681                	li	a3,0
     c06:	4629                	li	a2,10
     c08:	000b2583          	lw	a1,0(s6)
     c0c:	8556                	mv	a0,s5
     c0e:	00000097          	auipc	ra,0x0
     c12:	e8c080e7          	jalr	-372(ra) # a9a <printint>
     c16:	8b4a                	mv	s6,s2
      state = 0;
     c18:	4981                	li	s3,0
     c1a:	b771                	j	ba6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     c1c:	008b0913          	addi	s2,s6,8
     c20:	4681                	li	a3,0
     c22:	866a                	mv	a2,s10
     c24:	000b2583          	lw	a1,0(s6)
     c28:	8556                	mv	a0,s5
     c2a:	00000097          	auipc	ra,0x0
     c2e:	e70080e7          	jalr	-400(ra) # a9a <printint>
     c32:	8b4a                	mv	s6,s2
      state = 0;
     c34:	4981                	li	s3,0
     c36:	bf85                	j	ba6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     c38:	008b0793          	addi	a5,s6,8
     c3c:	f8f43423          	sd	a5,-120(s0)
     c40:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     c44:	03000593          	li	a1,48
     c48:	8556                	mv	a0,s5
     c4a:	00000097          	auipc	ra,0x0
     c4e:	e2e080e7          	jalr	-466(ra) # a78 <putc>
  putc(fd, 'x');
     c52:	07800593          	li	a1,120
     c56:	8556                	mv	a0,s5
     c58:	00000097          	auipc	ra,0x0
     c5c:	e20080e7          	jalr	-480(ra) # a78 <putc>
     c60:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     c62:	03c9d793          	srli	a5,s3,0x3c
     c66:	97de                	add	a5,a5,s7
     c68:	0007c583          	lbu	a1,0(a5)
     c6c:	8556                	mv	a0,s5
     c6e:	00000097          	auipc	ra,0x0
     c72:	e0a080e7          	jalr	-502(ra) # a78 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     c76:	0992                	slli	s3,s3,0x4
     c78:	397d                	addiw	s2,s2,-1
     c7a:	fe0914e3          	bnez	s2,c62 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     c7e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     c82:	4981                	li	s3,0
     c84:	b70d                	j	ba6 <vprintf+0x60>
        s = va_arg(ap, char*);
     c86:	008b0913          	addi	s2,s6,8
     c8a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     c8e:	02098163          	beqz	s3,cb0 <vprintf+0x16a>
        while(*s != 0){
     c92:	0009c583          	lbu	a1,0(s3)
     c96:	c5ad                	beqz	a1,d00 <vprintf+0x1ba>
          putc(fd, *s);
     c98:	8556                	mv	a0,s5
     c9a:	00000097          	auipc	ra,0x0
     c9e:	dde080e7          	jalr	-546(ra) # a78 <putc>
          s++;
     ca2:	0985                	addi	s3,s3,1
        while(*s != 0){
     ca4:	0009c583          	lbu	a1,0(s3)
     ca8:	f9e5                	bnez	a1,c98 <vprintf+0x152>
        s = va_arg(ap, char*);
     caa:	8b4a                	mv	s6,s2
      state = 0;
     cac:	4981                	li	s3,0
     cae:	bde5                	j	ba6 <vprintf+0x60>
          s = "(null)";
     cb0:	00001997          	auipc	s3,0x1
     cb4:	8b898993          	addi	s3,s3,-1864 # 1568 <ithread_join+0x47a>
        while(*s != 0){
     cb8:	85ee                	mv	a1,s11
     cba:	bff9                	j	c98 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     cbc:	008b0913          	addi	s2,s6,8
     cc0:	000b4583          	lbu	a1,0(s6)
     cc4:	8556                	mv	a0,s5
     cc6:	00000097          	auipc	ra,0x0
     cca:	db2080e7          	jalr	-590(ra) # a78 <putc>
     cce:	8b4a                	mv	s6,s2
      state = 0;
     cd0:	4981                	li	s3,0
     cd2:	bdd1                	j	ba6 <vprintf+0x60>
        putc(fd, c);
     cd4:	85d2                	mv	a1,s4
     cd6:	8556                	mv	a0,s5
     cd8:	00000097          	auipc	ra,0x0
     cdc:	da0080e7          	jalr	-608(ra) # a78 <putc>
      state = 0;
     ce0:	4981                	li	s3,0
     ce2:	b5d1                	j	ba6 <vprintf+0x60>
        putc(fd, '%');
     ce4:	85d2                	mv	a1,s4
     ce6:	8556                	mv	a0,s5
     ce8:	00000097          	auipc	ra,0x0
     cec:	d90080e7          	jalr	-624(ra) # a78 <putc>
        putc(fd, c);
     cf0:	85ca                	mv	a1,s2
     cf2:	8556                	mv	a0,s5
     cf4:	00000097          	auipc	ra,0x0
     cf8:	d84080e7          	jalr	-636(ra) # a78 <putc>
      state = 0;
     cfc:	4981                	li	s3,0
     cfe:	b565                	j	ba6 <vprintf+0x60>
        s = va_arg(ap, char*);
     d00:	8b4a                	mv	s6,s2
      state = 0;
     d02:	4981                	li	s3,0
     d04:	b54d                	j	ba6 <vprintf+0x60>
    }
  }
}
     d06:	70e6                	ld	ra,120(sp)
     d08:	7446                	ld	s0,112(sp)
     d0a:	74a6                	ld	s1,104(sp)
     d0c:	7906                	ld	s2,96(sp)
     d0e:	69e6                	ld	s3,88(sp)
     d10:	6a46                	ld	s4,80(sp)
     d12:	6aa6                	ld	s5,72(sp)
     d14:	6b06                	ld	s6,64(sp)
     d16:	7be2                	ld	s7,56(sp)
     d18:	7c42                	ld	s8,48(sp)
     d1a:	7ca2                	ld	s9,40(sp)
     d1c:	7d02                	ld	s10,32(sp)
     d1e:	6de2                	ld	s11,24(sp)
     d20:	6109                	addi	sp,sp,128
     d22:	8082                	ret

0000000000000d24 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d24:	715d                	addi	sp,sp,-80
     d26:	ec06                	sd	ra,24(sp)
     d28:	e822                	sd	s0,16(sp)
     d2a:	1000                	addi	s0,sp,32
     d2c:	e010                	sd	a2,0(s0)
     d2e:	e414                	sd	a3,8(s0)
     d30:	e818                	sd	a4,16(s0)
     d32:	ec1c                	sd	a5,24(s0)
     d34:	03043023          	sd	a6,32(s0)
     d38:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d3c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d40:	8622                	mv	a2,s0
     d42:	00000097          	auipc	ra,0x0
     d46:	e04080e7          	jalr	-508(ra) # b46 <vprintf>
}
     d4a:	60e2                	ld	ra,24(sp)
     d4c:	6442                	ld	s0,16(sp)
     d4e:	6161                	addi	sp,sp,80
     d50:	8082                	ret

0000000000000d52 <printf>:

void
printf(const char *fmt, ...)
{
     d52:	711d                	addi	sp,sp,-96
     d54:	ec06                	sd	ra,24(sp)
     d56:	e822                	sd	s0,16(sp)
     d58:	1000                	addi	s0,sp,32
     d5a:	e40c                	sd	a1,8(s0)
     d5c:	e810                	sd	a2,16(s0)
     d5e:	ec14                	sd	a3,24(s0)
     d60:	f018                	sd	a4,32(s0)
     d62:	f41c                	sd	a5,40(s0)
     d64:	03043823          	sd	a6,48(s0)
     d68:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d6c:	00840613          	addi	a2,s0,8
     d70:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     d74:	85aa                	mv	a1,a0
     d76:	4505                	li	a0,1
     d78:	00000097          	auipc	ra,0x0
     d7c:	dce080e7          	jalr	-562(ra) # b46 <vprintf>
}
     d80:	60e2                	ld	ra,24(sp)
     d82:	6442                	ld	s0,16(sp)
     d84:	6125                	addi	sp,sp,96
     d86:	8082                	ret

0000000000000d88 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     d88:	1141                	addi	sp,sp,-16
     d8a:	e422                	sd	s0,8(sp)
     d8c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     d8e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     d92:	00001797          	auipc	a5,0x1
     d96:	2867b783          	ld	a5,646(a5) # 2018 <freep>
     d9a:	a02d                	j	dc4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     d9c:	4618                	lw	a4,8(a2)
     d9e:	9f2d                	addw	a4,a4,a1
     da0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     da4:	6398                	ld	a4,0(a5)
     da6:	6310                	ld	a2,0(a4)
     da8:	a83d                	j	de6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     daa:	ff852703          	lw	a4,-8(a0)
     dae:	9f31                	addw	a4,a4,a2
     db0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     db2:	ff053683          	ld	a3,-16(a0)
     db6:	a091                	j	dfa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     db8:	6398                	ld	a4,0(a5)
     dba:	00e7e463          	bltu	a5,a4,dc2 <free+0x3a>
     dbe:	00e6ea63          	bltu	a3,a4,dd2 <free+0x4a>
{
     dc2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dc4:	fed7fae3          	bgeu	a5,a3,db8 <free+0x30>
     dc8:	6398                	ld	a4,0(a5)
     dca:	00e6e463          	bltu	a3,a4,dd2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dce:	fee7eae3          	bltu	a5,a4,dc2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     dd2:	ff852583          	lw	a1,-8(a0)
     dd6:	6390                	ld	a2,0(a5)
     dd8:	02059813          	slli	a6,a1,0x20
     ddc:	01c85713          	srli	a4,a6,0x1c
     de0:	9736                	add	a4,a4,a3
     de2:	fae60de3          	beq	a2,a4,d9c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     de6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     dea:	4790                	lw	a2,8(a5)
     dec:	02061593          	slli	a1,a2,0x20
     df0:	01c5d713          	srli	a4,a1,0x1c
     df4:	973e                	add	a4,a4,a5
     df6:	fae68ae3          	beq	a3,a4,daa <free+0x22>
    p->s.ptr = bp->s.ptr;
     dfa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     dfc:	00001717          	auipc	a4,0x1
     e00:	20f73e23          	sd	a5,540(a4) # 2018 <freep>
}
     e04:	6422                	ld	s0,8(sp)
     e06:	0141                	addi	sp,sp,16
     e08:	8082                	ret

0000000000000e0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e0a:	7139                	addi	sp,sp,-64
     e0c:	fc06                	sd	ra,56(sp)
     e0e:	f822                	sd	s0,48(sp)
     e10:	f426                	sd	s1,40(sp)
     e12:	f04a                	sd	s2,32(sp)
     e14:	ec4e                	sd	s3,24(sp)
     e16:	e852                	sd	s4,16(sp)
     e18:	e456                	sd	s5,8(sp)
     e1a:	e05a                	sd	s6,0(sp)
     e1c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e1e:	02051493          	slli	s1,a0,0x20
     e22:	9081                	srli	s1,s1,0x20
     e24:	04bd                	addi	s1,s1,15
     e26:	8091                	srli	s1,s1,0x4
     e28:	0014899b          	addiw	s3,s1,1
     e2c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     e2e:	00001517          	auipc	a0,0x1
     e32:	1ea53503          	ld	a0,490(a0) # 2018 <freep>
     e36:	c515                	beqz	a0,e62 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e3a:	4798                	lw	a4,8(a5)
     e3c:	02977f63          	bgeu	a4,s1,e7a <malloc+0x70>
     e40:	8a4e                	mv	s4,s3
     e42:	0009871b          	sext.w	a4,s3
     e46:	6685                	lui	a3,0x1
     e48:	00d77363          	bgeu	a4,a3,e4e <malloc+0x44>
     e4c:	6a05                	lui	s4,0x1
     e4e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     e52:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     e56:	00001917          	auipc	s2,0x1
     e5a:	1c290913          	addi	s2,s2,450 # 2018 <freep>
  if(p == (char*)-1)
     e5e:	5afd                	li	s5,-1
     e60:	a895                	j	ed4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
     e62:	00001797          	auipc	a5,0x1
     e66:	1ce78793          	addi	a5,a5,462 # 2030 <base>
     e6a:	00001717          	auipc	a4,0x1
     e6e:	1af73723          	sd	a5,430(a4) # 2018 <freep>
     e72:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     e74:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     e78:	b7e1                	j	e40 <malloc+0x36>
      if(p->s.size == nunits)
     e7a:	02e48c63          	beq	s1,a4,eb2 <malloc+0xa8>
        p->s.size -= nunits;
     e7e:	4137073b          	subw	a4,a4,s3
     e82:	c798                	sw	a4,8(a5)
        p += p->s.size;
     e84:	02071693          	slli	a3,a4,0x20
     e88:	01c6d713          	srli	a4,a3,0x1c
     e8c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     e8e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     e92:	00001717          	auipc	a4,0x1
     e96:	18a73323          	sd	a0,390(a4) # 2018 <freep>
      return (void*)(p + 1);
     e9a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
     e9e:	70e2                	ld	ra,56(sp)
     ea0:	7442                	ld	s0,48(sp)
     ea2:	74a2                	ld	s1,40(sp)
     ea4:	7902                	ld	s2,32(sp)
     ea6:	69e2                	ld	s3,24(sp)
     ea8:	6a42                	ld	s4,16(sp)
     eaa:	6aa2                	ld	s5,8(sp)
     eac:	6b02                	ld	s6,0(sp)
     eae:	6121                	addi	sp,sp,64
     eb0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
     eb2:	6398                	ld	a4,0(a5)
     eb4:	e118                	sd	a4,0(a0)
     eb6:	bff1                	j	e92 <malloc+0x88>
  hp->s.size = nu;
     eb8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     ebc:	0541                	addi	a0,a0,16
     ebe:	00000097          	auipc	ra,0x0
     ec2:	eca080e7          	jalr	-310(ra) # d88 <free>
  return freep;
     ec6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     eca:	d971                	beqz	a0,e9e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ecc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     ece:	4798                	lw	a4,8(a5)
     ed0:	fa9775e3          	bgeu	a4,s1,e7a <malloc+0x70>
    if(p == freep)
     ed4:	00093703          	ld	a4,0(s2)
     ed8:	853e                	mv	a0,a5
     eda:	fef719e3          	bne	a4,a5,ecc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
     ede:	8552                	mv	a0,s4
     ee0:	00000097          	auipc	ra,0x0
     ee4:	b60080e7          	jalr	-1184(ra) # a40 <sbrk>
  if(p == (char*)-1)
     ee8:	fd5518e3          	bne	a0,s5,eb8 <malloc+0xae>
        return 0;
     eec:	4501                	li	a0,0
     eee:	bf45                	j	e9e <malloc+0x94>

0000000000000ef0 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     ef0:	1141                	addi	sp,sp,-16
     ef2:	e406                	sd	ra,8(sp)
     ef4:	e022                	sd	s0,0(sp)
     ef6:	0800                	addi	s0,sp,16
  thread_exit(status);
     ef8:	00000097          	auipc	ra,0x0
     efc:	b78080e7          	jalr	-1160(ra) # a70 <thread_exit>
}
     f00:	60a2                	ld	ra,8(sp)
     f02:	6402                	ld	s0,0(sp)
     f04:	0141                	addi	sp,sp,16
     f06:	8082                	ret

0000000000000f08 <free_stacks>:
int free_stacks() {
     f08:	7179                	addi	sp,sp,-48
     f0a:	f406                	sd	ra,40(sp)
     f0c:	f022                	sd	s0,32(sp)
     f0e:	ec26                	sd	s1,24(sp)
     f10:	e84a                	sd	s2,16(sp)
     f12:	e44e                	sd	s3,8(sp)
     f14:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f16:	00001797          	auipc	a5,0x1
     f1a:	1127a783          	lw	a5,274(a5) # 2028 <num_threads>
     f1e:	02f05c63          	blez	a5,f56 <free_stacks+0x4e>
     f22:	4481                	li	s1,0
    free(stacks[i]);
     f24:	00001997          	auipc	s3,0x1
     f28:	0fc98993          	addi	s3,s3,252 # 2020 <stacks>
  for (int i = 0; i < num_threads; i++) {
     f2c:	00001917          	auipc	s2,0x1
     f30:	0fc90913          	addi	s2,s2,252 # 2028 <num_threads>
    free(stacks[i]);
     f34:	0009b783          	ld	a5,0(s3)
     f38:	00349713          	slli	a4,s1,0x3
     f3c:	97ba                	add	a5,a5,a4
     f3e:	6388                	ld	a0,0(a5)
     f40:	00000097          	auipc	ra,0x0
     f44:	e48080e7          	jalr	-440(ra) # d88 <free>
  for (int i = 0; i < num_threads; i++) {
     f48:	0485                	addi	s1,s1,1
     f4a:	00092703          	lw	a4,0(s2)
     f4e:	0004879b          	sext.w	a5,s1
     f52:	fee7c1e3          	blt	a5,a4,f34 <free_stacks+0x2c>
  free(stacks);
     f56:	00001497          	auipc	s1,0x1
     f5a:	0ca48493          	addi	s1,s1,202 # 2020 <stacks>
     f5e:	6088                	ld	a0,0(s1)
     f60:	00000097          	auipc	ra,0x0
     f64:	e28080e7          	jalr	-472(ra) # d88 <free>
  stacks = 0;
     f68:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     f6c:	00001797          	auipc	a5,0x1
     f70:	0a07ae23          	sw	zero,188(a5) # 2028 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     f74:	47a1                	li	a5,8
     f76:	00001717          	auipc	a4,0x1
     f7a:	08f72923          	sw	a5,146(a4) # 2008 <max_stacks>
  threads_done = 0;
     f7e:	00001797          	auipc	a5,0x1
     f82:	0a07a723          	sw	zero,174(a5) # 202c <threads_done>
}
     f86:	4501                	li	a0,0
     f88:	70a2                	ld	ra,40(sp)
     f8a:	7402                	ld	s0,32(sp)
     f8c:	64e2                	ld	s1,24(sp)
     f8e:	6942                	ld	s2,16(sp)
     f90:	69a2                	ld	s3,8(sp)
     f92:	6145                	addi	sp,sp,48
     f94:	8082                	ret

0000000000000f96 <expand_num_threads>:
int expand_num_threads() {
     f96:	1101                	addi	sp,sp,-32
     f98:	ec06                	sd	ra,24(sp)
     f9a:	e822                	sd	s0,16(sp)
     f9c:	e426                	sd	s1,8(sp)
     f9e:	e04a                	sd	s2,0(sp)
     fa0:	1000                	addi	s0,sp,32
  max_stacks *= 2;
     fa2:	00001797          	auipc	a5,0x1
     fa6:	06678793          	addi	a5,a5,102 # 2008 <max_stacks>
     faa:	4388                	lw	a0,0(a5)
     fac:	0015151b          	slliw	a0,a0,0x1
     fb0:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
     fb2:	0035151b          	slliw	a0,a0,0x3
     fb6:	00000097          	auipc	ra,0x0
     fba:	e54080e7          	jalr	-428(ra) # e0a <malloc>
     fbe:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
     fc0:	00001617          	auipc	a2,0x1
     fc4:	06862603          	lw	a2,104(a2) # 2028 <num_threads>
     fc8:	00001497          	auipc	s1,0x1
     fcc:	05848493          	addi	s1,s1,88 # 2020 <stacks>
     fd0:	0036161b          	slliw	a2,a2,0x3
     fd4:	608c                	ld	a1,0(s1)
     fd6:	00000097          	auipc	ra,0x0
     fda:	930080e7          	jalr	-1744(ra) # 906 <memmove>
  free(stacks);
     fde:	6088                	ld	a0,0(s1)
     fe0:	00000097          	auipc	ra,0x0
     fe4:	da8080e7          	jalr	-600(ra) # d88 <free>
  stacks = new_stacks;
     fe8:	0124b023          	sd	s2,0(s1)
}
     fec:	4501                	li	a0,0
     fee:	60e2                	ld	ra,24(sp)
     ff0:	6442                	ld	s0,16(sp)
     ff2:	64a2                	ld	s1,8(sp)
     ff4:	6902                	ld	s2,0(sp)
     ff6:	6105                	addi	sp,sp,32
     ff8:	8082                	ret

0000000000000ffa <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
     ffa:	7179                	addi	sp,sp,-48
     ffc:	f406                	sd	ra,40(sp)
     ffe:	f022                	sd	s0,32(sp)
    1000:	ec26                	sd	s1,24(sp)
    1002:	e84a                	sd	s2,16(sp)
    1004:	e44e                	sd	s3,8(sp)
    1006:	1800                	addi	s0,sp,48
    1008:	892a                	mv	s2,a0
    100a:	89ae                	mv	s3,a1
  if (stacks == 0) {
    100c:	00001797          	auipc	a5,0x1
    1010:	0147b783          	ld	a5,20(a5) # 2020 <stacks>
    1014:	c3d1                	beqz	a5,1098 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1016:	00001797          	auipc	a5,0x1
    101a:	ff27a783          	lw	a5,-14(a5) # 2008 <max_stacks>
    101e:	00001717          	auipc	a4,0x1
    1022:	00a72703          	lw	a4,10(a4) # 2028 <num_threads>
    1026:	00f71a63          	bne	a4,a5,103a <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
    102a:	04000713          	li	a4,64
    102e:	08e78463          	beq	a5,a4,10b6 <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    1032:	00000097          	auipc	ra,0x0
    1036:	f64080e7          	jalr	-156(ra) # f96 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    103a:	6505                	lui	a0,0x1
    103c:	00000097          	auipc	ra,0x0
    1040:	dce080e7          	jalr	-562(ra) # e0a <malloc>
    1044:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    1046:	00001717          	auipc	a4,0x1
    104a:	fe272703          	lw	a4,-30(a4) # 2028 <num_threads>
    104e:	070e                	slli	a4,a4,0x3
    1050:	00001797          	auipc	a5,0x1
    1054:	fd07b783          	ld	a5,-48(a5) # 2020 <stacks>
    1058:	97ba                	add	a5,a5,a4
    105a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    105c:	00000697          	auipc	a3,0x0
    1060:	e9468693          	addi	a3,a3,-364 # ef0 <ithread_exit>
    1064:	862a                	mv	a2,a0
    1066:	85ce                	mv	a1,s3
    1068:	854a                	mv	a0,s2
    106a:	00000097          	auipc	ra,0x0
    106e:	9f6080e7          	jalr	-1546(ra) # a60 <create_thread>
    1072:	892a                	mv	s2,a0
  if (res != -1) {
    1074:	57fd                	li	a5,-1
    1076:	04f50a63          	beq	a0,a5,10ca <ithread_create+0xd0>
    num_threads++;
    107a:	00001717          	auipc	a4,0x1
    107e:	fae70713          	addi	a4,a4,-82 # 2028 <num_threads>
    1082:	431c                	lw	a5,0(a4)
    1084:	2785                	addiw	a5,a5,1
    1086:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    1088:	854a                	mv	a0,s2
    108a:	70a2                	ld	ra,40(sp)
    108c:	7402                	ld	s0,32(sp)
    108e:	64e2                	ld	s1,24(sp)
    1090:	6942                	ld	s2,16(sp)
    1092:	69a2                	ld	s3,8(sp)
    1094:	6145                	addi	sp,sp,48
    1096:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    1098:	00001517          	auipc	a0,0x1
    109c:	f7052503          	lw	a0,-144(a0) # 2008 <max_stacks>
    10a0:	0035151b          	slliw	a0,a0,0x3
    10a4:	00000097          	auipc	ra,0x0
    10a8:	d66080e7          	jalr	-666(ra) # e0a <malloc>
    10ac:	00001797          	auipc	a5,0x1
    10b0:	f6a7ba23          	sd	a0,-140(a5) # 2020 <stacks>
    10b4:	b78d                	j	1016 <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
    10b6:	00000517          	auipc	a0,0x0
    10ba:	52a50513          	addi	a0,a0,1322 # 15e0 <digits+0x18>
    10be:	00000097          	auipc	ra,0x0
    10c2:	c94080e7          	jalr	-876(ra) # d52 <printf>
      return -1;
    10c6:	597d                	li	s2,-1
    10c8:	b7c1                	j	1088 <ithread_create+0x8e>
    free(stack_ptr);
    10ca:	8526                	mv	a0,s1
    10cc:	00000097          	auipc	ra,0x0
    10d0:	cbc080e7          	jalr	-836(ra) # d88 <free>
    stacks[num_threads] = 0;
    10d4:	00001717          	auipc	a4,0x1
    10d8:	f5472703          	lw	a4,-172(a4) # 2028 <num_threads>
    10dc:	070e                	slli	a4,a4,0x3
    10de:	00001797          	auipc	a5,0x1
    10e2:	f427b783          	ld	a5,-190(a5) # 2020 <stacks>
    10e6:	97ba                	add	a5,a5,a4
    10e8:	0007b023          	sd	zero,0(a5)
    10ec:	bf71                	j	1088 <ithread_create+0x8e>

00000000000010ee <ithread_join>:

int ithread_join(int thread_id) {
    10ee:	1101                	addi	sp,sp,-32
    10f0:	ec06                	sd	ra,24(sp)
    10f2:	e822                	sd	s0,16(sp)
    10f4:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    10f6:	fec40593          	addi	a1,s0,-20
    10fa:	00000097          	auipc	ra,0x0
    10fe:	96e080e7          	jalr	-1682(ra) # a68 <join_thread>
  threads_done++;
    1102:	00001717          	auipc	a4,0x1
    1106:	f2a70713          	addi	a4,a4,-214 # 202c <threads_done>
    110a:	431c                	lw	a5,0(a4)
    110c:	2785                	addiw	a5,a5,1
    110e:	0007869b          	sext.w	a3,a5
    1112:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1114:	00001797          	auipc	a5,0x1
    1118:	f147a783          	lw	a5,-236(a5) # 2028 <num_threads>
    111c:	00d78863          	beq	a5,a3,112c <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    1120:	fec42503          	lw	a0,-20(s0)
    1124:	60e2                	ld	ra,24(sp)
    1126:	6442                	ld	s0,16(sp)
    1128:	6105                	addi	sp,sp,32
    112a:	8082                	ret
    free_stacks();
    112c:	00000097          	auipc	ra,0x0
    1130:	ddc080e7          	jalr	-548(ra) # f08 <free_stacks>
    1134:	b7f5                	j	1120 <ithread_join+0x32>
