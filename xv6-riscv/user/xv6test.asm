
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
      52:	14250513          	addi	a0,a0,322 # 1190 <ithread_join+0x52>
      56:	00001097          	auipc	ra,0x1
      5a:	d2a080e7          	jalr	-726(ra) # d80 <printf>
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
      a2:	11250513          	addi	a0,a0,274 # 11b0 <ithread_join+0x72>
      a6:	00001097          	auipc	ra,0x1
      aa:	cda080e7          	jalr	-806(ra) # d80 <printf>
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
      ce:	11e50513          	addi	a0,a0,286 # 11e8 <ithread_join+0xaa>
      d2:	00001097          	auipc	ra,0x1
      d6:	cae080e7          	jalr	-850(ra) # d80 <printf>
  fail = p[0]; // this should ideally trap or fail
      da:	00002797          	auipc	a5,0x2
      de:	6f67b783          	ld	a5,1782(a5) # 27d0 <p>
      e2:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e4:	85a6                	mv	a1,s1
      e6:	00001517          	auipc	a0,0x1
      ea:	13250513          	addi	a0,a0,306 # 1218 <ithread_join+0xda>
      ee:	00001097          	auipc	ra,0x1
      f2:	c92080e7          	jalr	-878(ra) # d80 <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f6:	85a6                	mv	a1,s1
      f8:	00001517          	auipc	a0,0x1
      fc:	13850513          	addi	a0,a0,312 # 1230 <ithread_join+0xf2>
     100:	00001097          	auipc	ra,0x1
     104:	c80080e7          	jalr	-896(ra) # d80 <printf>
}
     108:	4501                	li	a0,0
     10a:	60e2                	ld	ra,24(sp)
     10c:	6442                	ld	s0,16(sp)
     10e:	64a2                	ld	s1,8(sp)
     110:	6105                	addi	sp,sp,32
     112:	8082                	ret
    printf("FAIL: p is invalid\n");
     114:	00001517          	auipc	a0,0x1
     118:	0bc50513          	addi	a0,a0,188 # 11d0 <ithread_join+0x92>
     11c:	00001097          	auipc	ra,0x1
     120:	c64080e7          	jalr	-924(ra) # d80 <printf>
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
     164:	12050513          	addi	a0,a0,288 # 1280 <ithread_join+0x142>
     168:	00001097          	auipc	ra,0x1
     16c:	c18080e7          	jalr	-1000(ra) # d80 <printf>
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
     17e:	0e650513          	addi	a0,a0,230 # 1260 <ithread_join+0x122>
     182:	00001097          	auipc	ra,0x1
     186:	bfe080e7          	jalr	-1026(ra) # d80 <printf>
    return 0;
     18a:	b7dd                	j	170 <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18c:	00001517          	auipc	a0,0x1
     190:	0ec50513          	addi	a0,a0,236 # 1278 <ithread_join+0x13a>
     194:	00001097          	auipc	ra,0x1
     198:	bec080e7          	jalr	-1044(ra) # d80 <printf>
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
     224:	00052903          	lw	s2,0(a0) # 1000 <expand_num_threads+0x22>
  printf("Thread %d is running\n", val);
     228:	85ca                	mv	a1,s2
     22a:	00001517          	auipc	a0,0x1
     22e:	08650513          	addi	a0,a0,134 # 12b0 <ithread_join+0x172>
     232:	00001097          	auipc	ra,0x1
     236:	b4e080e7          	jalr	-1202(ra) # d80 <printf>
  free(arg);
     23a:	8526                	mv	a0,s1
     23c:	00001097          	auipc	ra,0x1
     240:	b7a080e7          	jalr	-1158(ra) # db6 <free>
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
     262:	cd8080e7          	jalr	-808(ra) # f36 <ithread_exit>
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
     27c:	05050513          	addi	a0,a0,80 # 12c8 <ithread_join+0x18a>
     280:	00001097          	auipc	ra,0x1
     284:	b00080e7          	jalr	-1280(ra) # d80 <printf>
  int *arg = malloc(sizeof(int));
     288:	4511                	li	a0,4
     28a:	00001097          	auipc	ra,0x1
     28e:	bb2080e7          	jalr	-1102(ra) # e3c <malloc>
     292:	85aa                	mv	a1,a0
  *arg = 0;
     294:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     298:	00000517          	auipc	a0,0x0
     29c:	f7e50513          	addi	a0,a0,-130 # 216 <thread_func_basic>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	da2080e7          	jalr	-606(ra) # 1042 <ithread_create>
  if (tid < 0) {
     2a8:	02054763          	bltz	a0,2d6 <test_thread_create+0x66>
     2ac:	e426                	sd	s1,8(sp)
     2ae:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2b0:	85aa                	mv	a1,a0
     2b2:	00001517          	auipc	a0,0x1
     2b6:	05e50513          	addi	a0,a0,94 # 1310 <ithread_join+0x1d2>
     2ba:	00001097          	auipc	ra,0x1
     2be:	ac6080e7          	jalr	-1338(ra) # d80 <printf>
    ithread_join(tid);
     2c2:	8526                	mv	a0,s1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	e7a080e7          	jalr	-390(ra) # 113e <ithread_join>
     2cc:	64a2                	ld	s1,8(sp)
}
     2ce:	60e2                	ld	ra,24(sp)
     2d0:	6442                	ld	s0,16(sp)
     2d2:	6105                	addi	sp,sp,32
     2d4:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	01250513          	addi	a0,a0,18 # 12e8 <ithread_join+0x1aa>
     2de:	00001097          	auipc	ra,0x1
     2e2:	aa2080e7          	jalr	-1374(ra) # d80 <printf>
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
     2f8:	04c50513          	addi	a0,a0,76 # 1340 <ithread_join+0x202>
     2fc:	00001097          	auipc	ra,0x1
     300:	a84080e7          	jalr	-1404(ra) # d80 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     304:	4581                	li	a1,0
     306:	00000517          	auipc	a0,0x0
     30a:	e9850513          	addi	a0,a0,-360 # 19e <prop_mem_dealloc1>
     30e:	00001097          	auipc	ra,0x1
     312:	d34080e7          	jalr	-716(ra) # 1042 <ithread_create>
     316:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     318:	4581                	li	a1,0
     31a:	00000517          	auipc	a0,0x0
     31e:	d6250513          	addi	a0,a0,-670 # 7c <prop_mem_dealloc2>
     322:	00001097          	auipc	ra,0x1
     326:	d20080e7          	jalr	-736(ra) # 1042 <ithread_create>
     32a:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32c:	854a                	mv	a0,s2
     32e:	00001097          	auipc	ra,0x1
     332:	e10080e7          	jalr	-496(ra) # 113e <ithread_join>
  ithread_join(tid2);
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	e06080e7          	jalr	-506(ra) # 113e <ithread_join>
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
     35c:	00050513          	mv	a0,a0
     360:	00001097          	auipc	ra,0x1
     364:	a20080e7          	jalr	-1504(ra) # d80 <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     368:	4581                	li	a1,0
     36a:	00000517          	auipc	a0,0x0
     36e:	e7c50513          	addi	a0,a0,-388 # 1e6 <prop_mem_alloc1>
     372:	00001097          	auipc	ra,0x1
     376:	cd0080e7          	jalr	-816(ra) # 1042 <ithread_create>
     37a:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37c:	4581                	li	a1,0
     37e:	00000517          	auipc	a0,0x0
     382:	da850513          	addi	a0,a0,-600 # 126 <prop_mem_alloc2>
     386:	00001097          	auipc	ra,0x1
     38a:	cbc080e7          	jalr	-836(ra) # 1042 <ithread_create>
     38e:	84aa                	mv	s1,a0
  ithread_join(tid1);
     390:	854a                	mv	a0,s2
     392:	00001097          	auipc	ra,0x1
     396:	dac080e7          	jalr	-596(ra) # 113e <ithread_join>
  ithread_join(tid2);
     39a:	8526                	mv	a0,s1
     39c:	00001097          	auipc	ra,0x1
     3a0:	da2080e7          	jalr	-606(ra) # 113e <ithread_join>

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
     3bc:	fb850513          	addi	a0,a0,-72 # 1370 <ithread_join+0x232>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	9c0080e7          	jalr	-1600(ra) # d80 <printf>

  int *arg = malloc(sizeof(int));
     3c8:	4511                	li	a0,4
     3ca:	00001097          	auipc	ra,0x1
     3ce:	a72080e7          	jalr	-1422(ra) # e3c <malloc>
     3d2:	85aa                	mv	a1,a0
  *arg = 100;
     3d4:	06400793          	li	a5,100
     3d8:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3da:	00000517          	auipc	a0,0x0
     3de:	e3c50513          	addi	a0,a0,-452 # 216 <thread_func_basic>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	c60080e7          	jalr	-928(ra) # 1042 <ithread_create>

  if (tid < 0) {
     3ea:	02054763          	bltz	a0,418 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ee:	00001097          	auipc	ra,0x1
     3f2:	d50080e7          	jalr	-688(ra) # 113e <ithread_join>
     3f6:	85aa                	mv	a1,a0
  if (status == 101) {
     3f8:	06500793          	li	a5,101
     3fc:	02f50763          	beq	a0,a5,42a <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     400:	00001517          	auipc	a0,0x1
     404:	ff050513          	addi	a0,a0,-16 # 13f0 <ithread_join+0x2b2>
     408:	00001097          	auipc	ra,0x1
     40c:	978080e7          	jalr	-1672(ra) # d80 <printf>
  }
}
     410:	60a2                	ld	ra,8(sp)
     412:	6402                	ld	s0,0(sp)
     414:	0141                	addi	sp,sp,16
     416:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     418:	00001517          	auipc	a0,0x1
     41c:	f7850513          	addi	a0,a0,-136 # 1390 <ithread_join+0x252>
     420:	00001097          	auipc	ra,0x1
     424:	960080e7          	jalr	-1696(ra) # d80 <printf>
    return;
     428:	b7e5                	j	410 <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     42a:	00001517          	auipc	a0,0x1
     42e:	f9650513          	addi	a0,a0,-106 # 13c0 <ithread_join+0x282>
     432:	00001097          	auipc	ra,0x1
     436:	94e080e7          	jalr	-1714(ra) # d80 <printf>
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
     450:	fcc50513          	addi	a0,a0,-52 # 1418 <ithread_join+0x2da>
     454:	00001097          	auipc	ra,0x1
     458:	92c080e7          	jalr	-1748(ra) # d80 <printf>

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
     47e:	bc8080e7          	jalr	-1080(ra) # 1042 <ithread_create>
     482:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     486:	0911                	addi	s2,s2,4
     488:	ff3917e3          	bne	s2,s3,476 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48c:	4088                	lw	a0,0(s1)
     48e:	00001097          	auipc	ra,0x1
     492:	cb0080e7          	jalr	-848(ra) # 113e <ithread_join>
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
     4b0:	fbc50513          	addi	a0,a0,-68 # 1468 <ithread_join+0x32a>
     4b4:	00001097          	auipc	ra,0x1
     4b8:	8cc080e7          	jalr	-1844(ra) # d80 <printf>
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
     4d0:	f7450513          	addi	a0,a0,-140 # 1440 <ithread_join+0x302>
     4d4:	00001097          	auipc	ra,0x1
     4d8:	8ac080e7          	jalr	-1876(ra) # d80 <printf>
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
     4ea:	faa50513          	addi	a0,a0,-86 # 1490 <ithread_join+0x352>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	892080e7          	jalr	-1902(ra) # d80 <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4f6:	4581                	li	a1,0
     4f8:	00000517          	auipc	a0,0x0
     4fc:	d5c50513          	addi	a0,a0,-676 # 254 <thread_func_exit>
     500:	00001097          	auipc	ra,0x1
     504:	b42080e7          	jalr	-1214(ra) # 1042 <ithread_create>
  int status = ithread_join(tid);
     508:	00001097          	auipc	ra,0x1
     50c:	c36080e7          	jalr	-970(ra) # 113e <ithread_join>
     510:	85aa                	mv	a1,a0

  if (status == 0) {
     512:	ed09                	bnez	a0,52c <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     514:	00001517          	auipc	a0,0x1
     518:	fa450513          	addi	a0,a0,-92 # 14b8 <ithread_join+0x37a>
     51c:	00001097          	auipc	ra,0x1
     520:	864080e7          	jalr	-1948(ra) # d80 <printf>
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
     530:	fcc50513          	addi	a0,a0,-52 # 14f8 <ithread_join+0x3ba>
     534:	00001097          	auipc	ra,0x1
     538:	84c080e7          	jalr	-1972(ra) # d80 <printf>
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
     558:	fd450513          	addi	a0,a0,-44 # 1528 <ithread_join+0x3ea>
     55c:	00001097          	auipc	ra,0x1
     560:	824080e7          	jalr	-2012(ra) # d80 <printf>
  int *num = malloc(10*sizeof(int));
     564:	02800513          	li	a0,40
     568:	00001097          	auipc	ra,0x1
     56c:	8d4080e7          	jalr	-1836(ra) # e3c <malloc>
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
     592:	ab4080e7          	jalr	-1356(ra) # 1042 <ithread_create>
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
     5ae:	b94080e7          	jalr	-1132(ra) # 113e <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b2:	0491                	addi	s1,s1,4
     5b4:	ff249ae3          	bne	s1,s2,5a8 <test_exit_all+0x6a>
  }
  free(num);
     5b8:	855e                	mv	a0,s7
     5ba:	00000097          	auipc	ra,0x0
     5be:	7fc080e7          	jalr	2044(ra) # db6 <free>
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
     5ee:	f6e50513          	addi	a0,a0,-146 # 1558 <ithread_join+0x41a>
     5f2:	00000097          	auipc	ra,0x0
     5f6:	78e080e7          	jalr	1934(ra) # d80 <printf>
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
     62c:	fbc70713          	addi	a4,a4,-68 # 15e4 <ithread_join+0x4a6>
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
     682:	f0250513          	addi	a0,a0,-254 # 1580 <ithread_join+0x442>
     686:	00000097          	auipc	ra,0x0
     68a:	6fa080e7          	jalr	1786(ra) # d80 <printf>
     68e:	a849                	j	720 <main+0x148>
  }
  }else{
   test_thread_create();
     690:	00000097          	auipc	ra,0x0
     694:	be0080e7          	jalr	-1056(ra) # 270 <test_thread_create>
   printf("\n");
     698:	00001517          	auipc	a0,0x1
     69c:	f1050513          	addi	a0,a0,-240 # 15a8 <ithread_join+0x46a>
     6a0:	00000097          	auipc	ra,0x0
     6a4:	6e0080e7          	jalr	1760(ra) # d80 <printf>
   test_thread_join();
     6a8:	00000097          	auipc	ra,0x0
     6ac:	d08080e7          	jalr	-760(ra) # 3b0 <test_thread_join>
   printf("\n");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	ef850513          	addi	a0,a0,-264 # 15a8 <ithread_join+0x46a>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	6c8080e7          	jalr	1736(ra) # d80 <printf>
   test_shared_memory();
     6c0:	00000097          	auipc	ra,0x0
     6c4:	d7c080e7          	jalr	-644(ra) # 43c <test_shared_memory>
   printf("\n");
     6c8:	00001517          	auipc	a0,0x1
     6cc:	ee050513          	addi	a0,a0,-288 # 15a8 <ithread_join+0x46a>
     6d0:	00000097          	auipc	ra,0x0
     6d4:	6b0080e7          	jalr	1712(ra) # d80 <printf>
   test_exit();
     6d8:	00000097          	auipc	ra,0x0
     6dc:	e06080e7          	jalr	-506(ra) # 4de <test_exit>
   printf("\n");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	ec850513          	addi	a0,a0,-312 # 15a8 <ithread_join+0x46a>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	698080e7          	jalr	1688(ra) # d80 <printf>
   // test_exit_all();
   printf("\n");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	eb850513          	addi	a0,a0,-328 # 15a8 <ithread_join+0x46a>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	688080e7          	jalr	1672(ra) # d80 <printf>
   test_global_pointer_alloc();
     700:	00000097          	auipc	ra,0x0
     704:	c4c080e7          	jalr	-948(ra) # 34c <test_global_pointer_alloc>
   printf("\n");
     708:	00001517          	auipc	a0,0x1
     70c:	ea050513          	addi	a0,a0,-352 # 15a8 <ithread_join+0x46a>
     710:	00000097          	auipc	ra,0x0
     714:	670080e7          	jalr	1648(ra) # d80 <printf>
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

0000000000000a92 <socket>:
.global socket
socket:
 li a7, SYS_socket
     a92:	48e9                	li	a7,26
 ecall
     a94:	00000073          	ecall
 ret
     a98:	8082                	ret

0000000000000a9a <bind>:
.global bind
bind:
 li a7, SYS_bind
     a9a:	48ed                	li	a7,27
 ecall
     a9c:	00000073          	ecall
 ret
     aa0:	8082                	ret

0000000000000aa2 <accept>:
.global accept
accept:
 li a7, SYS_accept
     aa2:	48f5                	li	a7,29
 ecall
     aa4:	00000073          	ecall
 ret
     aa8:	8082                	ret

0000000000000aaa <listen>:
.global listen
listen:
 li a7, SYS_listen
     aaa:	48f1                	li	a7,28
 ecall
     aac:	00000073          	ecall
 ret
     ab0:	8082                	ret

0000000000000ab2 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ab2:	48f9                	li	a7,30
 ecall
     ab4:	00000073          	ecall
 ret
     ab8:	8082                	ret

0000000000000aba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     aba:	1101                	addi	sp,sp,-32
     abc:	ec06                	sd	ra,24(sp)
     abe:	e822                	sd	s0,16(sp)
     ac0:	1000                	addi	s0,sp,32
     ac2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ac6:	4605                	li	a2,1
     ac8:	fef40593          	addi	a1,s0,-17
     acc:	00000097          	auipc	ra,0x0
     ad0:	f26080e7          	jalr	-218(ra) # 9f2 <write>
}
     ad4:	60e2                	ld	ra,24(sp)
     ad6:	6442                	ld	s0,16(sp)
     ad8:	6105                	addi	sp,sp,32
     ada:	8082                	ret

