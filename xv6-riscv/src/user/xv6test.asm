
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
      48:	b12080e7          	jalr	-1262(ra) # b56 <sleep>
  printf("Test 6 FAILED: exit_all failed\n");
      4c:	00001517          	auipc	a0,0x1
      50:	26450513          	addi	a0,a0,612 # 12b0 <ithread_join+0x56>
      54:	00001097          	auipc	ra,0x1
      58:	e48080e7          	jalr	-440(ra) # e9c <printf>
}
      5c:	4501                	li	a0,0
      5e:	60a2                	ld	ra,8(sp)
      60:	6402                	ld	s0,0(sp)
      62:	0141                	addi	sp,sp,16
      64:	8082                	ret
    sleep(5);
      66:	4515                	li	a0,5
      68:	00001097          	auipc	ra,0x1
      6c:	aee080e7          	jalr	-1298(ra) # b56 <sleep>
    exit(0);
      70:	4501                	li	a0,0
      72:	00001097          	auipc	ra,0x1
      76:	a54080e7          	jalr	-1452(ra) # ac6 <exit>

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
      8c:	ace080e7          	jalr	-1330(ra) # b56 <sleep>
  int val = p[0]; // should be 42 before deallocation
      90:	00002497          	auipc	s1,0x2
      94:	f7048493          	addi	s1,s1,-144 # 2000 <p>
      98:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
      9a:	438c                	lw	a1,0(a5)
      9c:	00001517          	auipc	a0,0x1
      a0:	23450513          	addi	a0,a0,564 # 12d0 <ithread_join+0x76>
      a4:	00001097          	auipc	ra,0x1
      a8:	df8080e7          	jalr	-520(ra) # e9c <printf>
  sleep(40); // wait for deallocation
      ac:	02800513          	li	a0,40
      b0:	00001097          	auipc	ra,0x1
      b4:	aa6080e7          	jalr	-1370(ra) # b56 <sleep>
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
      b8:	6098                	ld	a4,0(s1)
      ba:	37ab77b7          	lui	a5,0x37ab7
      be:	078a                	slli	a5,a5,0x2
      c0:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4ebf>
      c4:	04f70763          	beq	a4,a5,112 <prop_mem_dealloc2+0x98>
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
      c8:	00001517          	auipc	a0,0x1
      cc:	24050513          	addi	a0,a0,576 # 1308 <ithread_join+0xae>
      d0:	00001097          	auipc	ra,0x1
      d4:	dcc080e7          	jalr	-564(ra) # e9c <printf>
  fail = p[0]; // this should ideally trap or fail
      d8:	00002797          	auipc	a5,0x2
      dc:	f287b783          	ld	a5,-216(a5) # 2000 <p>
      e0:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e2:	85a6                	mv	a1,s1
      e4:	00001517          	auipc	a0,0x1
      e8:	25450513          	addi	a0,a0,596 # 1338 <ithread_join+0xde>
      ec:	00001097          	auipc	ra,0x1
      f0:	db0080e7          	jalr	-592(ra) # e9c <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f4:	85a6                	mv	a1,s1
      f6:	00001517          	auipc	a0,0x1
      fa:	25a50513          	addi	a0,a0,602 # 1350 <ithread_join+0xf6>
      fe:	00001097          	auipc	ra,0x1
     102:	d9e080e7          	jalr	-610(ra) # e9c <printf>
}
     106:	4501                	li	a0,0
     108:	60e2                	ld	ra,24(sp)
     10a:	6442                	ld	s0,16(sp)
     10c:	64a2                	ld	s1,8(sp)
     10e:	6105                	addi	sp,sp,32
     110:	8082                	ret
    printf("FAIL: p is invalid\n");
     112:	00001517          	auipc	a0,0x1
     116:	1de50513          	addi	a0,a0,478 # 12f0 <ithread_join+0x96>
     11a:	00001097          	auipc	ra,0x1
     11e:	d82080e7          	jalr	-638(ra) # e9c <printf>
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
     134:	a26080e7          	jalr	-1498(ra) # b56 <sleep>
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
     162:	24250513          	addi	a0,a0,578 # 13a0 <ithread_join+0x146>
     166:	00001097          	auipc	ra,0x1
     16a:	d36080e7          	jalr	-714(ra) # e9c <printf>
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
     17c:	20850513          	addi	a0,a0,520 # 1380 <ithread_join+0x126>
     180:	00001097          	auipc	ra,0x1
     184:	d1c080e7          	jalr	-740(ra) # e9c <printf>
    return 0;
     188:	b7dd                	j	16e <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	20e50513          	addi	a0,a0,526 # 1398 <ithread_join+0x13e>
     192:	00001097          	auipc	ra,0x1
     196:	d0a080e7          	jalr	-758(ra) # e9c <printf>
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
     1ac:	9a6080e7          	jalr	-1626(ra) # b4e <sbrk>
     1b0:	00002497          	auipc	s1,0x2
     1b4:	e5048493          	addi	s1,s1,-432 # 2000 <p>
     1b8:	e088                	sd	a0,0(s1)
  p[0] = 42;
     1ba:	02a00793          	li	a5,42
     1be:	c11c                	sw	a5,0(a0)
  sleep(80);              // allow thread 2 to read
     1c0:	05000513          	li	a0,80
     1c4:	00001097          	auipc	ra,0x1
     1c8:	992080e7          	jalr	-1646(ra) # b56 <sleep>
  p = (int *)sbrk(-4096);            // deallocate
     1cc:	757d                	lui	a0,0xfffff
     1ce:	00001097          	auipc	ra,0x1
     1d2:	980080e7          	jalr	-1664(ra) # b4e <sbrk>
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
     1f2:	960080e7          	jalr	-1696(ra) # b4e <sbrk>
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
     222:	00052903          	lw	s2,0(a0) # 1000 <malloc+0xac>
  printf("Thread %d is running\n", val);
     226:	85ca                	mv	a1,s2
     228:	00001517          	auipc	a0,0x1
     22c:	1a850513          	addi	a0,a0,424 # 13d0 <ithread_join+0x176>
     230:	00001097          	auipc	ra,0x1
     234:	c6c080e7          	jalr	-916(ra) # e9c <printf>
  free(arg);
     238:	8526                	mv	a0,s1
     23a:	00001097          	auipc	ra,0x1
     23e:	c98080e7          	jalr	-872(ra) # ed2 <free>
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
     260:	df8080e7          	jalr	-520(ra) # 1054 <ithread_exit>
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
     27a:	17250513          	addi	a0,a0,370 # 13e8 <ithread_join+0x18e>
     27e:	00001097          	auipc	ra,0x1
     282:	c1e080e7          	jalr	-994(ra) # e9c <printf>
  int *arg = malloc(sizeof(int));
     286:	4511                	li	a0,4
     288:	00001097          	auipc	ra,0x1
     28c:	ccc080e7          	jalr	-820(ra) # f54 <malloc>
     290:	85aa                	mv	a1,a0
  *arg = 0;
     292:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     296:	00000517          	auipc	a0,0x0
     29a:	f7e50513          	addi	a0,a0,-130 # 214 <thread_func_basic>
     29e:	00001097          	auipc	ra,0x1
     2a2:	ec2080e7          	jalr	-318(ra) # 1160 <ithread_create>
  if (tid < 0) {
     2a6:	02054763          	bltz	a0,2d4 <test_thread_create+0x66>
     2aa:	e426                	sd	s1,8(sp)
     2ac:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2ae:	85aa                	mv	a1,a0
     2b0:	00001517          	auipc	a0,0x1
     2b4:	18050513          	addi	a0,a0,384 # 1430 <ithread_join+0x1d6>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	be4080e7          	jalr	-1052(ra) # e9c <printf>
    ithread_join(tid);
     2c0:	8526                	mv	a0,s1
     2c2:	00001097          	auipc	ra,0x1
     2c6:	f98080e7          	jalr	-104(ra) # 125a <ithread_join>
     2ca:	64a2                	ld	s1,8(sp)
}
     2cc:	60e2                	ld	ra,24(sp)
     2ce:	6442                	ld	s0,16(sp)
     2d0:	6105                	addi	sp,sp,32
     2d2:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d4:	00001517          	auipc	a0,0x1
     2d8:	13450513          	addi	a0,a0,308 # 1408 <ithread_join+0x1ae>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	bc0080e7          	jalr	-1088(ra) # e9c <printf>
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
     2f6:	16e50513          	addi	a0,a0,366 # 1460 <ithread_join+0x206>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	ba2080e7          	jalr	-1118(ra) # e9c <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     302:	4581                	li	a1,0
     304:	00000517          	auipc	a0,0x0
     308:	e9850513          	addi	a0,a0,-360 # 19c <prop_mem_dealloc1>
     30c:	00001097          	auipc	ra,0x1
     310:	e54080e7          	jalr	-428(ra) # 1160 <ithread_create>
     314:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     316:	4581                	li	a1,0
     318:	00000517          	auipc	a0,0x0
     31c:	d6250513          	addi	a0,a0,-670 # 7a <prop_mem_dealloc2>
     320:	00001097          	auipc	ra,0x1
     324:	e40080e7          	jalr	-448(ra) # 1160 <ithread_create>
     328:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32a:	854a                	mv	a0,s2
     32c:	00001097          	auipc	ra,0x1
     330:	f2e080e7          	jalr	-210(ra) # 125a <ithread_join>
  ithread_join(tid2);
     334:	8526                	mv	a0,s1
     336:	00001097          	auipc	ra,0x1
     33a:	f24080e7          	jalr	-220(ra) # 125a <ithread_join>
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
     35a:	12250513          	addi	a0,a0,290 # 1478 <ithread_join+0x21e>
     35e:	00001097          	auipc	ra,0x1
     362:	b3e080e7          	jalr	-1218(ra) # e9c <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     366:	4581                	li	a1,0
     368:	00000517          	auipc	a0,0x0
     36c:	e7c50513          	addi	a0,a0,-388 # 1e4 <prop_mem_alloc1>
     370:	00001097          	auipc	ra,0x1
     374:	df0080e7          	jalr	-528(ra) # 1160 <ithread_create>
     378:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37a:	4581                	li	a1,0
     37c:	00000517          	auipc	a0,0x0
     380:	da850513          	addi	a0,a0,-600 # 124 <prop_mem_alloc2>
     384:	00001097          	auipc	ra,0x1
     388:	ddc080e7          	jalr	-548(ra) # 1160 <ithread_create>
     38c:	84aa                	mv	s1,a0
  ithread_join(tid1);
     38e:	854a                	mv	a0,s2
     390:	00001097          	auipc	ra,0x1
     394:	eca080e7          	jalr	-310(ra) # 125a <ithread_join>
  ithread_join(tid2);
     398:	8526                	mv	a0,s1
     39a:	00001097          	auipc	ra,0x1
     39e:	ec0080e7          	jalr	-320(ra) # 125a <ithread_join>

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
     3ba:	0da50513          	addi	a0,a0,218 # 1490 <ithread_join+0x236>
     3be:	00001097          	auipc	ra,0x1
     3c2:	ade080e7          	jalr	-1314(ra) # e9c <printf>

  int *arg = malloc(sizeof(int));
     3c6:	4511                	li	a0,4
     3c8:	00001097          	auipc	ra,0x1
     3cc:	b8c080e7          	jalr	-1140(ra) # f54 <malloc>
     3d0:	85aa                	mv	a1,a0
  *arg = 100;
     3d2:	06400793          	li	a5,100
     3d6:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3d8:	00000517          	auipc	a0,0x0
     3dc:	e3c50513          	addi	a0,a0,-452 # 214 <thread_func_basic>
     3e0:	00001097          	auipc	ra,0x1
     3e4:	d80080e7          	jalr	-640(ra) # 1160 <ithread_create>

  if (tid < 0) {
     3e8:	02054763          	bltz	a0,416 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ec:	00001097          	auipc	ra,0x1
     3f0:	e6e080e7          	jalr	-402(ra) # 125a <ithread_join>
     3f4:	85aa                	mv	a1,a0
  if (status == 101) {
     3f6:	06500793          	li	a5,101
     3fa:	02f50763          	beq	a0,a5,428 <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     3fe:	00001517          	auipc	a0,0x1
     402:	11250513          	addi	a0,a0,274 # 1510 <ithread_join+0x2b6>
     406:	00001097          	auipc	ra,0x1
     40a:	a96080e7          	jalr	-1386(ra) # e9c <printf>
  }
}
     40e:	60a2                	ld	ra,8(sp)
     410:	6402                	ld	s0,0(sp)
     412:	0141                	addi	sp,sp,16
     414:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     416:	00001517          	auipc	a0,0x1
     41a:	09a50513          	addi	a0,a0,154 # 14b0 <ithread_join+0x256>
     41e:	00001097          	auipc	ra,0x1
     422:	a7e080e7          	jalr	-1410(ra) # e9c <printf>
    return;
     426:	b7e5                	j	40e <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     428:	06500593          	li	a1,101
     42c:	00001517          	auipc	a0,0x1
     430:	0b450513          	addi	a0,a0,180 # 14e0 <ithread_join+0x286>
     434:	00001097          	auipc	ra,0x1
     438:	a68080e7          	jalr	-1432(ra) # e9c <printf>
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
     452:	0ea50513          	addi	a0,a0,234 # 1538 <ithread_join+0x2de>
     456:	00001097          	auipc	ra,0x1
     45a:	a46080e7          	jalr	-1466(ra) # e9c <printf>

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
     480:	ce4080e7          	jalr	-796(ra) # 1160 <ithread_create>
     484:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     488:	0911                	addi	s2,s2,4
     48a:	ff3917e3          	bne	s2,s3,478 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48e:	4088                	lw	a0,0(s1)
     490:	00001097          	auipc	ra,0x1
     494:	dca080e7          	jalr	-566(ra) # 125a <ithread_join>
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
     4b2:	0da50513          	addi	a0,a0,218 # 1588 <ithread_join+0x32e>
     4b6:	00001097          	auipc	ra,0x1
     4ba:	9e6080e7          	jalr	-1562(ra) # e9c <printf>
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
     4d6:	08e50513          	addi	a0,a0,142 # 1560 <ithread_join+0x306>
     4da:	00001097          	auipc	ra,0x1
     4de:	9c2080e7          	jalr	-1598(ra) # e9c <printf>
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
     4f0:	0c450513          	addi	a0,a0,196 # 15b0 <ithread_join+0x356>
     4f4:	00001097          	auipc	ra,0x1
     4f8:	9a8080e7          	jalr	-1624(ra) # e9c <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4fc:	4581                	li	a1,0
     4fe:	00000517          	auipc	a0,0x0
     502:	d5450513          	addi	a0,a0,-684 # 252 <thread_func_exit>
     506:	00001097          	auipc	ra,0x1
     50a:	c5a080e7          	jalr	-934(ra) # 1160 <ithread_create>
  int status = ithread_join(tid);
     50e:	00001097          	auipc	ra,0x1
     512:	d4c080e7          	jalr	-692(ra) # 125a <ithread_join>
     516:	85aa                	mv	a1,a0

  if (status == 0) {
     518:	ed09                	bnez	a0,532 <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     51a:	00001517          	auipc	a0,0x1
     51e:	0be50513          	addi	a0,a0,190 # 15d8 <ithread_join+0x37e>
     522:	00001097          	auipc	ra,0x1
     526:	97a080e7          	jalr	-1670(ra) # e9c <printf>
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
     536:	0e650513          	addi	a0,a0,230 # 1618 <ithread_join+0x3be>
     53a:	00001097          	auipc	ra,0x1
     53e:	962080e7          	jalr	-1694(ra) # e9c <printf>
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
     55e:	0ee50513          	addi	a0,a0,238 # 1648 <ithread_join+0x3ee>
     562:	00001097          	auipc	ra,0x1
     566:	93a080e7          	jalr	-1734(ra) # e9c <printf>
  int *num = malloc(10*sizeof(int));
     56a:	02800513          	li	a0,40
     56e:	00001097          	auipc	ra,0x1
     572:	9e6080e7          	jalr	-1562(ra) # f54 <malloc>
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
     598:	bcc080e7          	jalr	-1076(ra) # 1160 <ithread_create>
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
     5b4:	caa080e7          	jalr	-854(ra) # 125a <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b8:	0491                	addi	s1,s1,4
     5ba:	ff249ae3          	bne	s1,s2,5ae <test_exit_all+0x6a>
  }
  free(num);
     5be:	855e                	mv	a0,s7
     5c0:	00001097          	auipc	ra,0x1
     5c4:	912080e7          	jalr	-1774(ra) # ed2 <free>
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
     5f4:	08850513          	addi	a0,a0,136 # 1678 <ithread_join+0x41e>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	8a4080e7          	jalr	-1884(ra) # e9c <printf>
    exit(1);
     600:	4505                	li	a0,1
     602:	00000097          	auipc	ra,0x0
     606:	4c4080e7          	jalr	1220(ra) # ac6 <exit>
     60a:	e426                	sd	s1,8(sp)
     60c:	84aa                	mv	s1,a0
  }

  int test = atoi(argv[1]);
     60e:	6588                	ld	a0,8(a1)
     610:	00000097          	auipc	ra,0x0
     614:	324080e7          	jalr	804(ra) # 934 <atoi>
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
     636:	0d270713          	addi	a4,a4,210 # 1704 <ithread_join+0x4aa>
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
     68c:	01850513          	addi	a0,a0,24 # 16a0 <ithread_join+0x446>
     690:	00001097          	auipc	ra,0x1
     694:	80c080e7          	jalr	-2036(ra) # e9c <printf>
     698:	a849                	j	72a <main+0x14c>
  }
  }else{
   test_thread_create();
     69a:	00000097          	auipc	ra,0x0
     69e:	bd4080e7          	jalr	-1068(ra) # 26e <test_thread_create>
   printf("\n");
     6a2:	00001517          	auipc	a0,0x1
     6a6:	02650513          	addi	a0,a0,38 # 16c8 <ithread_join+0x46e>
     6aa:	00000097          	auipc	ra,0x0
     6ae:	7f2080e7          	jalr	2034(ra) # e9c <printf>
   test_thread_join();
     6b2:	00000097          	auipc	ra,0x0
     6b6:	cfc080e7          	jalr	-772(ra) # 3ae <test_thread_join>
   printf("\n");
     6ba:	00001517          	auipc	a0,0x1
     6be:	00e50513          	addi	a0,a0,14 # 16c8 <ithread_join+0x46e>
     6c2:	00000097          	auipc	ra,0x0
     6c6:	7da080e7          	jalr	2010(ra) # e9c <printf>
   test_shared_memory();
     6ca:	00000097          	auipc	ra,0x0
     6ce:	d74080e7          	jalr	-652(ra) # 43e <test_shared_memory>
   printf("\n");
     6d2:	00001517          	auipc	a0,0x1
     6d6:	ff650513          	addi	a0,a0,-10 # 16c8 <ithread_join+0x46e>
     6da:	00000097          	auipc	ra,0x0
     6de:	7c2080e7          	jalr	1986(ra) # e9c <printf>
   test_exit();
     6e2:	00000097          	auipc	ra,0x0
     6e6:	e02080e7          	jalr	-510(ra) # 4e4 <test_exit>
   printf("\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	fde50513          	addi	a0,a0,-34 # 16c8 <ithread_join+0x46e>
     6f2:	00000097          	auipc	ra,0x0
     6f6:	7aa080e7          	jalr	1962(ra) # e9c <printf>
   // test_exit_all();
   printf("\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	fce50513          	addi	a0,a0,-50 # 16c8 <ithread_join+0x46e>
     702:	00000097          	auipc	ra,0x0
     706:	79a080e7          	jalr	1946(ra) # e9c <printf>
   test_global_pointer_alloc();
     70a:	00000097          	auipc	ra,0x0
     70e:	c40080e7          	jalr	-960(ra) # 34a <test_global_pointer_alloc>
   printf("\n");
     712:	00001517          	auipc	a0,0x1
     716:	fb650513          	addi	a0,a0,-74 # 16c8 <ithread_join+0x46e>
     71a:	00000097          	auipc	ra,0x0
     71e:	782080e7          	jalr	1922(ra) # e9c <printf>
   test_global_pointer_dealloc();
     722:	00000097          	auipc	ra,0x0
     726:	bc4080e7          	jalr	-1084(ra) # 2e6 <test_global_pointer_dealloc>
  }

  exit(0);
     72a:	4501                	li	a0,0
     72c:	00000097          	auipc	ra,0x0
     730:	39a080e7          	jalr	922(ra) # ac6 <exit>

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
     74a:	380080e7          	jalr	896(ra) # ac6 <exit>

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
     83c:	2a6080e7          	jalr	678(ra) # ade <read>
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

000000000000087a <fgetstdin>:

int
fgetstdin(char *buf, int size) {
     87a:	711d                	addi	sp,sp,-96
     87c:	ec86                	sd	ra,88(sp)
     87e:	e8a2                	sd	s0,80(sp)
     880:	e4a6                	sd	s1,72(sp)
     882:	e0ca                	sd	s2,64(sp)
     884:	fc4e                	sd	s3,56(sp)
     886:	f852                	sd	s4,48(sp)
     888:	f456                	sd	s5,40(sp)
     88a:	f05a                	sd	s6,32(sp)
     88c:	ec5e                	sd	s7,24(sp)
     88e:	1080                	addi	s0,sp,96
     890:	8baa                	mv	s7,a0
     892:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
     894:	892a                	mv	s2,a0
     896:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     898:	4aa9                	li	s5,10
     89a:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
     89c:	8a26                	mv	s4,s1
     89e:	2485                	addiw	s1,s1,1
     8a0:	0334d863          	bge	s1,s3,8d0 <fgetstdin+0x56>
    cc = read(0, &c, 1);
     8a4:	4605                	li	a2,1
     8a6:	faf40593          	addi	a1,s0,-81
     8aa:	4501                	li	a0,0
     8ac:	00000097          	auipc	ra,0x0
     8b0:	232080e7          	jalr	562(ra) # ade <read>
    if(cc < 1)
     8b4:	00a05e63          	blez	a0,8d0 <fgetstdin+0x56>
    buf[i++] = c;
     8b8:	faf44783          	lbu	a5,-81(s0)
     8bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     8c0:	01578763          	beq	a5,s5,8ce <fgetstdin+0x54>
     8c4:	0905                	addi	s2,s2,1
     8c6:	fd679be3          	bne	a5,s6,89c <fgetstdin+0x22>
    buf[i++] = c;
     8ca:	8a26                	mv	s4,s1
     8cc:	a011                	j	8d0 <fgetstdin+0x56>
     8ce:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
     8d0:	9bd2                	add	s7,s7,s4
     8d2:	000b8023          	sb	zero,0(s7)
  return i;
}
     8d6:	8552                	mv	a0,s4
     8d8:	60e6                	ld	ra,88(sp)
     8da:	6446                	ld	s0,80(sp)
     8dc:	64a6                	ld	s1,72(sp)
     8de:	6906                	ld	s2,64(sp)
     8e0:	79e2                	ld	s3,56(sp)
     8e2:	7a42                	ld	s4,48(sp)
     8e4:	7aa2                	ld	s5,40(sp)
     8e6:	7b02                	ld	s6,32(sp)
     8e8:	6be2                	ld	s7,24(sp)
     8ea:	6125                	addi	sp,sp,96
     8ec:	8082                	ret

00000000000008ee <stat>:

int
stat(const char *n, struct stat *st)
{
     8ee:	1101                	addi	sp,sp,-32
     8f0:	ec06                	sd	ra,24(sp)
     8f2:	e822                	sd	s0,16(sp)
     8f4:	e04a                	sd	s2,0(sp)
     8f6:	1000                	addi	s0,sp,32
     8f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     8fa:	4581                	li	a1,0
     8fc:	00000097          	auipc	ra,0x0
     900:	20a080e7          	jalr	522(ra) # b06 <open>
  if(fd < 0)
     904:	02054663          	bltz	a0,930 <stat+0x42>
     908:	e426                	sd	s1,8(sp)
     90a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     90c:	85ca                	mv	a1,s2
     90e:	00000097          	auipc	ra,0x0
     912:	210080e7          	jalr	528(ra) # b1e <fstat>
     916:	892a                	mv	s2,a0
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	00000097          	auipc	ra,0x0
     91e:	1d4080e7          	jalr	468(ra) # aee <close>
  return r;
     922:	64a2                	ld	s1,8(sp)
}
     924:	854a                	mv	a0,s2
     926:	60e2                	ld	ra,24(sp)
     928:	6442                	ld	s0,16(sp)
     92a:	6902                	ld	s2,0(sp)
     92c:	6105                	addi	sp,sp,32
     92e:	8082                	ret
    return -1;
     930:	597d                	li	s2,-1
     932:	bfcd                	j	924 <stat+0x36>

0000000000000934 <atoi>:

int
atoi(const char *s)
{
     934:	1141                	addi	sp,sp,-16
     936:	e422                	sd	s0,8(sp)
     938:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     93a:	00054683          	lbu	a3,0(a0)
     93e:	fd06879b          	addiw	a5,a3,-48
     942:	0ff7f793          	zext.b	a5,a5
     946:	4625                	li	a2,9
     948:	02f66863          	bltu	a2,a5,978 <atoi+0x44>
     94c:	872a                	mv	a4,a0
  n = 0;
     94e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     950:	0705                	addi	a4,a4,1
     952:	0025179b          	slliw	a5,a0,0x2
     956:	9fa9                	addw	a5,a5,a0
     958:	0017979b          	slliw	a5,a5,0x1
     95c:	9fb5                	addw	a5,a5,a3
     95e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     962:	00074683          	lbu	a3,0(a4)
     966:	fd06879b          	addiw	a5,a3,-48
     96a:	0ff7f793          	zext.b	a5,a5
     96e:	fef671e3          	bgeu	a2,a5,950 <atoi+0x1c>
  return n;
}
     972:	6422                	ld	s0,8(sp)
     974:	0141                	addi	sp,sp,16
     976:	8082                	ret
  n = 0;
     978:	4501                	li	a0,0
     97a:	bfe5                	j	972 <atoi+0x3e>

000000000000097c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     97c:	1141                	addi	sp,sp,-16
     97e:	e422                	sd	s0,8(sp)
     980:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     982:	02b57463          	bgeu	a0,a1,9aa <memmove+0x2e>
    while(n-- > 0)
     986:	00c05f63          	blez	a2,9a4 <memmove+0x28>
     98a:	1602                	slli	a2,a2,0x20
     98c:	9201                	srli	a2,a2,0x20
     98e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     992:	872a                	mv	a4,a0
      *dst++ = *src++;
     994:	0585                	addi	a1,a1,1
     996:	0705                	addi	a4,a4,1
     998:	fff5c683          	lbu	a3,-1(a1)
     99c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     9a0:	fef71ae3          	bne	a4,a5,994 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     9a4:	6422                	ld	s0,8(sp)
     9a6:	0141                	addi	sp,sp,16
     9a8:	8082                	ret
    dst += n;
     9aa:	00c50733          	add	a4,a0,a2
    src += n;
     9ae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     9b0:	fec05ae3          	blez	a2,9a4 <memmove+0x28>
     9b4:	fff6079b          	addiw	a5,a2,-1
     9b8:	1782                	slli	a5,a5,0x20
     9ba:	9381                	srli	a5,a5,0x20
     9bc:	fff7c793          	not	a5,a5
     9c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     9c2:	15fd                	addi	a1,a1,-1
     9c4:	177d                	addi	a4,a4,-1
     9c6:	0005c683          	lbu	a3,0(a1)
     9ca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     9ce:	fee79ae3          	bne	a5,a4,9c2 <memmove+0x46>
     9d2:	bfc9                	j	9a4 <memmove+0x28>

00000000000009d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     9d4:	1141                	addi	sp,sp,-16
     9d6:	e422                	sd	s0,8(sp)
     9d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     9da:	ca05                	beqz	a2,a0a <memcmp+0x36>
     9dc:	fff6069b          	addiw	a3,a2,-1
     9e0:	1682                	slli	a3,a3,0x20
     9e2:	9281                	srli	a3,a3,0x20
     9e4:	0685                	addi	a3,a3,1
     9e6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     9e8:	00054783          	lbu	a5,0(a0)
     9ec:	0005c703          	lbu	a4,0(a1)
     9f0:	00e79863          	bne	a5,a4,a00 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     9f4:	0505                	addi	a0,a0,1
    p2++;
     9f6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     9f8:	fed518e3          	bne	a0,a3,9e8 <memcmp+0x14>
  }
  return 0;
     9fc:	4501                	li	a0,0
     9fe:	a019                	j	a04 <memcmp+0x30>
      return *p1 - *p2;
     a00:	40e7853b          	subw	a0,a5,a4
}
     a04:	6422                	ld	s0,8(sp)
     a06:	0141                	addi	sp,sp,16
     a08:	8082                	ret
  return 0;
     a0a:	4501                	li	a0,0
     a0c:	bfe5                	j	a04 <memcmp+0x30>