0000000000000adc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     adc:	7139                	addi	sp,sp,-64
     ade:	fc06                	sd	ra,56(sp)
     ae0:	f822                	sd	s0,48(sp)
     ae2:	f04a                	sd	s2,32(sp)
     ae4:	ec4e                	sd	s3,24(sp)
     ae6:	0080                	addi	s0,sp,64
     ae8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     aea:	cad9                	beqz	a3,b80 <printint+0xa4>
     aec:	01f5d79b          	srliw	a5,a1,0x1f
     af0:	cbc1                	beqz	a5,b80 <printint+0xa4>
    neg = 1;
    x = -xx;
     af2:	40b005bb          	negw	a1,a1
    neg = 1;
     af6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     af8:	fc040993          	addi	s3,s0,-64
  neg = 0;
     afc:	86ce                	mv	a3,s3
  i = 0;
     afe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     b00:	00001817          	auipc	a6,0x1
     b04:	b5880813          	addi	a6,a6,-1192 # 1658 <digits>
     b08:	88ba                	mv	a7,a4
     b0a:	0017051b          	addiw	a0,a4,1
     b0e:	872a                	mv	a4,a0
     b10:	02c5f7bb          	remuw	a5,a1,a2
     b14:	1782                	slli	a5,a5,0x20
     b16:	9381                	srli	a5,a5,0x20
     b18:	97c2                	add	a5,a5,a6
     b1a:	0007c783          	lbu	a5,0(a5)
     b1e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     b22:	87ae                	mv	a5,a1
     b24:	02c5d5bb          	divuw	a1,a1,a2
     b28:	0685                	addi	a3,a3,1
     b2a:	fcc7ffe3          	bgeu	a5,a2,b08 <printint+0x2c>
  if(neg)
     b2e:	00030c63          	beqz	t1,b46 <printint+0x6a>
    buf[i++] = '-';
     b32:	fd050793          	addi	a5,a0,-48
     b36:	00878533          	add	a0,a5,s0
     b3a:	02d00793          	li	a5,45
     b3e:	fef50823          	sb	a5,-16(a0)
     b42:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     b46:	02e05763          	blez	a4,b74 <printint+0x98>
     b4a:	f426                	sd	s1,40(sp)
     b4c:	377d                	addiw	a4,a4,-1
     b4e:	00e984b3          	add	s1,s3,a4
     b52:	19fd                	addi	s3,s3,-1
     b54:	99ba                	add	s3,s3,a4
     b56:	1702                	slli	a4,a4,0x20
     b58:	9301                	srli	a4,a4,0x20
     b5a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b5e:	0004c583          	lbu	a1,0(s1)
     b62:	854a                	mv	a0,s2
     b64:	00000097          	auipc	ra,0x0
     b68:	f56080e7          	jalr	-170(ra) # aba <putc>
  while(--i >= 0)
     b6c:	14fd                	addi	s1,s1,-1
     b6e:	ff3498e3          	bne	s1,s3,b5e <printint+0x82>
     b72:	74a2                	ld	s1,40(sp)
}
     b74:	70e2                	ld	ra,56(sp)
     b76:	7442                	ld	s0,48(sp)
     b78:	7902                	ld	s2,32(sp)
     b7a:	69e2                	ld	s3,24(sp)
     b7c:	6121                	addi	sp,sp,64
     b7e:	8082                	ret
  neg = 0;
     b80:	4301                	li	t1,0
     b82:	bf9d                	j	af8 <printint+0x1c>

0000000000000b84 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b84:	715d                	addi	sp,sp,-80
     b86:	e486                	sd	ra,72(sp)
     b88:	e0a2                	sd	s0,64(sp)
     b8a:	f84a                	sd	s2,48(sp)
     b8c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     b8e:	0005c903          	lbu	s2,0(a1)
     b92:	1a090b63          	beqz	s2,d48 <vprintf+0x1c4>
     b96:	fc26                	sd	s1,56(sp)
     b98:	f44e                	sd	s3,40(sp)
     b9a:	f052                	sd	s4,32(sp)
     b9c:	ec56                	sd	s5,24(sp)
     b9e:	e85a                	sd	s6,16(sp)
     ba0:	e45e                	sd	s7,8(sp)
     ba2:	8aaa                	mv	s5,a0
     ba4:	8bb2                	mv	s7,a2
     ba6:	00158493          	addi	s1,a1,1
  state = 0;
     baa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     bac:	02500a13          	li	s4,37
     bb0:	4b55                	li	s6,21
     bb2:	a839                	j	bd0 <vprintf+0x4c>
        putc(fd, c);
     bb4:	85ca                	mv	a1,s2
     bb6:	8556                	mv	a0,s5
     bb8:	00000097          	auipc	ra,0x0
     bbc:	f02080e7          	jalr	-254(ra) # aba <putc>
     bc0:	a019                	j	bc6 <vprintf+0x42>
    } else if(state == '%'){
     bc2:	01498d63          	beq	s3,s4,bdc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     bc6:	0485                	addi	s1,s1,1
     bc8:	fff4c903          	lbu	s2,-1(s1)
     bcc:	16090863          	beqz	s2,d3c <vprintf+0x1b8>
    if(state == 0){
     bd0:	fe0999e3          	bnez	s3,bc2 <vprintf+0x3e>
      if(c == '%'){
     bd4:	ff4910e3          	bne	s2,s4,bb4 <vprintf+0x30>
        state = '%';
     bd8:	89d2                	mv	s3,s4
     bda:	b7f5                	j	bc6 <vprintf+0x42>
      if(c == 'd'){
     bdc:	13490563          	beq	s2,s4,d06 <vprintf+0x182>
     be0:	f9d9079b          	addiw	a5,s2,-99
     be4:	0ff7f793          	zext.b	a5,a5
     be8:	12fb6863          	bltu	s6,a5,d18 <vprintf+0x194>
     bec:	f9d9079b          	addiw	a5,s2,-99
     bf0:	0ff7f713          	zext.b	a4,a5
     bf4:	12eb6263          	bltu	s6,a4,d18 <vprintf+0x194>
     bf8:	00271793          	slli	a5,a4,0x2
     bfc:	00001717          	auipc	a4,0x1
     c00:	a0470713          	addi	a4,a4,-1532 # 1600 <ithread_join+0x4c2>
     c04:	97ba                	add	a5,a5,a4
     c06:	439c                	lw	a5,0(a5)
     c08:	97ba                	add	a5,a5,a4
     c0a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     c0c:	008b8913          	addi	s2,s7,8
     c10:	4685                	li	a3,1
     c12:	4629                	li	a2,10
     c14:	000ba583          	lw	a1,0(s7)
     c18:	8556                	mv	a0,s5
     c1a:	00000097          	auipc	ra,0x0
     c1e:	ec2080e7          	jalr	-318(ra) # adc <printint>
     c22:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     c24:	4981                	li	s3,0
     c26:	b745                	j	bc6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c28:	008b8913          	addi	s2,s7,8
     c2c:	4681                	li	a3,0
     c2e:	4629                	li	a2,10
     c30:	000ba583          	lw	a1,0(s7)
     c34:	8556                	mv	a0,s5
     c36:	00000097          	auipc	ra,0x0
     c3a:	ea6080e7          	jalr	-346(ra) # adc <printint>
     c3e:	8bca                	mv	s7,s2
      state = 0;
     c40:	4981                	li	s3,0
     c42:	b751                	j	bc6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     c44:	008b8913          	addi	s2,s7,8
     c48:	4681                	li	a3,0
     c4a:	4641                	li	a2,16
     c4c:	000ba583          	lw	a1,0(s7)
     c50:	8556                	mv	a0,s5
     c52:	00000097          	auipc	ra,0x0
     c56:	e8a080e7          	jalr	-374(ra) # adc <printint>
     c5a:	8bca                	mv	s7,s2
      state = 0;
     c5c:	4981                	li	s3,0
     c5e:	b7a5                	j	bc6 <vprintf+0x42>
     c60:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     c62:	008b8793          	addi	a5,s7,8
     c66:	8c3e                	mv	s8,a5
     c68:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     c6c:	03000593          	li	a1,48
     c70:	8556                	mv	a0,s5
     c72:	00000097          	auipc	ra,0x0
     c76:	e48080e7          	jalr	-440(ra) # aba <putc>
  putc(fd, 'x');
     c7a:	07800593          	li	a1,120
     c7e:	8556                	mv	a0,s5
     c80:	00000097          	auipc	ra,0x0
     c84:	e3a080e7          	jalr	-454(ra) # aba <putc>
     c88:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     c8a:	00001b97          	auipc	s7,0x1
     c8e:	9ceb8b93          	addi	s7,s7,-1586 # 1658 <digits>
     c92:	03c9d793          	srli	a5,s3,0x3c
     c96:	97de                	add	a5,a5,s7
     c98:	0007c583          	lbu	a1,0(a5)
     c9c:	8556                	mv	a0,s5
     c9e:	00000097          	auipc	ra,0x0
     ca2:	e1c080e7          	jalr	-484(ra) # aba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ca6:	0992                	slli	s3,s3,0x4
     ca8:	397d                	addiw	s2,s2,-1
     caa:	fe0914e3          	bnez	s2,c92 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     cae:	8be2                	mv	s7,s8
      state = 0;
     cb0:	4981                	li	s3,0
     cb2:	6c02                	ld	s8,0(sp)
     cb4:	bf09                	j	bc6 <vprintf+0x42>
        s = va_arg(ap, char*);
     cb6:	008b8993          	addi	s3,s7,8
     cba:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     cbe:	02090163          	beqz	s2,ce0 <vprintf+0x15c>
        while(*s != 0){
     cc2:	00094583          	lbu	a1,0(s2)
     cc6:	c9a5                	beqz	a1,d36 <vprintf+0x1b2>
          putc(fd, *s);
     cc8:	8556                	mv	a0,s5
     cca:	00000097          	auipc	ra,0x0
     cce:	df0080e7          	jalr	-528(ra) # aba <putc>
          s++;
     cd2:	0905                	addi	s2,s2,1
        while(*s != 0){
     cd4:	00094583          	lbu	a1,0(s2)
     cd8:	f9e5                	bnez	a1,cc8 <vprintf+0x144>
        s = va_arg(ap, char*);
     cda:	8bce                	mv	s7,s3
      state = 0;
     cdc:	4981                	li	s3,0
     cde:	b5e5                	j	bc6 <vprintf+0x42>
          s = "(null)";
     ce0:	00001917          	auipc	s2,0x1
     ce4:	8d090913          	addi	s2,s2,-1840 # 15b0 <ithread_join+0x472>
        while(*s != 0){
     ce8:	02800593          	li	a1,40
     cec:	bff1                	j	cc8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     cee:	008b8913          	addi	s2,s7,8
     cf2:	000bc583          	lbu	a1,0(s7)
     cf6:	8556                	mv	a0,s5
     cf8:	00000097          	auipc	ra,0x0
     cfc:	dc2080e7          	jalr	-574(ra) # aba <putc>
     d00:	8bca                	mv	s7,s2
      state = 0;
     d02:	4981                	li	s3,0
     d04:	b5c9                	j	bc6 <vprintf+0x42>
        putc(fd, c);
     d06:	02500593          	li	a1,37
     d0a:	8556                	mv	a0,s5
     d0c:	00000097          	auipc	ra,0x0
     d10:	dae080e7          	jalr	-594(ra) # aba <putc>
      state = 0;
     d14:	4981                	li	s3,0
     d16:	bd45                	j	bc6 <vprintf+0x42>
        putc(fd, '%');
     d18:	02500593          	li	a1,37
     d1c:	8556                	mv	a0,s5
     d1e:	00000097          	auipc	ra,0x0
     d22:	d9c080e7          	jalr	-612(ra) # aba <putc>
        putc(fd, c);
     d26:	85ca                	mv	a1,s2
     d28:	8556                	mv	a0,s5
     d2a:	00000097          	auipc	ra,0x0
     d2e:	d90080e7          	jalr	-624(ra) # aba <putc>
      state = 0;
     d32:	4981                	li	s3,0
     d34:	bd49                	j	bc6 <vprintf+0x42>
        s = va_arg(ap, char*);
     d36:	8bce                	mv	s7,s3
      state = 0;
     d38:	4981                	li	s3,0
     d3a:	b571                	j	bc6 <vprintf+0x42>
     d3c:	74e2                	ld	s1,56(sp)
     d3e:	79a2                	ld	s3,40(sp)
     d40:	7a02                	ld	s4,32(sp)
     d42:	6ae2                	ld	s5,24(sp)
     d44:	6b42                	ld	s6,16(sp)
     d46:	6ba2                	ld	s7,8(sp)
    }
  }
}
     d48:	60a6                	ld	ra,72(sp)
     d4a:	6406                	ld	s0,64(sp)
     d4c:	7942                	ld	s2,48(sp)
     d4e:	6161                	addi	sp,sp,80
     d50:	8082                	ret

0000000000000d52 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d52:	715d                	addi	sp,sp,-80
     d54:	ec06                	sd	ra,24(sp)
     d56:	e822                	sd	s0,16(sp)
     d58:	1000                	addi	s0,sp,32
     d5a:	e010                	sd	a2,0(s0)
     d5c:	e414                	sd	a3,8(s0)
     d5e:	e818                	sd	a4,16(s0)
     d60:	ec1c                	sd	a5,24(s0)
     d62:	03043023          	sd	a6,32(s0)
     d66:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d6a:	8622                	mv	a2,s0
     d6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d70:	00000097          	auipc	ra,0x0
     d74:	e14080e7          	jalr	-492(ra) # b84 <vprintf>
}
     d78:	60e2                	ld	ra,24(sp)
     d7a:	6442                	ld	s0,16(sp)
     d7c:	6161                	addi	sp,sp,80
     d7e:	8082                	ret

0000000000000d80 <printf>:

void
printf(const char *fmt, ...)
{
     d80:	711d                	addi	sp,sp,-96
     d82:	ec06                	sd	ra,24(sp)
     d84:	e822                	sd	s0,16(sp)
     d86:	1000                	addi	s0,sp,32
     d88:	e40c                	sd	a1,8(s0)
     d8a:	e810                	sd	a2,16(s0)
     d8c:	ec14                	sd	a3,24(s0)
     d8e:	f018                	sd	a4,32(s0)
     d90:	f41c                	sd	a5,40(s0)
     d92:	03043823          	sd	a6,48(s0)
     d96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     d9a:	00840613          	addi	a2,s0,8
     d9e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     da2:	85aa                	mv	a1,a0
     da4:	4505                	li	a0,1
     da6:	00000097          	auipc	ra,0x0
     daa:	dde080e7          	jalr	-546(ra) # b84 <vprintf>
}
     dae:	60e2                	ld	ra,24(sp)
     db0:	6442                	ld	s0,16(sp)
     db2:	6125                	addi	sp,sp,96
     db4:	8082                	ret

0000000000000db6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     db6:	1141                	addi	sp,sp,-16
     db8:	e406                	sd	ra,8(sp)
     dba:	e022                	sd	s0,0(sp)
     dbc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dbe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dc2:	00002797          	auipc	a5,0x2
     dc6:	a267b783          	ld	a5,-1498(a5) # 27e8 <freep>
     dca:	a039                	j	dd8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     dcc:	6398                	ld	a4,0(a5)
     dce:	00e7e463          	bltu	a5,a4,dd6 <free+0x20>
     dd2:	00e6ea63          	bltu	a3,a4,de6 <free+0x30>
{
     dd6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dd8:	fed7fae3          	bgeu	a5,a3,dcc <free+0x16>
     ddc:	6398                	ld	a4,0(a5)
     dde:	00e6e463          	bltu	a3,a4,de6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     de2:	fee7eae3          	bltu	a5,a4,dd6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     de6:	ff852583          	lw	a1,-8(a0)
     dea:	6390                	ld	a2,0(a5)
     dec:	02059813          	slli	a6,a1,0x20
     df0:	01c85713          	srli	a4,a6,0x1c
     df4:	9736                	add	a4,a4,a3
     df6:	02e60563          	beq	a2,a4,e20 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     dfa:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     dfe:	4790                	lw	a2,8(a5)
     e00:	02061593          	slli	a1,a2,0x20
     e04:	01c5d713          	srli	a4,a1,0x1c
     e08:	973e                	add	a4,a4,a5
     e0a:	02e68263          	beq	a3,a4,e2e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     e0e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     e10:	00002717          	auipc	a4,0x2
     e14:	9cf73c23          	sd	a5,-1576(a4) # 27e8 <freep>
}
     e18:	60a2                	ld	ra,8(sp)
     e1a:	6402                	ld	s0,0(sp)
     e1c:	0141                	addi	sp,sp,16
     e1e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
     e20:	4618                	lw	a4,8(a2)
     e22:	9f2d                	addw	a4,a4,a1
     e24:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e28:	6398                	ld	a4,0(a5)
     e2a:	6310                	ld	a2,0(a4)
     e2c:	b7f9                	j	dfa <free+0x44>
    p->s.size += bp->s.size;
     e2e:	ff852703          	lw	a4,-8(a0)
     e32:	9f31                	addw	a4,a4,a2
     e34:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e36:	ff053683          	ld	a3,-16(a0)
     e3a:	bfd1                	j	e0e <free+0x58>

0000000000000e3c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f04a                	sd	s2,32(sp)
     e44:	ec4e                	sd	s3,24(sp)
     e46:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e48:	02051993          	slli	s3,a0,0x20
     e4c:	0209d993          	srli	s3,s3,0x20
     e50:	09bd                	addi	s3,s3,15
     e52:	0049d993          	srli	s3,s3,0x4
     e56:	2985                	addiw	s3,s3,1
     e58:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     e5a:	00002517          	auipc	a0,0x2
     e5e:	98e53503          	ld	a0,-1650(a0) # 27e8 <freep>
     e62:	c905                	beqz	a0,e92 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e66:	4798                	lw	a4,8(a5)
     e68:	09377a63          	bgeu	a4,s3,efc <malloc+0xc0>
     e6c:	f426                	sd	s1,40(sp)
     e6e:	e852                	sd	s4,16(sp)
     e70:	e456                	sd	s5,8(sp)
     e72:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     e74:	8a4e                	mv	s4,s3
     e76:	6705                	lui	a4,0x1
     e78:	00e9f363          	bgeu	s3,a4,e7e <malloc+0x42>
     e7c:	6a05                	lui	s4,0x1
     e7e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     e82:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     e86:	00002497          	auipc	s1,0x2
     e8a:	96248493          	addi	s1,s1,-1694 # 27e8 <freep>
  if(p == (char*)-1)
     e8e:	5afd                	li	s5,-1
     e90:	a089                	j	ed2 <malloc+0x96>
     e92:	f426                	sd	s1,40(sp)
     e94:	e852                	sd	s4,16(sp)
     e96:	e456                	sd	s5,8(sp)
     e98:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     e9a:	00002797          	auipc	a5,0x2
     e9e:	96678793          	addi	a5,a5,-1690 # 2800 <base>
     ea2:	00002717          	auipc	a4,0x2
     ea6:	94f73323          	sd	a5,-1722(a4) # 27e8 <freep>
     eaa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     eac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     eb0:	b7d1                	j	e74 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
     eb2:	6398                	ld	a4,0(a5)
     eb4:	e118                	sd	a4,0(a0)
     eb6:	a8b9                	j	f14 <malloc+0xd8>
  hp->s.size = nu;
     eb8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     ebc:	0541                	addi	a0,a0,16
     ebe:	00000097          	auipc	ra,0x0
     ec2:	ef8080e7          	jalr	-264(ra) # db6 <free>
  return freep;
     ec6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
     ec8:	c135                	beqz	a0,f2c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     eca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     ecc:	4798                	lw	a4,8(a5)
     ece:	03277363          	bgeu	a4,s2,ef4 <malloc+0xb8>
    if(p == freep)
     ed2:	6098                	ld	a4,0(s1)
     ed4:	853e                	mv	a0,a5
     ed6:	fef71ae3          	bne	a4,a5,eca <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
     eda:	8552                	mv	a0,s4
     edc:	00000097          	auipc	ra,0x0
     ee0:	b7e080e7          	jalr	-1154(ra) # a5a <sbrk>
  if(p == (char*)-1)
     ee4:	fd551ae3          	bne	a0,s5,eb8 <malloc+0x7c>
        return 0;
     ee8:	4501                	li	a0,0
     eea:	74a2                	ld	s1,40(sp)
     eec:	6a42                	ld	s4,16(sp)
     eee:	6aa2                	ld	s5,8(sp)
     ef0:	6b02                	ld	s6,0(sp)
     ef2:	a03d                	j	f20 <malloc+0xe4>
     ef4:	74a2                	ld	s1,40(sp)
     ef6:	6a42                	ld	s4,16(sp)
     ef8:	6aa2                	ld	s5,8(sp)
     efa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     efc:	fae90be3          	beq	s2,a4,eb2 <malloc+0x76>
        p->s.size -= nunits;
     f00:	4137073b          	subw	a4,a4,s3
     f04:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f06:	02071693          	slli	a3,a4,0x20
     f0a:	01c6d713          	srli	a4,a3,0x1c
     f0e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     f10:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     f14:	00002717          	auipc	a4,0x2
     f18:	8ca73a23          	sd	a0,-1836(a4) # 27e8 <freep>
      return (void*)(p + 1);
     f1c:	01078513          	addi	a0,a5,16
  }
}
     f20:	70e2                	ld	ra,56(sp)
     f22:	7442                	ld	s0,48(sp)
     f24:	7902                	ld	s2,32(sp)
     f26:	69e2                	ld	s3,24(sp)
     f28:	6121                	addi	sp,sp,64
     f2a:	8082                	ret
     f2c:	74a2                	ld	s1,40(sp)
     f2e:	6a42                	ld	s4,16(sp)
     f30:	6aa2                	ld	s5,8(sp)
     f32:	6b02                	ld	s6,0(sp)
     f34:	b7f5                	j	f20 <malloc+0xe4>

0000000000000f36 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     f36:	1141                	addi	sp,sp,-16
     f38:	e406                	sd	ra,8(sp)
     f3a:	e022                	sd	s0,0(sp)
     f3c:	0800                	addi	s0,sp,16
  thread_exit(status);
     f3e:	2501                	sext.w	a0,a0
     f40:	00000097          	auipc	ra,0x0
     f44:	b4a080e7          	jalr	-1206(ra) # a8a <thread_exit>
}
     f48:	60a2                	ld	ra,8(sp)
     f4a:	6402                	ld	s0,0(sp)
     f4c:	0141                	addi	sp,sp,16
     f4e:	8082                	ret