0000000000000a0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     a0e:	1141                	addi	sp,sp,-16
     a10:	e406                	sd	ra,8(sp)
     a12:	e022                	sd	s0,0(sp)
     a14:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     a16:	00000097          	auipc	ra,0x0
     a1a:	f66080e7          	jalr	-154(ra) # 97c <memmove>
}
     a1e:	60a2                	ld	ra,8(sp)
     a20:	6402                	ld	s0,0(sp)
     a22:	0141                	addi	sp,sp,16
     a24:	8082                	ret

0000000000000a26 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
     a26:	1141                	addi	sp,sp,-16
     a28:	e422                	sd	s0,8(sp)
     a2a:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
     a2c:	00054783          	lbu	a5,0(a0)
     a30:	cfbd                	beqz	a5,aae <inet_addr+0x88>
  int dots = 0;
     a32:	4801                	li	a6,0
  int digits = 0;
     a34:	4601                	li	a2,0
  int octet = 0;
     a36:	4681                	li	a3,0
  uint result = 0;
     a38:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
     a3a:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
     a3c:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
     a40:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
     a42:	4301                	li	t1,0
      if (octet > 255)
     a44:	0ff00e13          	li	t3,255
     a48:	a015                	j	a6c <inet_addr+0x46>
    } else if (*s == '.') {
     a4a:	07d79463          	bne	a5,t4,ab2 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
     a4e:	c625                	beqz	a2,ab6 <inet_addr+0x90>
     a50:	07e80563          	beq	a6,t5,aba <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
     a54:	0085959b          	slliw	a1,a1,0x8
     a58:	8ecd                	or	a3,a3,a1
     a5a:	0006859b          	sext.w	a1,a3
      dots++;
     a5e:	2805                	addiw	a6,a6,1
      digits = 0;
     a60:	861a                	mv	a2,t1
      octet = 0;
     a62:	869a                	mv	a3,t1
  for (; *s; s++) {
     a64:	0505                	addi	a0,a0,1
     a66:	00054783          	lbu	a5,0(a0)
     a6a:	c79d                	beqz	a5,a98 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
     a6c:	fd07871b          	addiw	a4,a5,-48
     a70:	0ff77713          	zext.b	a4,a4
     a74:	fce8ebe3          	bltu	a7,a4,a4a <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
     a78:	0026971b          	slliw	a4,a3,0x2
     a7c:	9f35                	addw	a4,a4,a3
     a7e:	0017171b          	slliw	a4,a4,0x1
     a82:	fd07879b          	addiw	a5,a5,-48
     a86:	00e786bb          	addw	a3,a5,a4
      digits++;
     a8a:	2605                	addiw	a2,a2,1
      if (octet > 255)
     a8c:	fcde5ce3          	bge	t3,a3,a64 <inet_addr+0x3e>
        return 0;
     a90:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
     a92:	6422                	ld	s0,8(sp)
     a94:	0141                	addi	sp,sp,16
     a96:	8082                	ret
    return 0;
     a98:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
     a9a:	de65                	beqz	a2,a92 <inet_addr+0x6c>
     a9c:	478d                	li	a5,3
     a9e:	fef81ae3          	bne	a6,a5,a92 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
     aa2:	0085959b          	slliw	a1,a1,0x8
     aa6:	8ecd                	or	a3,a3,a1
     aa8:	0006851b          	sext.w	a0,a3
  return result;
     aac:	b7dd                	j	a92 <inet_addr+0x6c>
    return 0;
     aae:	4501                	li	a0,0
     ab0:	b7cd                	j	a92 <inet_addr+0x6c>
      return 0;
     ab2:	4501                	li	a0,0
     ab4:	bff9                	j	a92 <inet_addr+0x6c>
        return 0;
     ab6:	4501                	li	a0,0
     ab8:	bfe9                	j	a92 <inet_addr+0x6c>
     aba:	4501                	li	a0,0
     abc:	bfd9                	j	a92 <inet_addr+0x6c>

0000000000000abe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     abe:	4885                	li	a7,1
 ecall
     ac0:	00000073          	ecall
 ret
     ac4:	8082                	ret

0000000000000ac6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ac6:	4889                	li	a7,2
 ecall
     ac8:	00000073          	ecall
 ret
     acc:	8082                	ret

0000000000000ace <wait>:
.global wait
wait:
 li a7, SYS_wait
     ace:	488d                	li	a7,3
 ecall
     ad0:	00000073          	ecall
 ret
     ad4:	8082                	ret

0000000000000ad6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ad6:	4891                	li	a7,4
 ecall
     ad8:	00000073          	ecall
 ret
     adc:	8082                	ret

0000000000000ade <read>:
.global read
read:
 li a7, SYS_read
     ade:	4895                	li	a7,5
 ecall
     ae0:	00000073          	ecall
 ret
     ae4:	8082                	ret

0000000000000ae6 <write>:
.global write
write:
 li a7, SYS_write
     ae6:	48c1                	li	a7,16
 ecall
     ae8:	00000073          	ecall
 ret
     aec:	8082                	ret

0000000000000aee <close>:
.global close
close:
 li a7, SYS_close
     aee:	48d5                	li	a7,21
 ecall
     af0:	00000073          	ecall
 ret
     af4:	8082                	ret

0000000000000af6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     af6:	4899                	li	a7,6
 ecall
     af8:	00000073          	ecall
 ret
     afc:	8082                	ret

0000000000000afe <exec>:
.global exec
exec:
 li a7, SYS_exec
     afe:	489d                	li	a7,7
 ecall
     b00:	00000073          	ecall
 ret
     b04:	8082                	ret

0000000000000b06 <open>:
.global open
open:
 li a7, SYS_open
     b06:	48bd                	li	a7,15
 ecall
     b08:	00000073          	ecall
 ret
     b0c:	8082                	ret

0000000000000b0e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b0e:	48c5                	li	a7,17
 ecall
     b10:	00000073          	ecall
 ret
     b14:	8082                	ret

0000000000000b16 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b16:	48c9                	li	a7,18
 ecall
     b18:	00000073          	ecall
 ret
     b1c:	8082                	ret

0000000000000b1e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b1e:	48a1                	li	a7,8
 ecall
     b20:	00000073          	ecall
 ret
     b24:	8082                	ret

0000000000000b26 <link>:
.global link
link:
 li a7, SYS_link
     b26:	48cd                	li	a7,19
 ecall
     b28:	00000073          	ecall
 ret
     b2c:	8082                	ret

0000000000000b2e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b2e:	48d1                	li	a7,20
 ecall
     b30:	00000073          	ecall
 ret
     b34:	8082                	ret

0000000000000b36 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b36:	48a5                	li	a7,9
 ecall
     b38:	00000073          	ecall
 ret
     b3c:	8082                	ret

0000000000000b3e <dup>:
.global dup
dup:
 li a7, SYS_dup
     b3e:	48a9                	li	a7,10
 ecall
     b40:	00000073          	ecall
 ret
     b44:	8082                	ret

0000000000000b46 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b46:	48ad                	li	a7,11
 ecall
     b48:	00000073          	ecall
 ret
     b4c:	8082                	ret

0000000000000b4e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b4e:	48b1                	li	a7,12
 ecall
     b50:	00000073          	ecall
 ret
     b54:	8082                	ret

0000000000000b56 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b56:	48b5                	li	a7,13
 ecall
     b58:	00000073          	ecall
 ret
     b5c:	8082                	ret

0000000000000b5e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b5e:	48b9                	li	a7,14
 ecall
     b60:	00000073          	ecall
 ret
     b64:	8082                	ret

0000000000000b66 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     b66:	48d9                	li	a7,22
 ecall
     b68:	00000073          	ecall
 ret
     b6c:	8082                	ret

0000000000000b6e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     b6e:	48dd                	li	a7,23
 ecall
     b70:	00000073          	ecall
 ret
     b74:	8082                	ret

0000000000000b76 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     b76:	48e1                	li	a7,24
 ecall
     b78:	00000073          	ecall
 ret
     b7c:	8082                	ret

0000000000000b7e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     b7e:	48e5                	li	a7,25
 ecall
     b80:	00000073          	ecall
 ret
     b84:	8082                	ret

0000000000000b86 <socket>:
.global socket
socket:
 li a7, SYS_socket
     b86:	48e9                	li	a7,26
 ecall
     b88:	00000073          	ecall
 ret
     b8c:	8082                	ret

0000000000000b8e <bind>:
.global bind
bind:
 li a7, SYS_bind
     b8e:	48ed                	li	a7,27
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <accept>:
.global accept
accept:
 li a7, SYS_accept
     b96:	48f5                	li	a7,29
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <listen>:
.global listen
listen:
 li a7, SYS_listen
     b9e:	48f1                	li	a7,28
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ba6:	48f9                	li	a7,30
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <send>:
.global send
send:
 li a7, SYS_send
     bae:	48fd                	li	a7,31
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <recv>:
.global recv
recv:
 li a7, SYS_recv
     bb6:	02000893          	li	a7,32
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     bc0:	02100893          	li	a7,33
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
     bca:	02200893          	li	a7,34
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bd4:	1101                	addi	sp,sp,-32
     bd6:	ec06                	sd	ra,24(sp)
     bd8:	e822                	sd	s0,16(sp)
     bda:	1000                	addi	s0,sp,32
     bdc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     be0:	4605                	li	a2,1
     be2:	fef40593          	addi	a1,s0,-17
     be6:	00000097          	auipc	ra,0x0
     bea:	f00080e7          	jalr	-256(ra) # ae6 <write>
}
     bee:	60e2                	ld	ra,24(sp)
     bf0:	6442                	ld	s0,16(sp)
     bf2:	6105                	addi	sp,sp,32
     bf4:	8082                	ret

0000000000000bf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bf6:	7139                	addi	sp,sp,-64
     bf8:	fc06                	sd	ra,56(sp)
     bfa:	f822                	sd	s0,48(sp)
     bfc:	f426                	sd	s1,40(sp)
     bfe:	0080                	addi	s0,sp,64
     c00:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c02:	c299                	beqz	a3,c08 <printint+0x12>
     c04:	0805cb63          	bltz	a1,c9a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c08:	2581                	sext.w	a1,a1
  neg = 0;
     c0a:	4881                	li	a7,0
     c0c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c10:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c12:	2601                	sext.w	a2,a2
     c14:	00001517          	auipc	a0,0x1
     c18:	b6450513          	addi	a0,a0,-1180 # 1778 <digits>
     c1c:	883a                	mv	a6,a4
     c1e:	2705                	addiw	a4,a4,1
     c20:	02c5f7bb          	remuw	a5,a1,a2
     c24:	1782                	slli	a5,a5,0x20
     c26:	9381                	srli	a5,a5,0x20
     c28:	97aa                	add	a5,a5,a0
     c2a:	0007c783          	lbu	a5,0(a5)
     c2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c32:	0005879b          	sext.w	a5,a1
     c36:	02c5d5bb          	divuw	a1,a1,a2
     c3a:	0685                	addi	a3,a3,1
     c3c:	fec7f0e3          	bgeu	a5,a2,c1c <printint+0x26>
  if(neg)
     c40:	00088c63          	beqz	a7,c58 <printint+0x62>
    buf[i++] = '-';
     c44:	fd070793          	addi	a5,a4,-48
     c48:	00878733          	add	a4,a5,s0
     c4c:	02d00793          	li	a5,45
     c50:	fef70823          	sb	a5,-16(a4)
     c54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c58:	02e05c63          	blez	a4,c90 <printint+0x9a>
     c5c:	f04a                	sd	s2,32(sp)
     c5e:	ec4e                	sd	s3,24(sp)
     c60:	fc040793          	addi	a5,s0,-64
     c64:	00e78933          	add	s2,a5,a4
     c68:	fff78993          	addi	s3,a5,-1
     c6c:	99ba                	add	s3,s3,a4
     c6e:	377d                	addiw	a4,a4,-1
     c70:	1702                	slli	a4,a4,0x20
     c72:	9301                	srli	a4,a4,0x20
     c74:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c78:	fff94583          	lbu	a1,-1(s2)
     c7c:	8526                	mv	a0,s1
     c7e:	00000097          	auipc	ra,0x0
     c82:	f56080e7          	jalr	-170(ra) # bd4 <putc>
  while(--i >= 0)
     c86:	197d                	addi	s2,s2,-1
     c88:	ff3918e3          	bne	s2,s3,c78 <printint+0x82>
     c8c:	7902                	ld	s2,32(sp)
     c8e:	69e2                	ld	s3,24(sp)
}
     c90:	70e2                	ld	ra,56(sp)
     c92:	7442                	ld	s0,48(sp)
     c94:	74a2                	ld	s1,40(sp)
     c96:	6121                	addi	sp,sp,64
     c98:	8082                	ret
    x = -xx;
     c9a:	40b005bb          	negw	a1,a1
    neg = 1;
     c9e:	4885                	li	a7,1
    x = -xx;
     ca0:	b7b5                	j	c0c <printint+0x16>