0000000000000f50 <free_stacks>:
int free_stacks() {
     f50:	7179                	addi	sp,sp,-48
     f52:	f406                	sd	ra,40(sp)
     f54:	f022                	sd	s0,32(sp)
     f56:	ec26                	sd	s1,24(sp)
     f58:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f5a:	00002797          	auipc	a5,0x2
     f5e:	89e7a783          	lw	a5,-1890(a5) # 27f8 <num_threads>
     f62:	04f05063          	blez	a5,fa2 <free_stacks+0x52>
     f66:	e84a                	sd	s2,16(sp)
     f68:	e44e                	sd	s3,8(sp)
     f6a:	4481                	li	s1,0
    free(stacks[i]);
     f6c:	00002997          	auipc	s3,0x2
     f70:	88498993          	addi	s3,s3,-1916 # 27f0 <stacks>
  for (int i = 0; i < num_threads; i++) {
     f74:	00002917          	auipc	s2,0x2
     f78:	88490913          	addi	s2,s2,-1916 # 27f8 <num_threads>
    free(stacks[i]);
     f7c:	0009b783          	ld	a5,0(s3)
     f80:	00349713          	slli	a4,s1,0x3
     f84:	97ba                	add	a5,a5,a4
     f86:	6388                	ld	a0,0(a5)
     f88:	00000097          	auipc	ra,0x0
     f8c:	e2e080e7          	jalr	-466(ra) # db6 <free>
  for (int i = 0; i < num_threads; i++) {
     f90:	0485                	addi	s1,s1,1
     f92:	00092703          	lw	a4,0(s2)
     f96:	0004879b          	sext.w	a5,s1
     f9a:	fee7c1e3          	blt	a5,a4,f7c <free_stacks+0x2c>
     f9e:	6942                	ld	s2,16(sp)
     fa0:	69a2                	ld	s3,8(sp)
  free(stacks);
     fa2:	00002497          	auipc	s1,0x2
     fa6:	84e48493          	addi	s1,s1,-1970 # 27f0 <stacks>
     faa:	6088                	ld	a0,0(s1)
     fac:	00000097          	auipc	ra,0x0
     fb0:	e0a080e7          	jalr	-502(ra) # db6 <free>
  stacks = 0;
     fb4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     fb8:	00002797          	auipc	a5,0x2
     fbc:	8407a023          	sw	zero,-1984(a5) # 27f8 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     fc0:	47a1                	li	a5,8
     fc2:	00002717          	auipc	a4,0x2
     fc6:	80f72b23          	sw	a5,-2026(a4) # 27d8 <max_stacks>
  threads_done = 0;
     fca:	00002797          	auipc	a5,0x2
     fce:	8207a923          	sw	zero,-1998(a5) # 27fc <threads_done>
}
     fd2:	4501                	li	a0,0
     fd4:	70a2                	ld	ra,40(sp)
     fd6:	7402                	ld	s0,32(sp)
     fd8:	64e2                	ld	s1,24(sp)
     fda:	6145                	addi	sp,sp,48
     fdc:	8082                	ret

0000000000000fde <expand_num_threads>:
int expand_num_threads() {
     fde:	1101                	addi	sp,sp,-32
     fe0:	ec06                	sd	ra,24(sp)
     fe2:	e822                	sd	s0,16(sp)
     fe4:	e426                	sd	s1,8(sp)
     fe6:	e04a                	sd	s2,0(sp)
     fe8:	1000                	addi	s0,sp,32
  max_stacks *= 2;
     fea:	00001797          	auipc	a5,0x1
     fee:	7ee78793          	addi	a5,a5,2030 # 27d8 <max_stacks>
     ff2:	4388                	lw	a0,0(a5)
     ff4:	0015151b          	slliw	a0,a0,0x1
     ff8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
     ffa:	0035151b          	slliw	a0,a0,0x3
     ffe:	00000097          	auipc	ra,0x0
    1002:	e3e080e7          	jalr	-450(ra) # e3c <malloc>
    1006:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    1008:	00001617          	auipc	a2,0x1
    100c:	7f062603          	lw	a2,2032(a2) # 27f8 <num_threads>
    1010:	00001497          	auipc	s1,0x1
    1014:	7e048493          	addi	s1,s1,2016 # 27f0 <stacks>
    1018:	0036161b          	slliw	a2,a2,0x3
    101c:	608c                	ld	a1,0(s1)
    101e:	00000097          	auipc	ra,0x0
    1022:	8fe080e7          	jalr	-1794(ra) # 91c <memmove>
  free(stacks);
    1026:	6088                	ld	a0,0(s1)
    1028:	00000097          	auipc	ra,0x0
    102c:	d8e080e7          	jalr	-626(ra) # db6 <free>
  stacks = new_stacks;
    1030:	0124b023          	sd	s2,0(s1)
}
    1034:	4501                	li	a0,0
    1036:	60e2                	ld	ra,24(sp)
    1038:	6442                	ld	s0,16(sp)
    103a:	64a2                	ld	s1,8(sp)
    103c:	6902                	ld	s2,0(sp)
    103e:	6105                	addi	sp,sp,32
    1040:	8082                	ret

0000000000001042 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1042:	7179                	addi	sp,sp,-48
    1044:	f406                	sd	ra,40(sp)
    1046:	f022                	sd	s0,32(sp)
    1048:	e84a                	sd	s2,16(sp)
    104a:	e44e                	sd	s3,8(sp)
    104c:	1800                	addi	s0,sp,48
    104e:	892a                	mv	s2,a0
    1050:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1052:	00001797          	auipc	a5,0x1
    1056:	79e7b783          	ld	a5,1950(a5) # 27f0 <stacks>
    105a:	c3d9                	beqz	a5,10e0 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    105c:	00001797          	auipc	a5,0x1
    1060:	77c7a783          	lw	a5,1916(a5) # 27d8 <max_stacks>
    1064:	00001717          	auipc	a4,0x1
    1068:	79472703          	lw	a4,1940(a4) # 27f8 <num_threads>
    106c:	0af71463          	bne	a4,a5,1114 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
    1070:	04000713          	li	a4,64
    1074:	08e78563          	beq	a5,a4,10fe <ithread_create+0xbc>
    1078:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    107a:	00000097          	auipc	ra,0x0
    107e:	f64080e7          	jalr	-156(ra) # fde <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    1082:	6505                	lui	a0,0x1
    1084:	00000097          	auipc	ra,0x0
    1088:	db8080e7          	jalr	-584(ra) # e3c <malloc>
    108c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    108e:	00001717          	auipc	a4,0x1
    1092:	76a72703          	lw	a4,1898(a4) # 27f8 <num_threads>
    1096:	070e                	slli	a4,a4,0x3
    1098:	00001797          	auipc	a5,0x1
    109c:	7587b783          	ld	a5,1880(a5) # 27f0 <stacks>
    10a0:	97ba                	add	a5,a5,a4
    10a2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    10a4:	00000697          	auipc	a3,0x0
    10a8:	e9268693          	addi	a3,a3,-366 # f36 <ithread_exit>
    10ac:	862a                	mv	a2,a0
    10ae:	85ce                	mv	a1,s3
    10b0:	854a                	mv	a0,s2
    10b2:	00000097          	auipc	ra,0x0
    10b6:	9c8080e7          	jalr	-1592(ra) # a7a <create_thread>
    10ba:	892a                	mv	s2,a0
  if (res != -1) {
    10bc:	57fd                	li	a5,-1
    10be:	04f50d63          	beq	a0,a5,1118 <ithread_create+0xd6>
    num_threads++;
    10c2:	00001717          	auipc	a4,0x1
    10c6:	73670713          	addi	a4,a4,1846 # 27f8 <num_threads>
    10ca:	431c                	lw	a5,0(a4)
    10cc:	2785                	addiw	a5,a5,1
    10ce:	c31c                	sw	a5,0(a4)
    10d0:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    10d2:	854a                	mv	a0,s2
    10d4:	70a2                	ld	ra,40(sp)
    10d6:	7402                	ld	s0,32(sp)
    10d8:	6942                	ld	s2,16(sp)
    10da:	69a2                	ld	s3,8(sp)
    10dc:	6145                	addi	sp,sp,48
    10de:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    10e0:	00001517          	auipc	a0,0x1
    10e4:	6f852503          	lw	a0,1784(a0) # 27d8 <max_stacks>
    10e8:	0035151b          	slliw	a0,a0,0x3
    10ec:	00000097          	auipc	ra,0x0
    10f0:	d50080e7          	jalr	-688(ra) # e3c <malloc>
    10f4:	00001797          	auipc	a5,0x1
    10f8:	6ea7be23          	sd	a0,1788(a5) # 27f0 <stacks>
    10fc:	b785                	j	105c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    10fe:	00000517          	auipc	a0,0x0
    1102:	4ba50513          	addi	a0,a0,1210 # 15b8 <ithread_join+0x47a>
    1106:	00000097          	auipc	ra,0x0
    110a:	c7a080e7          	jalr	-902(ra) # d80 <printf>
      return -1;
    110e:	57fd                	li	a5,-1
    1110:	893e                	mv	s2,a5
    1112:	b7c1                	j	10d2 <ithread_create+0x90>
    1114:	ec26                	sd	s1,24(sp)
    1116:	b7b5                	j	1082 <ithread_create+0x40>
    free(stack_ptr);
    1118:	8526                	mv	a0,s1
    111a:	00000097          	auipc	ra,0x0
    111e:	c9c080e7          	jalr	-868(ra) # db6 <free>
    stacks[num_threads] = 0;
    1122:	00001717          	auipc	a4,0x1
    1126:	6d672703          	lw	a4,1750(a4) # 27f8 <num_threads>
    112a:	070e                	slli	a4,a4,0x3
    112c:	00001797          	auipc	a5,0x1
    1130:	6c47b783          	ld	a5,1732(a5) # 27f0 <stacks>
    1134:	97ba                	add	a5,a5,a4
    1136:	0007b023          	sd	zero,0(a5)
    113a:	64e2                	ld	s1,24(sp)
    113c:	bf59                	j	10d2 <ithread_create+0x90>

000000000000113e <ithread_join>:

int ithread_join(int thread_id) {
    113e:	1101                	addi	sp,sp,-32
    1140:	ec06                	sd	ra,24(sp)
    1142:	e822                	sd	s0,16(sp)
    1144:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1146:	ff040793          	addi	a5,s0,-16
    114a:	ffc7859b          	addiw	a1,a5,-4
    114e:	00000097          	auipc	ra,0x0
    1152:	934080e7          	jalr	-1740(ra) # a82 <join_thread>
  threads_done++;
    1156:	00001717          	auipc	a4,0x1
    115a:	6a670713          	addi	a4,a4,1702 # 27fc <threads_done>
    115e:	431c                	lw	a5,0(a4)
    1160:	2785                	addiw	a5,a5,1
    1162:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    1164:	00001717          	auipc	a4,0x1
    1168:	69472703          	lw	a4,1684(a4) # 27f8 <num_threads>
    116c:	00f70863          	beq	a4,a5,117c <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    1170:	fec42503          	lw	a0,-20(s0)
    1174:	60e2                	ld	ra,24(sp)
    1176:	6442                	ld	s0,16(sp)
    1178:	6105                	addi	sp,sp,32
    117a:	8082                	ret
    free_stacks();
    117c:	00000097          	auipc	ra,0x0
    1180:	dd4080e7          	jalr	-556(ra) # f50 <free_stacks>
    1184:	b7f5                	j	1170 <ithread_join+0x32>