0000000000000ca2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ca2:	715d                	addi	sp,sp,-80
     ca4:	e486                	sd	ra,72(sp)
     ca6:	e0a2                	sd	s0,64(sp)
     ca8:	f84a                	sd	s2,48(sp)
     caa:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cac:	0005c903          	lbu	s2,0(a1)
     cb0:	1a090a63          	beqz	s2,e64 <vprintf+0x1c2>
     cb4:	fc26                	sd	s1,56(sp)
     cb6:	f44e                	sd	s3,40(sp)
     cb8:	f052                	sd	s4,32(sp)
     cba:	ec56                	sd	s5,24(sp)
     cbc:	e85a                	sd	s6,16(sp)
     cbe:	e45e                	sd	s7,8(sp)
     cc0:	8aaa                	mv	s5,a0
     cc2:	8bb2                	mv	s7,a2
     cc4:	00158493          	addi	s1,a1,1
  state = 0;
     cc8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     cca:	02500a13          	li	s4,37
     cce:	4b55                	li	s6,21
     cd0:	a839                	j	cee <vprintf+0x4c>
        putc(fd, c);
     cd2:	85ca                	mv	a1,s2
     cd4:	8556                	mv	a0,s5
     cd6:	00000097          	auipc	ra,0x0
     cda:	efe080e7          	jalr	-258(ra) # bd4 <putc>
     cde:	a019                	j	ce4 <vprintf+0x42>
    } else if(state == '%'){
     ce0:	01498d63          	beq	s3,s4,cfa <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     ce4:	0485                	addi	s1,s1,1
     ce6:	fff4c903          	lbu	s2,-1(s1)
     cea:	16090763          	beqz	s2,e58 <vprintf+0x1b6>
    if(state == 0){
     cee:	fe0999e3          	bnez	s3,ce0 <vprintf+0x3e>
      if(c == '%'){
     cf2:	ff4910e3          	bne	s2,s4,cd2 <vprintf+0x30>
        state = '%';
     cf6:	89d2                	mv	s3,s4
     cf8:	b7f5                	j	ce4 <vprintf+0x42>
      if(c == 'd'){
     cfa:	13490463          	beq	s2,s4,e22 <vprintf+0x180>
     cfe:	f9d9079b          	addiw	a5,s2,-99
     d02:	0ff7f793          	zext.b	a5,a5
     d06:	12fb6763          	bltu	s6,a5,e34 <vprintf+0x192>
     d0a:	f9d9079b          	addiw	a5,s2,-99
     d0e:	0ff7f713          	zext.b	a4,a5
     d12:	12eb6163          	bltu	s6,a4,e34 <vprintf+0x192>
     d16:	00271793          	slli	a5,a4,0x2
     d1a:	00001717          	auipc	a4,0x1
     d1e:	a0670713          	addi	a4,a4,-1530 # 1720 <ithread_join+0x4c6>
     d22:	97ba                	add	a5,a5,a4
     d24:	439c                	lw	a5,0(a5)
     d26:	97ba                	add	a5,a5,a4
     d28:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d2a:	008b8913          	addi	s2,s7,8
     d2e:	4685                	li	a3,1
     d30:	4629                	li	a2,10
     d32:	000ba583          	lw	a1,0(s7)
     d36:	8556                	mv	a0,s5
     d38:	00000097          	auipc	ra,0x0
     d3c:	ebe080e7          	jalr	-322(ra) # bf6 <printint>
     d40:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d42:	4981                	li	s3,0
     d44:	b745                	j	ce4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d46:	008b8913          	addi	s2,s7,8
     d4a:	4681                	li	a3,0
     d4c:	4629                	li	a2,10
     d4e:	000ba583          	lw	a1,0(s7)
     d52:	8556                	mv	a0,s5
     d54:	00000097          	auipc	ra,0x0
     d58:	ea2080e7          	jalr	-350(ra) # bf6 <printint>
     d5c:	8bca                	mv	s7,s2
      state = 0;
     d5e:	4981                	li	s3,0
     d60:	b751                	j	ce4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d62:	008b8913          	addi	s2,s7,8
     d66:	4681                	li	a3,0
     d68:	4641                	li	a2,16
     d6a:	000ba583          	lw	a1,0(s7)
     d6e:	8556                	mv	a0,s5
     d70:	00000097          	auipc	ra,0x0
     d74:	e86080e7          	jalr	-378(ra) # bf6 <printint>
     d78:	8bca                	mv	s7,s2
      state = 0;
     d7a:	4981                	li	s3,0
     d7c:	b7a5                	j	ce4 <vprintf+0x42>
     d7e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d80:	008b8c13          	addi	s8,s7,8
     d84:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d88:	03000593          	li	a1,48
     d8c:	8556                	mv	a0,s5
     d8e:	00000097          	auipc	ra,0x0
     d92:	e46080e7          	jalr	-442(ra) # bd4 <putc>
  putc(fd, 'x');
     d96:	07800593          	li	a1,120
     d9a:	8556                	mv	a0,s5
     d9c:	00000097          	auipc	ra,0x0
     da0:	e38080e7          	jalr	-456(ra) # bd4 <putc>
     da4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     da6:	00001b97          	auipc	s7,0x1
     daa:	9d2b8b93          	addi	s7,s7,-1582 # 1778 <digits>
     dae:	03c9d793          	srli	a5,s3,0x3c
     db2:	97de                	add	a5,a5,s7
     db4:	0007c583          	lbu	a1,0(a5)
     db8:	8556                	mv	a0,s5
     dba:	00000097          	auipc	ra,0x0
     dbe:	e1a080e7          	jalr	-486(ra) # bd4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     dc2:	0992                	slli	s3,s3,0x4
     dc4:	397d                	addiw	s2,s2,-1
     dc6:	fe0914e3          	bnez	s2,dae <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     dca:	8be2                	mv	s7,s8
      state = 0;
     dcc:	4981                	li	s3,0
     dce:	6c02                	ld	s8,0(sp)
     dd0:	bf11                	j	ce4 <vprintf+0x42>
        s = va_arg(ap, char*);
     dd2:	008b8993          	addi	s3,s7,8
     dd6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     dda:	02090163          	beqz	s2,dfc <vprintf+0x15a>
        while(*s != 0){
     dde:	00094583          	lbu	a1,0(s2)
     de2:	c9a5                	beqz	a1,e52 <vprintf+0x1b0>
          putc(fd, *s);
     de4:	8556                	mv	a0,s5
     de6:	00000097          	auipc	ra,0x0
     dea:	dee080e7          	jalr	-530(ra) # bd4 <putc>
          s++;
     dee:	0905                	addi	s2,s2,1
        while(*s != 0){
     df0:	00094583          	lbu	a1,0(s2)
     df4:	f9e5                	bnez	a1,de4 <vprintf+0x142>
        s = va_arg(ap, char*);
     df6:	8bce                	mv	s7,s3
      state = 0;
     df8:	4981                	li	s3,0
     dfa:	b5ed                	j	ce4 <vprintf+0x42>
          s = "(null)";
     dfc:	00001917          	auipc	s2,0x1
     e00:	8d490913          	addi	s2,s2,-1836 # 16d0 <ithread_join+0x476>
        while(*s != 0){
     e04:	02800593          	li	a1,40
     e08:	bff1                	j	de4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     e0a:	008b8913          	addi	s2,s7,8
     e0e:	000bc583          	lbu	a1,0(s7)
     e12:	8556                	mv	a0,s5
     e14:	00000097          	auipc	ra,0x0
     e18:	dc0080e7          	jalr	-576(ra) # bd4 <putc>
     e1c:	8bca                	mv	s7,s2
      state = 0;
     e1e:	4981                	li	s3,0
     e20:	b5d1                	j	ce4 <vprintf+0x42>
        putc(fd, c);
     e22:	02500593          	li	a1,37
     e26:	8556                	mv	a0,s5
     e28:	00000097          	auipc	ra,0x0
     e2c:	dac080e7          	jalr	-596(ra) # bd4 <putc>
      state = 0;
     e30:	4981                	li	s3,0
     e32:	bd4d                	j	ce4 <vprintf+0x42>
        putc(fd, '%');
     e34:	02500593          	li	a1,37
     e38:	8556                	mv	a0,s5
     e3a:	00000097          	auipc	ra,0x0
     e3e:	d9a080e7          	jalr	-614(ra) # bd4 <putc>
        putc(fd, c);
     e42:	85ca                	mv	a1,s2
     e44:	8556                	mv	a0,s5
     e46:	00000097          	auipc	ra,0x0
     e4a:	d8e080e7          	jalr	-626(ra) # bd4 <putc>
      state = 0;
     e4e:	4981                	li	s3,0
     e50:	bd51                	j	ce4 <vprintf+0x42>
        s = va_arg(ap, char*);
     e52:	8bce                	mv	s7,s3
      state = 0;
     e54:	4981                	li	s3,0
     e56:	b579                	j	ce4 <vprintf+0x42>
     e58:	74e2                	ld	s1,56(sp)
     e5a:	79a2                	ld	s3,40(sp)
     e5c:	7a02                	ld	s4,32(sp)
     e5e:	6ae2                	ld	s5,24(sp)
     e60:	6b42                	ld	s6,16(sp)
     e62:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e64:	60a6                	ld	ra,72(sp)
     e66:	6406                	ld	s0,64(sp)
     e68:	7942                	ld	s2,48(sp)
     e6a:	6161                	addi	sp,sp,80
     e6c:	8082                	ret

0000000000000e6e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e6e:	715d                	addi	sp,sp,-80
     e70:	ec06                	sd	ra,24(sp)
     e72:	e822                	sd	s0,16(sp)
     e74:	1000                	addi	s0,sp,32
     e76:	e010                	sd	a2,0(s0)
     e78:	e414                	sd	a3,8(s0)
     e7a:	e818                	sd	a4,16(s0)
     e7c:	ec1c                	sd	a5,24(s0)
     e7e:	03043023          	sd	a6,32(s0)
     e82:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e86:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e8a:	8622                	mv	a2,s0
     e8c:	00000097          	auipc	ra,0x0
     e90:	e16080e7          	jalr	-490(ra) # ca2 <vprintf>
}
     e94:	60e2                	ld	ra,24(sp)
     e96:	6442                	ld	s0,16(sp)
     e98:	6161                	addi	sp,sp,80
     e9a:	8082                	ret

0000000000000e9c <printf>:

void
printf(const char *fmt, ...)
{
     e9c:	711d                	addi	sp,sp,-96
     e9e:	ec06                	sd	ra,24(sp)
     ea0:	e822                	sd	s0,16(sp)
     ea2:	1000                	addi	s0,sp,32
     ea4:	e40c                	sd	a1,8(s0)
     ea6:	e810                	sd	a2,16(s0)
     ea8:	ec14                	sd	a3,24(s0)
     eaa:	f018                	sd	a4,32(s0)
     eac:	f41c                	sd	a5,40(s0)
     eae:	03043823          	sd	a6,48(s0)
     eb2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     eb6:	00840613          	addi	a2,s0,8
     eba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ebe:	85aa                	mv	a1,a0
     ec0:	4505                	li	a0,1
     ec2:	00000097          	auipc	ra,0x0
     ec6:	de0080e7          	jalr	-544(ra) # ca2 <vprintf>
}
     eca:	60e2                	ld	ra,24(sp)
     ecc:	6442                	ld	s0,16(sp)
     ece:	6125                	addi	sp,sp,96
     ed0:	8082                	ret

0000000000000ed2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ed2:	1141                	addi	sp,sp,-16
     ed4:	e422                	sd	s0,8(sp)
     ed6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ed8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     edc:	00001797          	auipc	a5,0x1
     ee0:	13c7b783          	ld	a5,316(a5) # 2018 <freep>
     ee4:	a02d                	j	f0e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     ee6:	4618                	lw	a4,8(a2)
     ee8:	9f2d                	addw	a4,a4,a1
     eea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     eee:	6398                	ld	a4,0(a5)
     ef0:	6310                	ld	a2,0(a4)
     ef2:	a83d                	j	f30 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     ef4:	ff852703          	lw	a4,-8(a0)
     ef8:	9f31                	addw	a4,a4,a2
     efa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     efc:	ff053683          	ld	a3,-16(a0)
     f00:	a091                	j	f44 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f02:	6398                	ld	a4,0(a5)
     f04:	00e7e463          	bltu	a5,a4,f0c <free+0x3a>
     f08:	00e6ea63          	bltu	a3,a4,f1c <free+0x4a>
{
     f0c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f0e:	fed7fae3          	bgeu	a5,a3,f02 <free+0x30>
     f12:	6398                	ld	a4,0(a5)
     f14:	00e6e463          	bltu	a3,a4,f1c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f18:	fee7eae3          	bltu	a5,a4,f0c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f1c:	ff852583          	lw	a1,-8(a0)
     f20:	6390                	ld	a2,0(a5)
     f22:	02059813          	slli	a6,a1,0x20
     f26:	01c85713          	srli	a4,a6,0x1c
     f2a:	9736                	add	a4,a4,a3
     f2c:	fae60de3          	beq	a2,a4,ee6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     f30:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f34:	4790                	lw	a2,8(a5)
     f36:	02061593          	slli	a1,a2,0x20
     f3a:	01c5d713          	srli	a4,a1,0x1c
     f3e:	973e                	add	a4,a4,a5
     f40:	fae68ae3          	beq	a3,a4,ef4 <free+0x22>
    p->s.ptr = bp->s.ptr;
     f44:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f46:	00001717          	auipc	a4,0x1
     f4a:	0cf73923          	sd	a5,210(a4) # 2018 <freep>
}
     f4e:	6422                	ld	s0,8(sp)
     f50:	0141                	addi	sp,sp,16
     f52:	8082                	ret

0000000000000f54 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f54:	7139                	addi	sp,sp,-64
     f56:	fc06                	sd	ra,56(sp)
     f58:	f822                	sd	s0,48(sp)
     f5a:	f426                	sd	s1,40(sp)
     f5c:	ec4e                	sd	s3,24(sp)
     f5e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f60:	02051493          	slli	s1,a0,0x20
     f64:	9081                	srli	s1,s1,0x20
     f66:	04bd                	addi	s1,s1,15
     f68:	8091                	srli	s1,s1,0x4
     f6a:	0014899b          	addiw	s3,s1,1
     f6e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     f70:	00001517          	auipc	a0,0x1
     f74:	0a853503          	ld	a0,168(a0) # 2018 <freep>
     f78:	c915                	beqz	a0,fac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     f7c:	4798                	lw	a4,8(a5)
     f7e:	08977e63          	bgeu	a4,s1,101a <malloc+0xc6>
     f82:	f04a                	sd	s2,32(sp)
     f84:	e852                	sd	s4,16(sp)
     f86:	e456                	sd	s5,8(sp)
     f88:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     f8a:	8a4e                	mv	s4,s3
     f8c:	0009871b          	sext.w	a4,s3
     f90:	6685                	lui	a3,0x1
     f92:	00d77363          	bgeu	a4,a3,f98 <malloc+0x44>
     f96:	6a05                	lui	s4,0x1
     f98:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     f9c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fa0:	00001917          	auipc	s2,0x1
     fa4:	07890913          	addi	s2,s2,120 # 2018 <freep>
  if(p == (char*)-1)
     fa8:	5afd                	li	s5,-1
     faa:	a091                	j	fee <malloc+0x9a>
     fac:	f04a                	sd	s2,32(sp)
     fae:	e852                	sd	s4,16(sp)
     fb0:	e456                	sd	s5,8(sp)
     fb2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     fb4:	00001797          	auipc	a5,0x1
     fb8:	07c78793          	addi	a5,a5,124 # 2030 <base>
     fbc:	00001717          	auipc	a4,0x1
     fc0:	04f73e23          	sd	a5,92(a4) # 2018 <freep>
     fc4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     fc6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     fca:	b7c1                	j	f8a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
     fcc:	6398                	ld	a4,0(a5)
     fce:	e118                	sd	a4,0(a0)
     fd0:	a08d                	j	1032 <malloc+0xde>
  hp->s.size = nu;
     fd2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     fd6:	0541                	addi	a0,a0,16
     fd8:	00000097          	auipc	ra,0x0
     fdc:	efa080e7          	jalr	-262(ra) # ed2 <free>
  return freep;
     fe0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     fe4:	c13d                	beqz	a0,104a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fe6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fe8:	4798                	lw	a4,8(a5)
     fea:	02977463          	bgeu	a4,s1,1012 <malloc+0xbe>
    if(p == freep)
     fee:	00093703          	ld	a4,0(s2)
     ff2:	853e                	mv	a0,a5
     ff4:	fef719e3          	bne	a4,a5,fe6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
     ff8:	8552                	mv	a0,s4
     ffa:	00000097          	auipc	ra,0x0
     ffe:	b54080e7          	jalr	-1196(ra) # b4e <sbrk>
  if(p == (char*)-1)
    1002:	fd5518e3          	bne	a0,s5,fd2 <malloc+0x7e>
        return 0;
    1006:	4501                	li	a0,0
    1008:	7902                	ld	s2,32(sp)
    100a:	6a42                	ld	s4,16(sp)
    100c:	6aa2                	ld	s5,8(sp)
    100e:	6b02                	ld	s6,0(sp)
    1010:	a03d                	j	103e <malloc+0xea>
    1012:	7902                	ld	s2,32(sp)
    1014:	6a42                	ld	s4,16(sp)
    1016:	6aa2                	ld	s5,8(sp)
    1018:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    101a:	fae489e3          	beq	s1,a4,fcc <malloc+0x78>
        p->s.size -= nunits;
    101e:	4137073b          	subw	a4,a4,s3
    1022:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1024:	02071693          	slli	a3,a4,0x20
    1028:	01c6d713          	srli	a4,a3,0x1c
    102c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    102e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1032:	00001717          	auipc	a4,0x1
    1036:	fea73323          	sd	a0,-26(a4) # 2018 <freep>
      return (void*)(p + 1);
    103a:	01078513          	addi	a0,a5,16
  }
}
    103e:	70e2                	ld	ra,56(sp)
    1040:	7442                	ld	s0,48(sp)
    1042:	74a2                	ld	s1,40(sp)
    1044:	69e2                	ld	s3,24(sp)
    1046:	6121                	addi	sp,sp,64
    1048:	8082                	ret
    104a:	7902                	ld	s2,32(sp)
    104c:	6a42                	ld	s4,16(sp)
    104e:	6aa2                	ld	s5,8(sp)
    1050:	6b02                	ld	s6,0(sp)
    1052:	b7f5                	j	103e <malloc+0xea>

0000000000001054 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    1054:	1141                	addi	sp,sp,-16
    1056:	e406                	sd	ra,8(sp)
    1058:	e022                	sd	s0,0(sp)
    105a:	0800                	addi	s0,sp,16
  thread_exit(status);
    105c:	2501                	sext.w	a0,a0
    105e:	00000097          	auipc	ra,0x0
    1062:	b20080e7          	jalr	-1248(ra) # b7e <thread_exit>
}
    1066:	60a2                	ld	ra,8(sp)
    1068:	6402                	ld	s0,0(sp)
    106a:	0141                	addi	sp,sp,16
    106c:	8082                	ret

000000000000106e <free_stacks>:
int free_stacks() {
    106e:	7179                	addi	sp,sp,-48
    1070:	f406                	sd	ra,40(sp)
    1072:	f022                	sd	s0,32(sp)
    1074:	ec26                	sd	s1,24(sp)
    1076:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    1078:	00001797          	auipc	a5,0x1
    107c:	fb07a783          	lw	a5,-80(a5) # 2028 <num_threads>
    1080:	04f05063          	blez	a5,10c0 <free_stacks+0x52>
    1084:	e84a                	sd	s2,16(sp)
    1086:	e44e                	sd	s3,8(sp)
    1088:	4481                	li	s1,0
    free(stacks[i]);
    108a:	00001997          	auipc	s3,0x1
    108e:	f9698993          	addi	s3,s3,-106 # 2020 <stacks>
  for (int i = 0; i < num_threads; i++) {
    1092:	00001917          	auipc	s2,0x1
    1096:	f9690913          	addi	s2,s2,-106 # 2028 <num_threads>
    free(stacks[i]);
    109a:	0009b783          	ld	a5,0(s3)
    109e:	00349713          	slli	a4,s1,0x3
    10a2:	97ba                	add	a5,a5,a4
    10a4:	6388                	ld	a0,0(a5)
    10a6:	00000097          	auipc	ra,0x0
    10aa:	e2c080e7          	jalr	-468(ra) # ed2 <free>
  for (int i = 0; i < num_threads; i++) {
    10ae:	0485                	addi	s1,s1,1
    10b0:	00092703          	lw	a4,0(s2)
    10b4:	0004879b          	sext.w	a5,s1
    10b8:	fee7c1e3          	blt	a5,a4,109a <free_stacks+0x2c>
    10bc:	6942                	ld	s2,16(sp)
    10be:	69a2                	ld	s3,8(sp)
  free(stacks);
    10c0:	00001497          	auipc	s1,0x1
    10c4:	f6048493          	addi	s1,s1,-160 # 2020 <stacks>
    10c8:	6088                	ld	a0,0(s1)
    10ca:	00000097          	auipc	ra,0x0
    10ce:	e08080e7          	jalr	-504(ra) # ed2 <free>
  stacks = 0;
    10d2:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    10d6:	00001797          	auipc	a5,0x1
    10da:	f407a923          	sw	zero,-174(a5) # 2028 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    10de:	47a1                	li	a5,8
    10e0:	00001717          	auipc	a4,0x1
    10e4:	f2f72423          	sw	a5,-216(a4) # 2008 <max_stacks>
  threads_done = 0;
    10e8:	00001797          	auipc	a5,0x1
    10ec:	f407a223          	sw	zero,-188(a5) # 202c <threads_done>
}
    10f0:	4501                	li	a0,0
    10f2:	70a2                	ld	ra,40(sp)
    10f4:	7402                	ld	s0,32(sp)
    10f6:	64e2                	ld	s1,24(sp)
    10f8:	6145                	addi	sp,sp,48
    10fa:	8082                	ret

00000000000010fc <expand_num_threads>:
int expand_num_threads() {
    10fc:	1101                	addi	sp,sp,-32
    10fe:	ec06                	sd	ra,24(sp)
    1100:	e822                	sd	s0,16(sp)
    1102:	e426                	sd	s1,8(sp)
    1104:	e04a                	sd	s2,0(sp)
    1106:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1108:	00001797          	auipc	a5,0x1
    110c:	f0078793          	addi	a5,a5,-256 # 2008 <max_stacks>
    1110:	4388                	lw	a0,0(a5)
    1112:	0015151b          	slliw	a0,a0,0x1
    1116:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1118:	0035151b          	slliw	a0,a0,0x3
    111c:	00000097          	auipc	ra,0x0
    1120:	e38080e7          	jalr	-456(ra) # f54 <malloc>
    1124:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    1126:	00001617          	auipc	a2,0x1
    112a:	f0262603          	lw	a2,-254(a2) # 2028 <num_threads>
    112e:	00001497          	auipc	s1,0x1
    1132:	ef248493          	addi	s1,s1,-270 # 2020 <stacks>
    1136:	0036161b          	slliw	a2,a2,0x3
    113a:	608c                	ld	a1,0(s1)
    113c:	00000097          	auipc	ra,0x0
    1140:	840080e7          	jalr	-1984(ra) # 97c <memmove>
  free(stacks);
    1144:	6088                	ld	a0,0(s1)
    1146:	00000097          	auipc	ra,0x0
    114a:	d8c080e7          	jalr	-628(ra) # ed2 <free>
  stacks = new_stacks;
    114e:	0124b023          	sd	s2,0(s1)
}
    1152:	4501                	li	a0,0
    1154:	60e2                	ld	ra,24(sp)
    1156:	6442                	ld	s0,16(sp)
    1158:	64a2                	ld	s1,8(sp)
    115a:	6902                	ld	s2,0(sp)
    115c:	6105                	addi	sp,sp,32
    115e:	8082                	ret

0000000000001160 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1160:	7179                	addi	sp,sp,-48
    1162:	f406                	sd	ra,40(sp)
    1164:	f022                	sd	s0,32(sp)
    1166:	e84a                	sd	s2,16(sp)
    1168:	e44e                	sd	s3,8(sp)
    116a:	1800                	addi	s0,sp,48
    116c:	892a                	mv	s2,a0
    116e:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1170:	00001797          	auipc	a5,0x1
    1174:	eb07b783          	ld	a5,-336(a5) # 2020 <stacks>
    1178:	c3d9                	beqz	a5,11fe <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    117a:	00001797          	auipc	a5,0x1
    117e:	e8e7a783          	lw	a5,-370(a5) # 2008 <max_stacks>
    1182:	00001717          	auipc	a4,0x1
    1186:	ea672703          	lw	a4,-346(a4) # 2028 <num_threads>
    118a:	0af71363          	bne	a4,a5,1230 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    118e:	04000713          	li	a4,64
    1192:	08e78563          	beq	a5,a4,121c <ithread_create+0xbc>
    1196:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    1198:	00000097          	auipc	ra,0x0
    119c:	f64080e7          	jalr	-156(ra) # 10fc <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    11a0:	6505                	lui	a0,0x1
    11a2:	00000097          	auipc	ra,0x0
    11a6:	db2080e7          	jalr	-590(ra) # f54 <malloc>
    11aa:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    11ac:	00001717          	auipc	a4,0x1
    11b0:	e7c72703          	lw	a4,-388(a4) # 2028 <num_threads>
    11b4:	070e                	slli	a4,a4,0x3
    11b6:	00001797          	auipc	a5,0x1
    11ba:	e6a7b783          	ld	a5,-406(a5) # 2020 <stacks>
    11be:	97ba                	add	a5,a5,a4
    11c0:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    11c2:	00000697          	auipc	a3,0x0
    11c6:	e9268693          	addi	a3,a3,-366 # 1054 <ithread_exit>
    11ca:	862a                	mv	a2,a0
    11cc:	85ce                	mv	a1,s3
    11ce:	854a                	mv	a0,s2
    11d0:	00000097          	auipc	ra,0x0
    11d4:	99e080e7          	jalr	-1634(ra) # b6e <create_thread>
    11d8:	892a                	mv	s2,a0
  if (res != -1) {
    11da:	57fd                	li	a5,-1
    11dc:	04f50c63          	beq	a0,a5,1234 <ithread_create+0xd4>
    num_threads++;
    11e0:	00001717          	auipc	a4,0x1
    11e4:	e4870713          	addi	a4,a4,-440 # 2028 <num_threads>
    11e8:	431c                	lw	a5,0(a4)
    11ea:	2785                	addiw	a5,a5,1
    11ec:	c31c                	sw	a5,0(a4)
    11ee:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    11f0:	854a                	mv	a0,s2
    11f2:	70a2                	ld	ra,40(sp)
    11f4:	7402                	ld	s0,32(sp)
    11f6:	6942                	ld	s2,16(sp)
    11f8:	69a2                	ld	s3,8(sp)
    11fa:	6145                	addi	sp,sp,48
    11fc:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    11fe:	00001517          	auipc	a0,0x1
    1202:	e0a52503          	lw	a0,-502(a0) # 2008 <max_stacks>
    1206:	0035151b          	slliw	a0,a0,0x3
    120a:	00000097          	auipc	ra,0x0
    120e:	d4a080e7          	jalr	-694(ra) # f54 <malloc>
    1212:	00001797          	auipc	a5,0x1
    1216:	e0a7b723          	sd	a0,-498(a5) # 2020 <stacks>
    121a:	b785                	j	117a <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    121c:	00000517          	auipc	a0,0x0
    1220:	4bc50513          	addi	a0,a0,1212 # 16d8 <ithread_join+0x47e>
    1224:	00000097          	auipc	ra,0x0
    1228:	c78080e7          	jalr	-904(ra) # e9c <printf>
      return -1;
    122c:	597d                	li	s2,-1
    122e:	b7c9                	j	11f0 <ithread_create+0x90>
    1230:	ec26                	sd	s1,24(sp)
    1232:	b7bd                	j	11a0 <ithread_create+0x40>
    free(stack_ptr);
    1234:	8526                	mv	a0,s1
    1236:	00000097          	auipc	ra,0x0
    123a:	c9c080e7          	jalr	-868(ra) # ed2 <free>
    stacks[num_threads] = 0;
    123e:	00001717          	auipc	a4,0x1
    1242:	dea72703          	lw	a4,-534(a4) # 2028 <num_threads>
    1246:	070e                	slli	a4,a4,0x3
    1248:	00001797          	auipc	a5,0x1
    124c:	dd87b783          	ld	a5,-552(a5) # 2020 <stacks>
    1250:	97ba                	add	a5,a5,a4
    1252:	0007b023          	sd	zero,0(a5)
    1256:	64e2                	ld	s1,24(sp)
    1258:	bf61                	j	11f0 <ithread_create+0x90>

000000000000125a <ithread_join>:

int ithread_join(int thread_id) {
    125a:	1101                	addi	sp,sp,-32
    125c:	ec06                	sd	ra,24(sp)
    125e:	e822                	sd	s0,16(sp)
    1260:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1262:	ff040793          	addi	a5,s0,-16
    1266:	ffc7859b          	addiw	a1,a5,-4
    126a:	00000097          	auipc	ra,0x0
    126e:	90c080e7          	jalr	-1780(ra) # b76 <join_thread>
  threads_done++;
    1272:	00001717          	auipc	a4,0x1
    1276:	dba70713          	addi	a4,a4,-582 # 202c <threads_done>
    127a:	431c                	lw	a5,0(a4)
    127c:	2785                	addiw	a5,a5,1
    127e:	0007869b          	sext.w	a3,a5
    1282:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1284:	00001797          	auipc	a5,0x1
    1288:	da47a783          	lw	a5,-604(a5) # 2028 <num_threads>
    128c:	00d78863          	beq	a5,a3,129c <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
    1290:	fec42503          	lw	a0,-20(s0)
    1294:	60e2                	ld	ra,24(sp)
    1296:	6442                	ld	s0,16(sp)
    1298:	6105                	addi	sp,sp,32
    129a:	8082                	ret
    free_stacks();
    129c:	00000097          	auipc	ra,0x0
    12a0:	dd2080e7          	jalr	-558(ra) # 106e <free_stacks>
    12a4:	b7f5                	j	1290 <ithread_join+0x36>
