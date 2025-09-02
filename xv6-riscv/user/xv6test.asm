
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
      4a:	a32080e7          	jalr	-1486(ra) # a78 <sleep>
  printf("Test 6 FAILED: exit_all failed\n");
      4e:	00001517          	auipc	a0,0x1
      52:	16250513          	addi	a0,a0,354 # 11b0 <ithread_join+0x48>
      56:	00001097          	auipc	ra,0x1
      5a:	d56080e7          	jalr	-682(ra) # dac <printf>
}
      5e:	4501                	li	a0,0
      60:	60a2                	ld	ra,8(sp)
      62:	6402                	ld	s0,0(sp)
      64:	0141                	addi	sp,sp,16
      66:	8082                	ret
    sleep(5);
      68:	4515                	li	a0,5
      6a:	00001097          	auipc	ra,0x1
      6e:	a0e080e7          	jalr	-1522(ra) # a78 <sleep>
    exit(0);
      72:	4501                	li	a0,0
      74:	00001097          	auipc	ra,0x1
      78:	974080e7          	jalr	-1676(ra) # 9e8 <exit>

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
      8e:	9ee080e7          	jalr	-1554(ra) # a78 <sleep>
  int val = p[0]; // should be 42 before deallocation
      92:	00002497          	auipc	s1,0x2
      96:	73e48493          	addi	s1,s1,1854 # 27d0 <p>
      9a:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
      9c:	438c                	lw	a1,0(a5)
      9e:	00001517          	auipc	a0,0x1
      a2:	13250513          	addi	a0,a0,306 # 11d0 <ithread_join+0x68>
      a6:	00001097          	auipc	ra,0x1
      aa:	d06080e7          	jalr	-762(ra) # dac <printf>
  sleep(40); // wait for deallocation
      ae:	02800513          	li	a0,40
      b2:	00001097          	auipc	ra,0x1
      b6:	9c6080e7          	jalr	-1594(ra) # a78 <sleep>
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
      ba:	6098                	ld	a4,0(s1)
      bc:	37ab77b7          	lui	a5,0x37ab7
      c0:	078a                	slli	a5,a5,0x2
      c2:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab46ef>
      c6:	04f70763          	beq	a4,a5,114 <prop_mem_dealloc2+0x98>
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
      ca:	00001517          	auipc	a0,0x1
      ce:	13e50513          	addi	a0,a0,318 # 1208 <ithread_join+0xa0>
      d2:	00001097          	auipc	ra,0x1
      d6:	cda080e7          	jalr	-806(ra) # dac <printf>
  fail = p[0]; // this should ideally trap or fail
      da:	00002797          	auipc	a5,0x2
      de:	6f67b783          	ld	a5,1782(a5) # 27d0 <p>
      e2:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e4:	85a6                	mv	a1,s1
      e6:	00001517          	auipc	a0,0x1
      ea:	15250513          	addi	a0,a0,338 # 1238 <ithread_join+0xd0>
      ee:	00001097          	auipc	ra,0x1
      f2:	cbe080e7          	jalr	-834(ra) # dac <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f6:	85a6                	mv	a1,s1
      f8:	00001517          	auipc	a0,0x1
      fc:	15850513          	addi	a0,a0,344 # 1250 <ithread_join+0xe8>
     100:	00001097          	auipc	ra,0x1
     104:	cac080e7          	jalr	-852(ra) # dac <printf>
}
     108:	4501                	li	a0,0
     10a:	60e2                	ld	ra,24(sp)
     10c:	6442                	ld	s0,16(sp)
     10e:	64a2                	ld	s1,8(sp)
     110:	6105                	addi	sp,sp,32
     112:	8082                	ret
    printf("FAIL: p is invalid\n");
     114:	00001517          	auipc	a0,0x1
     118:	0dc50513          	addi	a0,a0,220 # 11f0 <ithread_join+0x88>
     11c:	00001097          	auipc	ra,0x1
     120:	c90080e7          	jalr	-880(ra) # dac <printf>
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
     136:	946080e7          	jalr	-1722(ra) # a78 <sleep>
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
     164:	14050513          	addi	a0,a0,320 # 12a0 <ithread_join+0x138>
     168:	00001097          	auipc	ra,0x1
     16c:	c44080e7          	jalr	-956(ra) # dac <printf>
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
     17e:	10650513          	addi	a0,a0,262 # 1280 <ithread_join+0x118>
     182:	00001097          	auipc	ra,0x1
     186:	c2a080e7          	jalr	-982(ra) # dac <printf>
    return 0;
     18a:	b7dd                	j	170 <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18c:	00001517          	auipc	a0,0x1
     190:	10c50513          	addi	a0,a0,268 # 1298 <ithread_join+0x130>
     194:	00001097          	auipc	ra,0x1
     198:	c18080e7          	jalr	-1000(ra) # dac <printf>
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
     1ae:	8c6080e7          	jalr	-1850(ra) # a70 <sbrk>
     1b2:	00002497          	auipc	s1,0x2
     1b6:	61e48493          	addi	s1,s1,1566 # 27d0 <p>
     1ba:	e088                	sd	a0,0(s1)
  p[0] = 42;
     1bc:	02a00793          	li	a5,42
     1c0:	c11c                	sw	a5,0(a0)
  sleep(80);              // allow thread 2 to read
     1c2:	05000513          	li	a0,80
     1c6:	00001097          	auipc	ra,0x1
     1ca:	8b2080e7          	jalr	-1870(ra) # a78 <sleep>
  p = (int *)sbrk(-4096);            // deallocate
     1ce:	757d                	lui	a0,0xfffff
     1d0:	00001097          	auipc	ra,0x1
     1d4:	8a0080e7          	jalr	-1888(ra) # a70 <sbrk>
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
     1f4:	880080e7          	jalr	-1920(ra) # a70 <sbrk>
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
     224:	00052903          	lw	s2,0(a0) # 1000 <free_stacks+0x84>
  printf("Thread %d is running\n", val);
     228:	85ca                	mv	a1,s2
     22a:	00001517          	auipc	a0,0x1
     22e:	0a650513          	addi	a0,a0,166 # 12d0 <ithread_join+0x168>
     232:	00001097          	auipc	ra,0x1
     236:	b7a080e7          	jalr	-1158(ra) # dac <printf>
  free(arg);
     23a:	8526                	mv	a0,s1
     23c:	00001097          	auipc	ra,0x1
     240:	ba6080e7          	jalr	-1114(ra) # de2 <free>
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
     262:	d04080e7          	jalr	-764(ra) # f62 <ithread_exit>
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
     27c:	07050513          	addi	a0,a0,112 # 12e8 <ithread_join+0x180>
     280:	00001097          	auipc	ra,0x1
     284:	b2c080e7          	jalr	-1236(ra) # dac <printf>
  int *arg = malloc(sizeof(int));
     288:	4511                	li	a0,4
     28a:	00001097          	auipc	ra,0x1
     28e:	bde080e7          	jalr	-1058(ra) # e68 <malloc>
     292:	85aa                	mv	a1,a0
  *arg = 0;
     294:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     298:	00000517          	auipc	a0,0x0
     29c:	f7e50513          	addi	a0,a0,-130 # 216 <thread_func_basic>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	dce080e7          	jalr	-562(ra) # 106e <ithread_create>
  if (tid < 0) {
     2a8:	02054763          	bltz	a0,2d6 <test_thread_create+0x66>
     2ac:	e426                	sd	s1,8(sp)
     2ae:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2b0:	85aa                	mv	a1,a0
     2b2:	00001517          	auipc	a0,0x1
     2b6:	07e50513          	addi	a0,a0,126 # 1330 <ithread_join+0x1c8>
     2ba:	00001097          	auipc	ra,0x1
     2be:	af2080e7          	jalr	-1294(ra) # dac <printf>
    ithread_join(tid);
     2c2:	8526                	mv	a0,s1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	ea4080e7          	jalr	-348(ra) # 1168 <ithread_join>
     2cc:	64a2                	ld	s1,8(sp)
}
     2ce:	60e2                	ld	ra,24(sp)
     2d0:	6442                	ld	s0,16(sp)
     2d2:	6105                	addi	sp,sp,32
     2d4:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	03250513          	addi	a0,a0,50 # 1308 <ithread_join+0x1a0>
     2de:	00001097          	auipc	ra,0x1
     2e2:	ace080e7          	jalr	-1330(ra) # dac <printf>
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
     2f8:	06c50513          	addi	a0,a0,108 # 1360 <ithread_join+0x1f8>
     2fc:	00001097          	auipc	ra,0x1
     300:	ab0080e7          	jalr	-1360(ra) # dac <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     304:	4581                	li	a1,0
     306:	00000517          	auipc	a0,0x0
     30a:	e9850513          	addi	a0,a0,-360 # 19e <prop_mem_dealloc1>
     30e:	00001097          	auipc	ra,0x1
     312:	d60080e7          	jalr	-672(ra) # 106e <ithread_create>
     316:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     318:	4581                	li	a1,0
     31a:	00000517          	auipc	a0,0x0
     31e:	d6250513          	addi	a0,a0,-670 # 7c <prop_mem_dealloc2>
     322:	00001097          	auipc	ra,0x1
     326:	d4c080e7          	jalr	-692(ra) # 106e <ithread_create>
     32a:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32c:	854a                	mv	a0,s2
     32e:	00001097          	auipc	ra,0x1
     332:	e3a080e7          	jalr	-454(ra) # 1168 <ithread_join>
  ithread_join(tid2);
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	e30080e7          	jalr	-464(ra) # 1168 <ithread_join>
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
     35c:	02050513          	addi	a0,a0,32 # 1378 <ithread_join+0x210>
     360:	00001097          	auipc	ra,0x1
     364:	a4c080e7          	jalr	-1460(ra) # dac <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     368:	4581                	li	a1,0
     36a:	00000517          	auipc	a0,0x0
     36e:	e7c50513          	addi	a0,a0,-388 # 1e6 <prop_mem_alloc1>
     372:	00001097          	auipc	ra,0x1
     376:	cfc080e7          	jalr	-772(ra) # 106e <ithread_create>
     37a:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37c:	4581                	li	a1,0
     37e:	00000517          	auipc	a0,0x0
     382:	da850513          	addi	a0,a0,-600 # 126 <prop_mem_alloc2>
     386:	00001097          	auipc	ra,0x1
     38a:	ce8080e7          	jalr	-792(ra) # 106e <ithread_create>
     38e:	84aa                	mv	s1,a0
  ithread_join(tid1);
     390:	854a                	mv	a0,s2
     392:	00001097          	auipc	ra,0x1
     396:	dd6080e7          	jalr	-554(ra) # 1168 <ithread_join>
  ithread_join(tid2);
     39a:	8526                	mv	a0,s1
     39c:	00001097          	auipc	ra,0x1
     3a0:	dcc080e7          	jalr	-564(ra) # 1168 <ithread_join>

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
     3bc:	fd850513          	addi	a0,a0,-40 # 1390 <ithread_join+0x228>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	9ec080e7          	jalr	-1556(ra) # dac <printf>

  int *arg = malloc(sizeof(int));
     3c8:	4511                	li	a0,4
     3ca:	00001097          	auipc	ra,0x1
     3ce:	a9e080e7          	jalr	-1378(ra) # e68 <malloc>
     3d2:	85aa                	mv	a1,a0
  *arg = 100;
     3d4:	06400793          	li	a5,100
     3d8:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3da:	00000517          	auipc	a0,0x0
     3de:	e3c50513          	addi	a0,a0,-452 # 216 <thread_func_basic>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	c8c080e7          	jalr	-884(ra) # 106e <ithread_create>

  if (tid < 0) {
     3ea:	02054763          	bltz	a0,418 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ee:	00001097          	auipc	ra,0x1
     3f2:	d7a080e7          	jalr	-646(ra) # 1168 <ithread_join>
     3f6:	85aa                	mv	a1,a0
  if (status == 101) {
     3f8:	06500793          	li	a5,101
     3fc:	02f50763          	beq	a0,a5,42a <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     400:	00001517          	auipc	a0,0x1
     404:	01050513          	addi	a0,a0,16 # 1410 <ithread_join+0x2a8>
     408:	00001097          	auipc	ra,0x1
     40c:	9a4080e7          	jalr	-1628(ra) # dac <printf>
  }
}
     410:	60a2                	ld	ra,8(sp)
     412:	6402                	ld	s0,0(sp)
     414:	0141                	addi	sp,sp,16
     416:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     418:	00001517          	auipc	a0,0x1
     41c:	f9850513          	addi	a0,a0,-104 # 13b0 <ithread_join+0x248>
     420:	00001097          	auipc	ra,0x1
     424:	98c080e7          	jalr	-1652(ra) # dac <printf>
    return;
     428:	b7e5                	j	410 <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     42a:	85be                	mv	a1,a5
     42c:	00001517          	auipc	a0,0x1
     430:	fb450513          	addi	a0,a0,-76 # 13e0 <ithread_join+0x278>
     434:	00001097          	auipc	ra,0x1
     438:	978080e7          	jalr	-1672(ra) # dac <printf>
     43c:	bfd1                	j	410 <test_thread_join+0x60>

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
     452:	fea50513          	addi	a0,a0,-22 # 1438 <ithread_join+0x2d0>
     456:	00001097          	auipc	ra,0x1
     45a:	956080e7          	jalr	-1706(ra) # dac <printf>

  shared_counter = 0;
     45e:	00002797          	auipc	a5,0x2
     462:	3807a123          	sw	zero,898(a5) # 27e0 <shared_counter>
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
     480:	bf2080e7          	jalr	-1038(ra) # 106e <ithread_create>
     484:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     488:	0911                	addi	s2,s2,4
     48a:	ff3917e3          	bne	s2,s3,478 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48e:	4088                	lw	a0,0(s1)
     490:	00001097          	auipc	ra,0x1
     494:	cd8080e7          	jalr	-808(ra) # 1168 <ithread_join>
  for (int i = 0; i < 4; i++) {
     498:	0491                	addi	s1,s1,4
     49a:	ff349ae3          	bne	s1,s3,48e <test_shared_memory+0x50>
  }

  if (shared_counter == 200) {
     49e:	00002597          	auipc	a1,0x2
     4a2:	3425a583          	lw	a1,834(a1) # 27e0 <shared_counter>
     4a6:	0c800793          	li	a5,200
     4aa:	02f58263          	beq	a1,a5,4ce <test_shared_memory+0x90>
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
  } else {
    printf("Test 3 FAILED - shared_counter = %d\n", shared_counter);
     4ae:	00001517          	auipc	a0,0x1
     4b2:	fda50513          	addi	a0,a0,-38 # 1488 <ithread_join+0x320>
     4b6:	00001097          	auipc	ra,0x1
     4ba:	8f6080e7          	jalr	-1802(ra) # dac <printf>
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
     4ce:	85be                	mv	a1,a5
     4d0:	00001517          	auipc	a0,0x1
     4d4:	f9050513          	addi	a0,a0,-112 # 1460 <ithread_join+0x2f8>
     4d8:	00001097          	auipc	ra,0x1
     4dc:	8d4080e7          	jalr	-1836(ra) # dac <printf>
     4e0:	bff9                	j	4be <test_shared_memory+0x80>

00000000000004e2 <test_exit>:

//test exit off of return

void test_exit() {
     4e2:	1141                	addi	sp,sp,-16
     4e4:	e406                	sd	ra,8(sp)
     4e6:	e022                	sd	s0,0(sp)
     4e8:	0800                	addi	s0,sp,16
  printf("Test 4: Graceful exit via ithread_exit\n");
     4ea:	00001517          	auipc	a0,0x1
     4ee:	fc650513          	addi	a0,a0,-58 # 14b0 <ithread_join+0x348>
     4f2:	00001097          	auipc	ra,0x1
     4f6:	8ba080e7          	jalr	-1862(ra) # dac <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4fa:	4581                	li	a1,0
     4fc:	00000517          	auipc	a0,0x0
     500:	d5850513          	addi	a0,a0,-680 # 254 <thread_func_exit>
     504:	00001097          	auipc	ra,0x1
     508:	b6a080e7          	jalr	-1174(ra) # 106e <ithread_create>
  int status = ithread_join(tid);
     50c:	00001097          	auipc	ra,0x1
     510:	c5c080e7          	jalr	-932(ra) # 1168 <ithread_join>
     514:	85aa                	mv	a1,a0

  if (status == 0) {
     516:	ed09                	bnez	a0,530 <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     518:	00001517          	auipc	a0,0x1
     51c:	fc050513          	addi	a0,a0,-64 # 14d8 <ithread_join+0x370>
     520:	00001097          	auipc	ra,0x1
     524:	88c080e7          	jalr	-1908(ra) # dac <printf>
  } else {
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
  }
}
     528:	60a2                	ld	ra,8(sp)
     52a:	6402                	ld	s0,0(sp)
     52c:	0141                	addi	sp,sp,16
     52e:	8082                	ret
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
     530:	00001517          	auipc	a0,0x1
     534:	fe850513          	addi	a0,a0,-24 # 1518 <ithread_join+0x3b0>
     538:	00001097          	auipc	ra,0x1
     53c:	874080e7          	jalr	-1932(ra) # dac <printf>
}
     540:	b7e5                	j	528 <test_exit+0x46>

0000000000000542 <test_exit_all>:

void test_exit_all() {
     542:	7119                	addi	sp,sp,-128
     544:	fc86                	sd	ra,120(sp)
     546:	f8a2                	sd	s0,112(sp)
     548:	f4a6                	sd	s1,104(sp)
     54a:	f0ca                	sd	s2,96(sp)
     54c:	ecce                	sd	s3,88(sp)
     54e:	e8d2                	sd	s4,80(sp)
     550:	e4d6                	sd	s5,72(sp)
     552:	e0da                	sd	s6,64(sp)
     554:	fc5e                	sd	s7,56(sp)
     556:	0100                	addi	s0,sp,128
  printf("Test 5: Graceful exit of all threads via exit\n");
     558:	00001517          	auipc	a0,0x1
     55c:	ff050513          	addi	a0,a0,-16 # 1548 <ithread_join+0x3e0>
     560:	00001097          	auipc	ra,0x1
     564:	84c080e7          	jalr	-1972(ra) # dac <printf>
  int *num = malloc(10*sizeof(int));
     568:	02800513          	li	a0,40
     56c:	00001097          	auipc	ra,0x1
     570:	8fc080e7          	jalr	-1796(ra) # e68 <malloc>
     574:	8baa                	mv	s7,a0
  int tids[10];
  for (int i = 0; i < 10; i++) {
     576:	89aa                	mv	s3,a0
     578:	f8840493          	addi	s1,s0,-120
  int *num = malloc(10*sizeof(int));
     57c:	8a26                	mv	s4,s1
  for (int i = 0; i < 10; i++) {
     57e:	4901                	li	s2,0
    num[i] = i;
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     580:	00000b17          	auipc	s6,0x0
     584:	ab2b0b13          	addi	s6,s6,-1358 # 32 <exit_all>
  for (int i = 0; i < 10; i++) {
     588:	4aa9                	li	s5,10
    num[i] = i;
     58a:	0129a023          	sw	s2,0(s3)
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
     58e:	85ce                	mv	a1,s3
     590:	855a                	mv	a0,s6
     592:	00001097          	auipc	ra,0x1
     596:	adc080e7          	jalr	-1316(ra) # 106e <ithread_create>
     59a:	00aa2023          	sw	a0,0(s4)
  for (int i = 0; i < 10; i++) {
     59e:	2905                	addiw	s2,s2,1
     5a0:	0991                	addi	s3,s3,4
     5a2:	0a11                	addi	s4,s4,4
     5a4:	ff5913e3          	bne	s2,s5,58a <test_exit_all+0x48>
     5a8:	fb040913          	addi	s2,s0,-80
  }
  for (int i = 0; i < 10; i++) {
    ithread_join(tids[i]);
     5ac:	4088                	lw	a0,0(s1)
     5ae:	00001097          	auipc	ra,0x1
     5b2:	bba080e7          	jalr	-1094(ra) # 1168 <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b6:	0491                	addi	s1,s1,4
     5b8:	ff249ae3          	bne	s1,s2,5ac <test_exit_all+0x6a>
  }
  free(num);
     5bc:	855e                	mv	a0,s7
     5be:	00001097          	auipc	ra,0x1
     5c2:	824080e7          	jalr	-2012(ra) # de2 <free>
}
     5c6:	70e6                	ld	ra,120(sp)
     5c8:	7446                	ld	s0,112(sp)
     5ca:	74a6                	ld	s1,104(sp)
     5cc:	7906                	ld	s2,96(sp)
     5ce:	69e6                	ld	s3,88(sp)
     5d0:	6a46                	ld	s4,80(sp)
     5d2:	6aa6                	ld	s5,72(sp)
     5d4:	6b06                	ld	s6,64(sp)
     5d6:	7be2                	ld	s7,56(sp)
     5d8:	6109                	addi	sp,sp,128
     5da:	8082                	ret

00000000000005dc <main>:

int main(int argc, char *argv[]) {
     5dc:	1101                	addi	sp,sp,-32
     5de:	ec06                	sd	ra,24(sp)
     5e0:	e822                	sd	s0,16(sp)
     5e2:	1000                	addi	s0,sp,32
  if (argc > 2) {
     5e4:	4789                	li	a5,2
     5e6:	02a7d163          	bge	a5,a0,608 <main+0x2c>
     5ea:	e426                	sd	s1,8(sp)
    printf("Needs the format: xv6test (1-7)\n", argv[0]);
     5ec:	618c                	ld	a1,0(a1)
     5ee:	00001517          	auipc	a0,0x1
     5f2:	f8a50513          	addi	a0,a0,-118 # 1578 <ithread_join+0x410>
     5f6:	00000097          	auipc	ra,0x0
     5fa:	7b6080e7          	jalr	1974(ra) # dac <printf>
    exit(1);
     5fe:	4505                	li	a0,1
     600:	00000097          	auipc	ra,0x0
     604:	3e8080e7          	jalr	1000(ra) # 9e8 <exit>
     608:	e426                	sd	s1,8(sp)
     60a:	84aa                	mv	s1,a0
  }

  int test = atoi(argv[1]);
     60c:	6588                	ld	a0,8(a1)
     60e:	00000097          	auipc	ra,0x0
     612:	2d4080e7          	jalr	724(ra) # 8e2 <atoi>
  if(argc == 2){ 
     616:	4789                	li	a5,2
     618:	06f49e63          	bne	s1,a5,694 <main+0xb8>
  switch (test) {
     61c:	357d                	addiw	a0,a0,-1
     61e:	4799                	li	a5,6
     620:	06a7e163          	bltu	a5,a0,682 <main+0xa6>
     624:	02051793          	slli	a5,a0,0x20
     628:	01e7d513          	srli	a0,a5,0x1e
     62c:	00001717          	auipc	a4,0x1
     630:	fd870713          	addi	a4,a4,-40 # 1604 <ithread_join+0x49c>
     634:	953a                	add	a0,a0,a4
     636:	411c                	lw	a5,0(a0)
     638:	97ba                	add	a5,a5,a4
     63a:	8782                	jr	a5
    case 1:
      test_thread_create();
     63c:	00000097          	auipc	ra,0x0
     640:	c34080e7          	jalr	-972(ra) # 270 <test_thread_create>
      break;
     644:	a0c5                	j	724 <main+0x148>
    case 2:
      test_thread_join();
     646:	00000097          	auipc	ra,0x0
     64a:	d6a080e7          	jalr	-662(ra) # 3b0 <test_thread_join>
      break;
     64e:	a8d9                	j	724 <main+0x148>
    case 3:
      test_shared_memory();
     650:	00000097          	auipc	ra,0x0
     654:	dee080e7          	jalr	-530(ra) # 43e <test_shared_memory>
      break;
     658:	a0f1                	j	724 <main+0x148>
    case 4:
      test_exit();
     65a:	00000097          	auipc	ra,0x0
     65e:	e88080e7          	jalr	-376(ra) # 4e2 <test_exit>
      break;
     662:	a0c9                	j	724 <main+0x148>
    case 5:
      test_exit_all();
     664:	00000097          	auipc	ra,0x0
     668:	ede080e7          	jalr	-290(ra) # 542 <test_exit_all>
      break;
     66c:	a865                	j	724 <main+0x148>
    case 6:
      test_global_pointer_alloc();
     66e:	00000097          	auipc	ra,0x0
     672:	cde080e7          	jalr	-802(ra) # 34c <test_global_pointer_alloc>
      break;
     676:	a07d                	j	724 <main+0x148>
    case 7:
      test_global_pointer_dealloc();
     678:	00000097          	auipc	ra,0x0
     67c:	c70080e7          	jalr	-912(ra) # 2e8 <test_global_pointer_dealloc>
      break;
     680:	a055                	j	724 <main+0x148>
    default:
      printf("Invalid test number. Choose 1-5.\n");
     682:	00001517          	auipc	a0,0x1
     686:	f1e50513          	addi	a0,a0,-226 # 15a0 <ithread_join+0x438>
     68a:	00000097          	auipc	ra,0x0
     68e:	722080e7          	jalr	1826(ra) # dac <printf>
     692:	a849                	j	724 <main+0x148>
  }
  }else{
   test_thread_create();
     694:	00000097          	auipc	ra,0x0
     698:	bdc080e7          	jalr	-1060(ra) # 270 <test_thread_create>
   printf("\n");
     69c:	00001517          	auipc	a0,0x1
     6a0:	f2c50513          	addi	a0,a0,-212 # 15c8 <ithread_join+0x460>
     6a4:	00000097          	auipc	ra,0x0
     6a8:	708080e7          	jalr	1800(ra) # dac <printf>
   test_thread_join();
     6ac:	00000097          	auipc	ra,0x0
     6b0:	d04080e7          	jalr	-764(ra) # 3b0 <test_thread_join>
   printf("\n");
     6b4:	00001517          	auipc	a0,0x1
     6b8:	f1450513          	addi	a0,a0,-236 # 15c8 <ithread_join+0x460>
     6bc:	00000097          	auipc	ra,0x0
     6c0:	6f0080e7          	jalr	1776(ra) # dac <printf>
   test_shared_memory();
     6c4:	00000097          	auipc	ra,0x0
     6c8:	d7a080e7          	jalr	-646(ra) # 43e <test_shared_memory>
   printf("\n");
     6cc:	00001517          	auipc	a0,0x1
     6d0:	efc50513          	addi	a0,a0,-260 # 15c8 <ithread_join+0x460>
     6d4:	00000097          	auipc	ra,0x0
     6d8:	6d8080e7          	jalr	1752(ra) # dac <printf>
   test_exit();
     6dc:	00000097          	auipc	ra,0x0
     6e0:	e06080e7          	jalr	-506(ra) # 4e2 <test_exit>
   printf("\n");
     6e4:	00001517          	auipc	a0,0x1
     6e8:	ee450513          	addi	a0,a0,-284 # 15c8 <ithread_join+0x460>
     6ec:	00000097          	auipc	ra,0x0
     6f0:	6c0080e7          	jalr	1728(ra) # dac <printf>
   // test_exit_all();
   printf("\n");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	ed450513          	addi	a0,a0,-300 # 15c8 <ithread_join+0x460>
     6fc:	00000097          	auipc	ra,0x0
     700:	6b0080e7          	jalr	1712(ra) # dac <printf>
   test_global_pointer_alloc();
     704:	00000097          	auipc	ra,0x0
     708:	c48080e7          	jalr	-952(ra) # 34c <test_global_pointer_alloc>
   printf("\n");
     70c:	00001517          	auipc	a0,0x1
     710:	ebc50513          	addi	a0,a0,-324 # 15c8 <ithread_join+0x460>
     714:	00000097          	auipc	ra,0x0
     718:	698080e7          	jalr	1688(ra) # dac <printf>
   test_global_pointer_dealloc();
     71c:	00000097          	auipc	ra,0x0
     720:	bcc080e7          	jalr	-1076(ra) # 2e8 <test_global_pointer_dealloc>
  }

  exit(0);
     724:	4501                	li	a0,0
     726:	00000097          	auipc	ra,0x0
     72a:	2c2080e7          	jalr	706(ra) # 9e8 <exit>

000000000000072e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     72e:	1141                	addi	sp,sp,-16
     730:	e406                	sd	ra,8(sp)
     732:	e022                	sd	s0,0(sp)
     734:	0800                	addi	s0,sp,16
  extern int main();
  main();
     736:	00000097          	auipc	ra,0x0
     73a:	ea6080e7          	jalr	-346(ra) # 5dc <main>
  exit(0);
     73e:	4501                	li	a0,0
     740:	00000097          	auipc	ra,0x0
     744:	2a8080e7          	jalr	680(ra) # 9e8 <exit>

0000000000000748 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     748:	1141                	addi	sp,sp,-16
     74a:	e406                	sd	ra,8(sp)
     74c:	e022                	sd	s0,0(sp)
     74e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     750:	87aa                	mv	a5,a0
     752:	0585                	addi	a1,a1,1
     754:	0785                	addi	a5,a5,1
     756:	fff5c703          	lbu	a4,-1(a1)
     75a:	fee78fa3          	sb	a4,-1(a5)
     75e:	fb75                	bnez	a4,752 <strcpy+0xa>
    ;
  return os;
}
     760:	60a2                	ld	ra,8(sp)
     762:	6402                	ld	s0,0(sp)
     764:	0141                	addi	sp,sp,16
     766:	8082                	ret

0000000000000768 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     768:	1141                	addi	sp,sp,-16
     76a:	e406                	sd	ra,8(sp)
     76c:	e022                	sd	s0,0(sp)
     76e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     770:	00054783          	lbu	a5,0(a0)
     774:	cb91                	beqz	a5,788 <strcmp+0x20>
     776:	0005c703          	lbu	a4,0(a1)
     77a:	00f71763          	bne	a4,a5,788 <strcmp+0x20>
    p++, q++;
     77e:	0505                	addi	a0,a0,1
     780:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     782:	00054783          	lbu	a5,0(a0)
     786:	fbe5                	bnez	a5,776 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     788:	0005c503          	lbu	a0,0(a1)
}
     78c:	40a7853b          	subw	a0,a5,a0
     790:	60a2                	ld	ra,8(sp)
     792:	6402                	ld	s0,0(sp)
     794:	0141                	addi	sp,sp,16
     796:	8082                	ret

0000000000000798 <strlen>:

uint
strlen(const char *s)
{
     798:	1141                	addi	sp,sp,-16
     79a:	e406                	sd	ra,8(sp)
     79c:	e022                	sd	s0,0(sp)
     79e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     7a0:	00054783          	lbu	a5,0(a0)
     7a4:	cf99                	beqz	a5,7c2 <strlen+0x2a>
     7a6:	0505                	addi	a0,a0,1
     7a8:	87aa                	mv	a5,a0
     7aa:	86be                	mv	a3,a5
     7ac:	0785                	addi	a5,a5,1
     7ae:	fff7c703          	lbu	a4,-1(a5)
     7b2:	ff65                	bnez	a4,7aa <strlen+0x12>
     7b4:	40a6853b          	subw	a0,a3,a0
     7b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     7ba:	60a2                	ld	ra,8(sp)
     7bc:	6402                	ld	s0,0(sp)
     7be:	0141                	addi	sp,sp,16
     7c0:	8082                	ret
  for(n = 0; s[n]; n++)
     7c2:	4501                	li	a0,0
     7c4:	bfdd                	j	7ba <strlen+0x22>

00000000000007c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     7c6:	1141                	addi	sp,sp,-16
     7c8:	e406                	sd	ra,8(sp)
     7ca:	e022                	sd	s0,0(sp)
     7cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     7ce:	ca19                	beqz	a2,7e4 <memset+0x1e>
     7d0:	87aa                	mv	a5,a0
     7d2:	1602                	slli	a2,a2,0x20
     7d4:	9201                	srli	a2,a2,0x20
     7d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     7da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     7de:	0785                	addi	a5,a5,1
     7e0:	fee79de3          	bne	a5,a4,7da <memset+0x14>
  }
  return dst;
}
     7e4:	60a2                	ld	ra,8(sp)
     7e6:	6402                	ld	s0,0(sp)
     7e8:	0141                	addi	sp,sp,16
     7ea:	8082                	ret

00000000000007ec <strchr>:

char*
strchr(const char *s, char c)
{
     7ec:	1141                	addi	sp,sp,-16
     7ee:	e406                	sd	ra,8(sp)
     7f0:	e022                	sd	s0,0(sp)
     7f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     7f4:	00054783          	lbu	a5,0(a0)
     7f8:	cf81                	beqz	a5,810 <strchr+0x24>
    if(*s == c)
     7fa:	00f58763          	beq	a1,a5,808 <strchr+0x1c>
  for(; *s; s++)
     7fe:	0505                	addi	a0,a0,1
     800:	00054783          	lbu	a5,0(a0)
     804:	fbfd                	bnez	a5,7fa <strchr+0xe>
      return (char*)s;
  return 0;
     806:	4501                	li	a0,0
}
     808:	60a2                	ld	ra,8(sp)
     80a:	6402                	ld	s0,0(sp)
     80c:	0141                	addi	sp,sp,16
     80e:	8082                	ret
  return 0;
     810:	4501                	li	a0,0
     812:	bfdd                	j	808 <strchr+0x1c>

0000000000000814 <gets>:

char*
gets(char *buf, int max)
{
     814:	7159                	addi	sp,sp,-112
     816:	f486                	sd	ra,104(sp)
     818:	f0a2                	sd	s0,96(sp)
     81a:	eca6                	sd	s1,88(sp)
     81c:	e8ca                	sd	s2,80(sp)
     81e:	e4ce                	sd	s3,72(sp)
     820:	e0d2                	sd	s4,64(sp)
     822:	fc56                	sd	s5,56(sp)
     824:	f85a                	sd	s6,48(sp)
     826:	f45e                	sd	s7,40(sp)
     828:	f062                	sd	s8,32(sp)
     82a:	ec66                	sd	s9,24(sp)
     82c:	e86a                	sd	s10,16(sp)
     82e:	1880                	addi	s0,sp,112
     830:	8caa                	mv	s9,a0
     832:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     834:	892a                	mv	s2,a0
     836:	4481                	li	s1,0
    cc = read(0, &c, 1);
     838:	f9f40b13          	addi	s6,s0,-97
     83c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     83e:	4ba9                	li	s7,10
     840:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     842:	8d26                	mv	s10,s1
     844:	0014899b          	addiw	s3,s1,1
     848:	84ce                	mv	s1,s3
     84a:	0349d763          	bge	s3,s4,878 <gets+0x64>
    cc = read(0, &c, 1);
     84e:	8656                	mv	a2,s5
     850:	85da                	mv	a1,s6
     852:	4501                	li	a0,0
     854:	00000097          	auipc	ra,0x0
     858:	1ac080e7          	jalr	428(ra) # a00 <read>
    if(cc < 1)
     85c:	00a05e63          	blez	a0,878 <gets+0x64>
    buf[i++] = c;
     860:	f9f44783          	lbu	a5,-97(s0)
     864:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     868:	01778763          	beq	a5,s7,876 <gets+0x62>
     86c:	0905                	addi	s2,s2,1
     86e:	fd879ae3          	bne	a5,s8,842 <gets+0x2e>
    buf[i++] = c;
     872:	8d4e                	mv	s10,s3
     874:	a011                	j	878 <gets+0x64>
     876:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     878:	9d66                	add	s10,s10,s9
     87a:	000d0023          	sb	zero,0(s10)
  return buf;
}
     87e:	8566                	mv	a0,s9
     880:	70a6                	ld	ra,104(sp)
     882:	7406                	ld	s0,96(sp)
     884:	64e6                	ld	s1,88(sp)
     886:	6946                	ld	s2,80(sp)
     888:	69a6                	ld	s3,72(sp)
     88a:	6a06                	ld	s4,64(sp)
     88c:	7ae2                	ld	s5,56(sp)
     88e:	7b42                	ld	s6,48(sp)
     890:	7ba2                	ld	s7,40(sp)
     892:	7c02                	ld	s8,32(sp)
     894:	6ce2                	ld	s9,24(sp)
     896:	6d42                	ld	s10,16(sp)
     898:	6165                	addi	sp,sp,112
     89a:	8082                	ret

000000000000089c <stat>:

int
stat(const char *n, struct stat *st)
{
     89c:	1101                	addi	sp,sp,-32
     89e:	ec06                	sd	ra,24(sp)
     8a0:	e822                	sd	s0,16(sp)
     8a2:	e04a                	sd	s2,0(sp)
     8a4:	1000                	addi	s0,sp,32
     8a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     8a8:	4581                	li	a1,0
     8aa:	00000097          	auipc	ra,0x0
     8ae:	17e080e7          	jalr	382(ra) # a28 <open>
  if(fd < 0)
     8b2:	02054663          	bltz	a0,8de <stat+0x42>
     8b6:	e426                	sd	s1,8(sp)
     8b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     8ba:	85ca                	mv	a1,s2
     8bc:	00000097          	auipc	ra,0x0
     8c0:	184080e7          	jalr	388(ra) # a40 <fstat>
     8c4:	892a                	mv	s2,a0
  close(fd);
     8c6:	8526                	mv	a0,s1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	148080e7          	jalr	328(ra) # a10 <close>
  return r;
     8d0:	64a2                	ld	s1,8(sp)
}
     8d2:	854a                	mv	a0,s2
     8d4:	60e2                	ld	ra,24(sp)
     8d6:	6442                	ld	s0,16(sp)
     8d8:	6902                	ld	s2,0(sp)
     8da:	6105                	addi	sp,sp,32
     8dc:	8082                	ret
    return -1;
     8de:	597d                	li	s2,-1
     8e0:	bfcd                	j	8d2 <stat+0x36>

00000000000008e2 <atoi>:

int
atoi(const char *s)
{
     8e2:	1141                	addi	sp,sp,-16
     8e4:	e406                	sd	ra,8(sp)
     8e6:	e022                	sd	s0,0(sp)
     8e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     8ea:	00054683          	lbu	a3,0(a0)
     8ee:	fd06879b          	addiw	a5,a3,-48
     8f2:	0ff7f793          	zext.b	a5,a5
     8f6:	4625                	li	a2,9
     8f8:	02f66963          	bltu	a2,a5,92a <atoi+0x48>
     8fc:	872a                	mv	a4,a0
  n = 0;
     8fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     900:	0705                	addi	a4,a4,1
     902:	0025179b          	slliw	a5,a0,0x2
     906:	9fa9                	addw	a5,a5,a0
     908:	0017979b          	slliw	a5,a5,0x1
     90c:	9fb5                	addw	a5,a5,a3
     90e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     912:	00074683          	lbu	a3,0(a4)
     916:	fd06879b          	addiw	a5,a3,-48
     91a:	0ff7f793          	zext.b	a5,a5
     91e:	fef671e3          	bgeu	a2,a5,900 <atoi+0x1e>
  return n;
}
     922:	60a2                	ld	ra,8(sp)
     924:	6402                	ld	s0,0(sp)
     926:	0141                	addi	sp,sp,16
     928:	8082                	ret
  n = 0;
     92a:	4501                	li	a0,0
     92c:	bfdd                	j	922 <atoi+0x40>

000000000000092e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     92e:	1141                	addi	sp,sp,-16
     930:	e406                	sd	ra,8(sp)
     932:	e022                	sd	s0,0(sp)
     934:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     936:	02b57563          	bgeu	a0,a1,960 <memmove+0x32>
    while(n-- > 0)
     93a:	00c05f63          	blez	a2,958 <memmove+0x2a>
     93e:	1602                	slli	a2,a2,0x20
     940:	9201                	srli	a2,a2,0x20
     942:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     946:	872a                	mv	a4,a0
      *dst++ = *src++;
     948:	0585                	addi	a1,a1,1
     94a:	0705                	addi	a4,a4,1
     94c:	fff5c683          	lbu	a3,-1(a1)
     950:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     954:	fee79ae3          	bne	a5,a4,948 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     958:	60a2                	ld	ra,8(sp)
     95a:	6402                	ld	s0,0(sp)
     95c:	0141                	addi	sp,sp,16
     95e:	8082                	ret
    dst += n;
     960:	00c50733          	add	a4,a0,a2
    src += n;
     964:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     966:	fec059e3          	blez	a2,958 <memmove+0x2a>
     96a:	fff6079b          	addiw	a5,a2,-1
     96e:	1782                	slli	a5,a5,0x20
     970:	9381                	srli	a5,a5,0x20
     972:	fff7c793          	not	a5,a5
     976:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     978:	15fd                	addi	a1,a1,-1
     97a:	177d                	addi	a4,a4,-1
     97c:	0005c683          	lbu	a3,0(a1)
     980:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     984:	fef71ae3          	bne	a4,a5,978 <memmove+0x4a>
     988:	bfc1                	j	958 <memmove+0x2a>

000000000000098a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     98a:	1141                	addi	sp,sp,-16
     98c:	e406                	sd	ra,8(sp)
     98e:	e022                	sd	s0,0(sp)
     990:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     992:	ca0d                	beqz	a2,9c4 <memcmp+0x3a>
     994:	fff6069b          	addiw	a3,a2,-1
     998:	1682                	slli	a3,a3,0x20
     99a:	9281                	srli	a3,a3,0x20
     99c:	0685                	addi	a3,a3,1
     99e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     9a0:	00054783          	lbu	a5,0(a0)
     9a4:	0005c703          	lbu	a4,0(a1)
     9a8:	00e79863          	bne	a5,a4,9b8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     9ac:	0505                	addi	a0,a0,1
    p2++;
     9ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     9b0:	fed518e3          	bne	a0,a3,9a0 <memcmp+0x16>
  }
  return 0;
     9b4:	4501                	li	a0,0
     9b6:	a019                	j	9bc <memcmp+0x32>
      return *p1 - *p2;
     9b8:	40e7853b          	subw	a0,a5,a4
}
     9bc:	60a2                	ld	ra,8(sp)
     9be:	6402                	ld	s0,0(sp)
     9c0:	0141                	addi	sp,sp,16
     9c2:	8082                	ret
  return 0;
     9c4:	4501                	li	a0,0
     9c6:	bfdd                	j	9bc <memcmp+0x32>

00000000000009c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     9c8:	1141                	addi	sp,sp,-16
     9ca:	e406                	sd	ra,8(sp)
     9cc:	e022                	sd	s0,0(sp)
     9ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f5e080e7          	jalr	-162(ra) # 92e <memmove>
}
     9d8:	60a2                	ld	ra,8(sp)
     9da:	6402                	ld	s0,0(sp)
     9dc:	0141                	addi	sp,sp,16
     9de:	8082                	ret

00000000000009e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     9e0:	4885                	li	a7,1
 ecall
     9e2:	00000073          	ecall
 ret
     9e6:	8082                	ret

00000000000009e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     9e8:	4889                	li	a7,2
 ecall
     9ea:	00000073          	ecall
 ret
     9ee:	8082                	ret

00000000000009f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     9f0:	488d                	li	a7,3
 ecall
     9f2:	00000073          	ecall
 ret
     9f6:	8082                	ret

00000000000009f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     9f8:	4891                	li	a7,4
 ecall
     9fa:	00000073          	ecall
 ret
     9fe:	8082                	ret

0000000000000a00 <read>:
.global read
read:
 li a7, SYS_read
     a00:	4895                	li	a7,5
 ecall
     a02:	00000073          	ecall
 ret
     a06:	8082                	ret

0000000000000a08 <write>:
.global write
write:
 li a7, SYS_write
     a08:	48c1                	li	a7,16
 ecall
     a0a:	00000073          	ecall
 ret
     a0e:	8082                	ret

0000000000000a10 <close>:
.global close
close:
 li a7, SYS_close
     a10:	48d5                	li	a7,21
 ecall
     a12:	00000073          	ecall
 ret
     a16:	8082                	ret

0000000000000a18 <kill>:
.global kill
kill:
 li a7, SYS_kill
     a18:	4899                	li	a7,6
 ecall
     a1a:	00000073          	ecall
 ret
     a1e:	8082                	ret

0000000000000a20 <exec>:
.global exec
exec:
 li a7, SYS_exec
     a20:	489d                	li	a7,7
 ecall
     a22:	00000073          	ecall
 ret
     a26:	8082                	ret

0000000000000a28 <open>:
.global open
open:
 li a7, SYS_open
     a28:	48bd                	li	a7,15
 ecall
     a2a:	00000073          	ecall
 ret
     a2e:	8082                	ret

0000000000000a30 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     a30:	48c5                	li	a7,17
 ecall
     a32:	00000073          	ecall
 ret
     a36:	8082                	ret

0000000000000a38 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     a38:	48c9                	li	a7,18
 ecall
     a3a:	00000073          	ecall
 ret
     a3e:	8082                	ret

0000000000000a40 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     a40:	48a1                	li	a7,8
 ecall
     a42:	00000073          	ecall
 ret
     a46:	8082                	ret

0000000000000a48 <link>:
.global link
link:
 li a7, SYS_link
     a48:	48cd                	li	a7,19
 ecall
     a4a:	00000073          	ecall
 ret
     a4e:	8082                	ret

0000000000000a50 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     a50:	48d1                	li	a7,20
 ecall
     a52:	00000073          	ecall
 ret
     a56:	8082                	ret

0000000000000a58 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     a58:	48a5                	li	a7,9
 ecall
     a5a:	00000073          	ecall
 ret
     a5e:	8082                	ret

0000000000000a60 <dup>:
.global dup
dup:
 li a7, SYS_dup
     a60:	48a9                	li	a7,10
 ecall
     a62:	00000073          	ecall
 ret
     a66:	8082                	ret

0000000000000a68 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     a68:	48ad                	li	a7,11
 ecall
     a6a:	00000073          	ecall
 ret
     a6e:	8082                	ret

0000000000000a70 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     a70:	48b1                	li	a7,12
 ecall
     a72:	00000073          	ecall
 ret
     a76:	8082                	ret

0000000000000a78 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     a78:	48b5                	li	a7,13
 ecall
     a7a:	00000073          	ecall
 ret
     a7e:	8082                	ret

0000000000000a80 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     a80:	48b9                	li	a7,14
 ecall
     a82:	00000073          	ecall
 ret
     a86:	8082                	ret

0000000000000a88 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     a88:	48d9                	li	a7,22
 ecall
     a8a:	00000073          	ecall
 ret
     a8e:	8082                	ret

0000000000000a90 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     a90:	48dd                	li	a7,23
 ecall
     a92:	00000073          	ecall
 ret
     a96:	8082                	ret

0000000000000a98 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     a98:	48e1                	li	a7,24
 ecall
     a9a:	00000073          	ecall
 ret
     a9e:	8082                	ret

0000000000000aa0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     aa0:	48e5                	li	a7,25
 ecall
     aa2:	00000073          	ecall
 ret
     aa6:	8082                	ret

0000000000000aa8 <socket>:
.global socket
socket:
 li a7, SYS_socket
     aa8:	48e9                	li	a7,26
 ecall
     aaa:	00000073          	ecall
 ret
     aae:	8082                	ret

0000000000000ab0 <bind>:
.global bind
bind:
 li a7, SYS_bind
     ab0:	48ed                	li	a7,27
 ecall
     ab2:	00000073          	ecall
 ret
     ab6:	8082                	ret

0000000000000ab8 <accept>:
.global accept
accept:
 li a7, SYS_accept
     ab8:	48f5                	li	a7,29
 ecall
     aba:	00000073          	ecall
 ret
     abe:	8082                	ret

0000000000000ac0 <listen>:
.global listen
listen:
 li a7, SYS_listen
     ac0:	48f1                	li	a7,28
 ecall
     ac2:	00000073          	ecall
 ret
     ac6:	8082                	ret

0000000000000ac8 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ac8:	48f9                	li	a7,30
 ecall
     aca:	00000073          	ecall
 ret
     ace:	8082                	ret

0000000000000ad0 <send>:
.global send
send:
 li a7, SYS_send
     ad0:	48fd                	li	a7,31
 ecall
     ad2:	00000073          	ecall
 ret
     ad6:	8082                	ret

0000000000000ad8 <recv>:
.global recv
recv:
 li a7, SYS_recv
     ad8:	02000893          	li	a7,32
 ecall
     adc:	00000073          	ecall
 ret
     ae0:	8082                	ret

0000000000000ae2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     ae2:	02100893          	li	a7,33
 ecall
     ae6:	00000073          	ecall
 ret
     aea:	8082                	ret

0000000000000aec <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
     aec:	02200893          	li	a7,34
 ecall
     af0:	00000073          	ecall
 ret
     af4:	8082                	ret

0000000000000af6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     af6:	1101                	addi	sp,sp,-32
     af8:	ec06                	sd	ra,24(sp)
     afa:	e822                	sd	s0,16(sp)
     afc:	1000                	addi	s0,sp,32
     afe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     b02:	4605                	li	a2,1
     b04:	fef40593          	addi	a1,s0,-17
     b08:	00000097          	auipc	ra,0x0
     b0c:	f00080e7          	jalr	-256(ra) # a08 <write>
}
     b10:	60e2                	ld	ra,24(sp)
     b12:	6442                	ld	s0,16(sp)
     b14:	6105                	addi	sp,sp,32
     b16:	8082                	ret

0000000000000b18 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     b18:	7139                	addi	sp,sp,-64
     b1a:	fc06                	sd	ra,56(sp)
     b1c:	f822                	sd	s0,48(sp)
     b1e:	f426                	sd	s1,40(sp)
     b20:	f04a                	sd	s2,32(sp)
     b22:	ec4e                	sd	s3,24(sp)
     b24:	0080                	addi	s0,sp,64
     b26:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     b28:	c299                	beqz	a3,b2e <printint+0x16>
     b2a:	0805c063          	bltz	a1,baa <printint+0x92>
  neg = 0;
     b2e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     b30:	fc040313          	addi	t1,s0,-64
  neg = 0;
     b34:	869a                	mv	a3,t1
  i = 0;
     b36:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     b38:	00001817          	auipc	a6,0x1
     b3c:	b4080813          	addi	a6,a6,-1216 # 1678 <digits>
     b40:	88be                	mv	a7,a5
     b42:	0017851b          	addiw	a0,a5,1
     b46:	87aa                	mv	a5,a0
     b48:	02c5f73b          	remuw	a4,a1,a2
     b4c:	1702                	slli	a4,a4,0x20
     b4e:	9301                	srli	a4,a4,0x20
     b50:	9742                	add	a4,a4,a6
     b52:	00074703          	lbu	a4,0(a4)
     b56:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     b5a:	872e                	mv	a4,a1
     b5c:	02c5d5bb          	divuw	a1,a1,a2
     b60:	0685                	addi	a3,a3,1
     b62:	fcc77fe3          	bgeu	a4,a2,b40 <printint+0x28>
  if(neg)
     b66:	000e0c63          	beqz	t3,b7e <printint+0x66>
    buf[i++] = '-';
     b6a:	fd050793          	addi	a5,a0,-48
     b6e:	00878533          	add	a0,a5,s0
     b72:	02d00793          	li	a5,45
     b76:	fef50823          	sb	a5,-16(a0)
     b7a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     b7e:	fff7899b          	addiw	s3,a5,-1
     b82:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     b86:	fff4c583          	lbu	a1,-1(s1)
     b8a:	854a                	mv	a0,s2
     b8c:	00000097          	auipc	ra,0x0
     b90:	f6a080e7          	jalr	-150(ra) # af6 <putc>
  while(--i >= 0)
     b94:	39fd                	addiw	s3,s3,-1
     b96:	14fd                	addi	s1,s1,-1
     b98:	fe09d7e3          	bgez	s3,b86 <printint+0x6e>
}
     b9c:	70e2                	ld	ra,56(sp)
     b9e:	7442                	ld	s0,48(sp)
     ba0:	74a2                	ld	s1,40(sp)
     ba2:	7902                	ld	s2,32(sp)
     ba4:	69e2                	ld	s3,24(sp)
     ba6:	6121                	addi	sp,sp,64
     ba8:	8082                	ret
    x = -xx;
     baa:	40b005bb          	negw	a1,a1
    neg = 1;
     bae:	4e05                	li	t3,1
    x = -xx;
     bb0:	b741                	j	b30 <printint+0x18>

0000000000000bb2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     bb2:	715d                	addi	sp,sp,-80
     bb4:	e486                	sd	ra,72(sp)
     bb6:	e0a2                	sd	s0,64(sp)
     bb8:	f84a                	sd	s2,48(sp)
     bba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     bbc:	0005c903          	lbu	s2,0(a1)
     bc0:	1a090a63          	beqz	s2,d74 <vprintf+0x1c2>
     bc4:	fc26                	sd	s1,56(sp)
     bc6:	f44e                	sd	s3,40(sp)
     bc8:	f052                	sd	s4,32(sp)
     bca:	ec56                	sd	s5,24(sp)
     bcc:	e85a                	sd	s6,16(sp)
     bce:	e45e                	sd	s7,8(sp)
     bd0:	8aaa                	mv	s5,a0
     bd2:	8bb2                	mv	s7,a2
     bd4:	00158493          	addi	s1,a1,1
  state = 0;
     bd8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     bda:	02500a13          	li	s4,37
     bde:	4b55                	li	s6,21
     be0:	a839                	j	bfe <vprintf+0x4c>
        putc(fd, c);
     be2:	85ca                	mv	a1,s2
     be4:	8556                	mv	a0,s5
     be6:	00000097          	auipc	ra,0x0
     bea:	f10080e7          	jalr	-240(ra) # af6 <putc>
     bee:	a019                	j	bf4 <vprintf+0x42>
    } else if(state == '%'){
     bf0:	01498d63          	beq	s3,s4,c0a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     bf4:	0485                	addi	s1,s1,1
     bf6:	fff4c903          	lbu	s2,-1(s1)
     bfa:	16090763          	beqz	s2,d68 <vprintf+0x1b6>
    if(state == 0){
     bfe:	fe0999e3          	bnez	s3,bf0 <vprintf+0x3e>
      if(c == '%'){
     c02:	ff4910e3          	bne	s2,s4,be2 <vprintf+0x30>
        state = '%';
     c06:	89d2                	mv	s3,s4
     c08:	b7f5                	j	bf4 <vprintf+0x42>
      if(c == 'd'){
     c0a:	13490463          	beq	s2,s4,d32 <vprintf+0x180>
     c0e:	f9d9079b          	addiw	a5,s2,-99
     c12:	0ff7f793          	zext.b	a5,a5
     c16:	12fb6763          	bltu	s6,a5,d44 <vprintf+0x192>
     c1a:	f9d9079b          	addiw	a5,s2,-99
     c1e:	0ff7f713          	zext.b	a4,a5
     c22:	12eb6163          	bltu	s6,a4,d44 <vprintf+0x192>
     c26:	00271793          	slli	a5,a4,0x2
     c2a:	00001717          	auipc	a4,0x1
     c2e:	9f670713          	addi	a4,a4,-1546 # 1620 <ithread_join+0x4b8>
     c32:	97ba                	add	a5,a5,a4
     c34:	439c                	lw	a5,0(a5)
     c36:	97ba                	add	a5,a5,a4
     c38:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     c3a:	008b8913          	addi	s2,s7,8
     c3e:	4685                	li	a3,1
     c40:	4629                	li	a2,10
     c42:	000ba583          	lw	a1,0(s7)
     c46:	8556                	mv	a0,s5
     c48:	00000097          	auipc	ra,0x0
     c4c:	ed0080e7          	jalr	-304(ra) # b18 <printint>
     c50:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     c52:	4981                	li	s3,0
     c54:	b745                	j	bf4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c56:	008b8913          	addi	s2,s7,8
     c5a:	4681                	li	a3,0
     c5c:	4629                	li	a2,10
     c5e:	000ba583          	lw	a1,0(s7)
     c62:	8556                	mv	a0,s5
     c64:	00000097          	auipc	ra,0x0
     c68:	eb4080e7          	jalr	-332(ra) # b18 <printint>
     c6c:	8bca                	mv	s7,s2
      state = 0;
     c6e:	4981                	li	s3,0
     c70:	b751                	j	bf4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     c72:	008b8913          	addi	s2,s7,8
     c76:	4681                	li	a3,0
     c78:	4641                	li	a2,16
     c7a:	000ba583          	lw	a1,0(s7)
     c7e:	8556                	mv	a0,s5
     c80:	00000097          	auipc	ra,0x0
     c84:	e98080e7          	jalr	-360(ra) # b18 <printint>
     c88:	8bca                	mv	s7,s2
      state = 0;
     c8a:	4981                	li	s3,0
     c8c:	b7a5                	j	bf4 <vprintf+0x42>
     c8e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     c90:	008b8c13          	addi	s8,s7,8
     c94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     c98:	03000593          	li	a1,48
     c9c:	8556                	mv	a0,s5
     c9e:	00000097          	auipc	ra,0x0
     ca2:	e58080e7          	jalr	-424(ra) # af6 <putc>
  putc(fd, 'x');
     ca6:	07800593          	li	a1,120
     caa:	8556                	mv	a0,s5
     cac:	00000097          	auipc	ra,0x0
     cb0:	e4a080e7          	jalr	-438(ra) # af6 <putc>
     cb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     cb6:	00001b97          	auipc	s7,0x1
     cba:	9c2b8b93          	addi	s7,s7,-1598 # 1678 <digits>
     cbe:	03c9d793          	srli	a5,s3,0x3c
     cc2:	97de                	add	a5,a5,s7
     cc4:	0007c583          	lbu	a1,0(a5)
     cc8:	8556                	mv	a0,s5
     cca:	00000097          	auipc	ra,0x0
     cce:	e2c080e7          	jalr	-468(ra) # af6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     cd2:	0992                	slli	s3,s3,0x4
     cd4:	397d                	addiw	s2,s2,-1
     cd6:	fe0914e3          	bnez	s2,cbe <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     cda:	8be2                	mv	s7,s8
      state = 0;
     cdc:	4981                	li	s3,0
     cde:	6c02                	ld	s8,0(sp)
     ce0:	bf11                	j	bf4 <vprintf+0x42>
        s = va_arg(ap, char*);
     ce2:	008b8993          	addi	s3,s7,8
     ce6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     cea:	02090163          	beqz	s2,d0c <vprintf+0x15a>
        while(*s != 0){
     cee:	00094583          	lbu	a1,0(s2)
     cf2:	c9a5                	beqz	a1,d62 <vprintf+0x1b0>
          putc(fd, *s);
     cf4:	8556                	mv	a0,s5
     cf6:	00000097          	auipc	ra,0x0
     cfa:	e00080e7          	jalr	-512(ra) # af6 <putc>
          s++;
     cfe:	0905                	addi	s2,s2,1
        while(*s != 0){
     d00:	00094583          	lbu	a1,0(s2)
     d04:	f9e5                	bnez	a1,cf4 <vprintf+0x142>
        s = va_arg(ap, char*);
     d06:	8bce                	mv	s7,s3
      state = 0;
     d08:	4981                	li	s3,0
     d0a:	b5ed                	j	bf4 <vprintf+0x42>
          s = "(null)";
     d0c:	00001917          	auipc	s2,0x1
     d10:	8c490913          	addi	s2,s2,-1852 # 15d0 <ithread_join+0x468>
        while(*s != 0){
     d14:	02800593          	li	a1,40
     d18:	bff1                	j	cf4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     d1a:	008b8913          	addi	s2,s7,8
     d1e:	000bc583          	lbu	a1,0(s7)
     d22:	8556                	mv	a0,s5
     d24:	00000097          	auipc	ra,0x0
     d28:	dd2080e7          	jalr	-558(ra) # af6 <putc>
     d2c:	8bca                	mv	s7,s2
      state = 0;
     d2e:	4981                	li	s3,0
     d30:	b5d1                	j	bf4 <vprintf+0x42>
        putc(fd, c);
     d32:	02500593          	li	a1,37
     d36:	8556                	mv	a0,s5
     d38:	00000097          	auipc	ra,0x0
     d3c:	dbe080e7          	jalr	-578(ra) # af6 <putc>
      state = 0;
     d40:	4981                	li	s3,0
     d42:	bd4d                	j	bf4 <vprintf+0x42>
        putc(fd, '%');
     d44:	02500593          	li	a1,37
     d48:	8556                	mv	a0,s5
     d4a:	00000097          	auipc	ra,0x0
     d4e:	dac080e7          	jalr	-596(ra) # af6 <putc>
        putc(fd, c);
     d52:	85ca                	mv	a1,s2
     d54:	8556                	mv	a0,s5
     d56:	00000097          	auipc	ra,0x0
     d5a:	da0080e7          	jalr	-608(ra) # af6 <putc>
      state = 0;
     d5e:	4981                	li	s3,0
     d60:	bd51                	j	bf4 <vprintf+0x42>
        s = va_arg(ap, char*);
     d62:	8bce                	mv	s7,s3
      state = 0;
     d64:	4981                	li	s3,0
     d66:	b579                	j	bf4 <vprintf+0x42>
     d68:	74e2                	ld	s1,56(sp)
     d6a:	79a2                	ld	s3,40(sp)
     d6c:	7a02                	ld	s4,32(sp)
     d6e:	6ae2                	ld	s5,24(sp)
     d70:	6b42                	ld	s6,16(sp)
     d72:	6ba2                	ld	s7,8(sp)
    }
  }
}
     d74:	60a6                	ld	ra,72(sp)
     d76:	6406                	ld	s0,64(sp)
     d78:	7942                	ld	s2,48(sp)
     d7a:	6161                	addi	sp,sp,80
     d7c:	8082                	ret

0000000000000d7e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d7e:	715d                	addi	sp,sp,-80
     d80:	ec06                	sd	ra,24(sp)
     d82:	e822                	sd	s0,16(sp)
     d84:	1000                	addi	s0,sp,32
     d86:	e010                	sd	a2,0(s0)
     d88:	e414                	sd	a3,8(s0)
     d8a:	e818                	sd	a4,16(s0)
     d8c:	ec1c                	sd	a5,24(s0)
     d8e:	03043023          	sd	a6,32(s0)
     d92:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d96:	8622                	mv	a2,s0
     d98:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d9c:	00000097          	auipc	ra,0x0
     da0:	e16080e7          	jalr	-490(ra) # bb2 <vprintf>
}
     da4:	60e2                	ld	ra,24(sp)
     da6:	6442                	ld	s0,16(sp)
     da8:	6161                	addi	sp,sp,80
     daa:	8082                	ret

0000000000000dac <printf>:

void
printf(const char *fmt, ...)
{
     dac:	711d                	addi	sp,sp,-96
     dae:	ec06                	sd	ra,24(sp)
     db0:	e822                	sd	s0,16(sp)
     db2:	1000                	addi	s0,sp,32
     db4:	e40c                	sd	a1,8(s0)
     db6:	e810                	sd	a2,16(s0)
     db8:	ec14                	sd	a3,24(s0)
     dba:	f018                	sd	a4,32(s0)
     dbc:	f41c                	sd	a5,40(s0)
     dbe:	03043823          	sd	a6,48(s0)
     dc2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     dc6:	00840613          	addi	a2,s0,8
     dca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     dce:	85aa                	mv	a1,a0
     dd0:	4505                	li	a0,1
     dd2:	00000097          	auipc	ra,0x0
     dd6:	de0080e7          	jalr	-544(ra) # bb2 <vprintf>
}
     dda:	60e2                	ld	ra,24(sp)
     ddc:	6442                	ld	s0,16(sp)
     dde:	6125                	addi	sp,sp,96
     de0:	8082                	ret

0000000000000de2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     de2:	1141                	addi	sp,sp,-16
     de4:	e406                	sd	ra,8(sp)
     de6:	e022                	sd	s0,0(sp)
     de8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     dea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dee:	00002797          	auipc	a5,0x2
     df2:	9fa7b783          	ld	a5,-1542(a5) # 27e8 <freep>
     df6:	a02d                	j	e20 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     df8:	4618                	lw	a4,8(a2)
     dfa:	9f2d                	addw	a4,a4,a1
     dfc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e00:	6398                	ld	a4,0(a5)
     e02:	6310                	ld	a2,0(a4)
     e04:	a83d                	j	e42 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     e06:	ff852703          	lw	a4,-8(a0)
     e0a:	9f31                	addw	a4,a4,a2
     e0c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e0e:	ff053683          	ld	a3,-16(a0)
     e12:	a091                	j	e56 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e14:	6398                	ld	a4,0(a5)
     e16:	00e7e463          	bltu	a5,a4,e1e <free+0x3c>
     e1a:	00e6ea63          	bltu	a3,a4,e2e <free+0x4c>
{
     e1e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e20:	fed7fae3          	bgeu	a5,a3,e14 <free+0x32>
     e24:	6398                	ld	a4,0(a5)
     e26:	00e6e463          	bltu	a3,a4,e2e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e2a:	fee7eae3          	bltu	a5,a4,e1e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
     e2e:	ff852583          	lw	a1,-8(a0)
     e32:	6390                	ld	a2,0(a5)
     e34:	02059813          	slli	a6,a1,0x20
     e38:	01c85713          	srli	a4,a6,0x1c
     e3c:	9736                	add	a4,a4,a3
     e3e:	fae60de3          	beq	a2,a4,df8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
     e42:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     e46:	4790                	lw	a2,8(a5)
     e48:	02061593          	slli	a1,a2,0x20
     e4c:	01c5d713          	srli	a4,a1,0x1c
     e50:	973e                	add	a4,a4,a5
     e52:	fae68ae3          	beq	a3,a4,e06 <free+0x24>
    p->s.ptr = bp->s.ptr;
     e56:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     e58:	00002717          	auipc	a4,0x2
     e5c:	98f73823          	sd	a5,-1648(a4) # 27e8 <freep>
}
     e60:	60a2                	ld	ra,8(sp)
     e62:	6402                	ld	s0,0(sp)
     e64:	0141                	addi	sp,sp,16
     e66:	8082                	ret

0000000000000e68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e68:	7139                	addi	sp,sp,-64
     e6a:	fc06                	sd	ra,56(sp)
     e6c:	f822                	sd	s0,48(sp)
     e6e:	f04a                	sd	s2,32(sp)
     e70:	ec4e                	sd	s3,24(sp)
     e72:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e74:	02051993          	slli	s3,a0,0x20
     e78:	0209d993          	srli	s3,s3,0x20
     e7c:	09bd                	addi	s3,s3,15
     e7e:	0049d993          	srli	s3,s3,0x4
     e82:	2985                	addiw	s3,s3,1
     e84:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     e86:	00002517          	auipc	a0,0x2
     e8a:	96253503          	ld	a0,-1694(a0) # 27e8 <freep>
     e8e:	c905                	beqz	a0,ebe <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e92:	4798                	lw	a4,8(a5)
     e94:	09377a63          	bgeu	a4,s3,f28 <malloc+0xc0>
     e98:	f426                	sd	s1,40(sp)
     e9a:	e852                	sd	s4,16(sp)
     e9c:	e456                	sd	s5,8(sp)
     e9e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     ea0:	8a4e                	mv	s4,s3
     ea2:	6705                	lui	a4,0x1
     ea4:	00e9f363          	bgeu	s3,a4,eaa <malloc+0x42>
     ea8:	6a05                	lui	s4,0x1
     eaa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     eae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     eb2:	00002497          	auipc	s1,0x2
     eb6:	93648493          	addi	s1,s1,-1738 # 27e8 <freep>
  if(p == (char*)-1)
     eba:	5afd                	li	s5,-1
     ebc:	a089                	j	efe <malloc+0x96>
     ebe:	f426                	sd	s1,40(sp)
     ec0:	e852                	sd	s4,16(sp)
     ec2:	e456                	sd	s5,8(sp)
     ec4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     ec6:	00002797          	auipc	a5,0x2
     eca:	93a78793          	addi	a5,a5,-1734 # 2800 <base>
     ece:	00002717          	auipc	a4,0x2
     ed2:	90f73d23          	sd	a5,-1766(a4) # 27e8 <freep>
     ed6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     ed8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     edc:	b7d1                	j	ea0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
     ede:	6398                	ld	a4,0(a5)
     ee0:	e118                	sd	a4,0(a0)
     ee2:	a8b9                	j	f40 <malloc+0xd8>
  hp->s.size = nu;
     ee4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     ee8:	0541                	addi	a0,a0,16
     eea:	00000097          	auipc	ra,0x0
     eee:	ef8080e7          	jalr	-264(ra) # de2 <free>
  return freep;
     ef2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
     ef4:	c135                	beqz	a0,f58 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ef6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     ef8:	4798                	lw	a4,8(a5)
     efa:	03277363          	bgeu	a4,s2,f20 <malloc+0xb8>
    if(p == freep)
     efe:	6098                	ld	a4,0(s1)
     f00:	853e                	mv	a0,a5
     f02:	fef71ae3          	bne	a4,a5,ef6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
     f06:	8552                	mv	a0,s4
     f08:	00000097          	auipc	ra,0x0
     f0c:	b68080e7          	jalr	-1176(ra) # a70 <sbrk>
  if(p == (char*)-1)
     f10:	fd551ae3          	bne	a0,s5,ee4 <malloc+0x7c>
        return 0;
     f14:	4501                	li	a0,0
     f16:	74a2                	ld	s1,40(sp)
     f18:	6a42                	ld	s4,16(sp)
     f1a:	6aa2                	ld	s5,8(sp)
     f1c:	6b02                	ld	s6,0(sp)
     f1e:	a03d                	j	f4c <malloc+0xe4>
     f20:	74a2                	ld	s1,40(sp)
     f22:	6a42                	ld	s4,16(sp)
     f24:	6aa2                	ld	s5,8(sp)
     f26:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     f28:	fae90be3          	beq	s2,a4,ede <malloc+0x76>
        p->s.size -= nunits;
     f2c:	4137073b          	subw	a4,a4,s3
     f30:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f32:	02071693          	slli	a3,a4,0x20
     f36:	01c6d713          	srli	a4,a3,0x1c
     f3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     f3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     f40:	00002717          	auipc	a4,0x2
     f44:	8aa73423          	sd	a0,-1880(a4) # 27e8 <freep>
      return (void*)(p + 1);
     f48:	01078513          	addi	a0,a5,16
  }
}
     f4c:	70e2                	ld	ra,56(sp)
     f4e:	7442                	ld	s0,48(sp)
     f50:	7902                	ld	s2,32(sp)
     f52:	69e2                	ld	s3,24(sp)
     f54:	6121                	addi	sp,sp,64
     f56:	8082                	ret
     f58:	74a2                	ld	s1,40(sp)
     f5a:	6a42                	ld	s4,16(sp)
     f5c:	6aa2                	ld	s5,8(sp)
     f5e:	6b02                	ld	s6,0(sp)
     f60:	b7f5                	j	f4c <malloc+0xe4>

0000000000000f62 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     f62:	1141                	addi	sp,sp,-16
     f64:	e406                	sd	ra,8(sp)
     f66:	e022                	sd	s0,0(sp)
     f68:	0800                	addi	s0,sp,16
  thread_exit(status);
     f6a:	2501                	sext.w	a0,a0
     f6c:	00000097          	auipc	ra,0x0
     f70:	b34080e7          	jalr	-1228(ra) # aa0 <thread_exit>
}
     f74:	60a2                	ld	ra,8(sp)
     f76:	6402                	ld	s0,0(sp)
     f78:	0141                	addi	sp,sp,16
     f7a:	8082                	ret

0000000000000f7c <free_stacks>:
int free_stacks() {
     f7c:	7179                	addi	sp,sp,-48
     f7e:	f406                	sd	ra,40(sp)
     f80:	f022                	sd	s0,32(sp)
     f82:	ec26                	sd	s1,24(sp)
     f84:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f86:	00002797          	auipc	a5,0x2
     f8a:	8727a783          	lw	a5,-1934(a5) # 27f8 <num_threads>
     f8e:	04f05063          	blez	a5,fce <free_stacks+0x52>
     f92:	e84a                	sd	s2,16(sp)
     f94:	e44e                	sd	s3,8(sp)
     f96:	4481                	li	s1,0
    free(stacks[i]);
     f98:	00002997          	auipc	s3,0x2
     f9c:	85898993          	addi	s3,s3,-1960 # 27f0 <stacks>
  for (int i = 0; i < num_threads; i++) {
     fa0:	00002917          	auipc	s2,0x2
     fa4:	85890913          	addi	s2,s2,-1960 # 27f8 <num_threads>
    free(stacks[i]);
     fa8:	0009b783          	ld	a5,0(s3)
     fac:	00349713          	slli	a4,s1,0x3
     fb0:	97ba                	add	a5,a5,a4
     fb2:	6388                	ld	a0,0(a5)
     fb4:	00000097          	auipc	ra,0x0
     fb8:	e2e080e7          	jalr	-466(ra) # de2 <free>
  for (int i = 0; i < num_threads; i++) {
     fbc:	0485                	addi	s1,s1,1
     fbe:	00092703          	lw	a4,0(s2)
     fc2:	0004879b          	sext.w	a5,s1
     fc6:	fee7c1e3          	blt	a5,a4,fa8 <free_stacks+0x2c>
     fca:	6942                	ld	s2,16(sp)
     fcc:	69a2                	ld	s3,8(sp)
  free(stacks);
     fce:	00002497          	auipc	s1,0x2
     fd2:	82248493          	addi	s1,s1,-2014 # 27f0 <stacks>
     fd6:	6088                	ld	a0,0(s1)
     fd8:	00000097          	auipc	ra,0x0
     fdc:	e0a080e7          	jalr	-502(ra) # de2 <free>
  stacks = 0;
     fe0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     fe4:	00002797          	auipc	a5,0x2
     fe8:	8007aa23          	sw	zero,-2028(a5) # 27f8 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     fec:	47a1                	li	a5,8
     fee:	00001717          	auipc	a4,0x1
     ff2:	7ef72523          	sw	a5,2026(a4) # 27d8 <max_stacks>
  threads_done = 0;
     ff6:	00002797          	auipc	a5,0x2
     ffa:	8007a323          	sw	zero,-2042(a5) # 27fc <threads_done>
}
     ffe:	4501                	li	a0,0
    1000:	70a2                	ld	ra,40(sp)
    1002:	7402                	ld	s0,32(sp)
    1004:	64e2                	ld	s1,24(sp)
    1006:	6145                	addi	sp,sp,48
    1008:	8082                	ret

000000000000100a <expand_num_threads>:
int expand_num_threads() {
    100a:	1101                	addi	sp,sp,-32
    100c:	ec06                	sd	ra,24(sp)
    100e:	e822                	sd	s0,16(sp)
    1010:	e426                	sd	s1,8(sp)
    1012:	e04a                	sd	s2,0(sp)
    1014:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1016:	00001797          	auipc	a5,0x1
    101a:	7c278793          	addi	a5,a5,1986 # 27d8 <max_stacks>
    101e:	4388                	lw	a0,0(a5)
    1020:	0015151b          	slliw	a0,a0,0x1
    1024:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1026:	0035151b          	slliw	a0,a0,0x3
    102a:	00000097          	auipc	ra,0x0
    102e:	e3e080e7          	jalr	-450(ra) # e68 <malloc>
    1032:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    1034:	00001617          	auipc	a2,0x1
    1038:	7c462603          	lw	a2,1988(a2) # 27f8 <num_threads>
    103c:	00001497          	auipc	s1,0x1
    1040:	7b448493          	addi	s1,s1,1972 # 27f0 <stacks>
    1044:	0036161b          	slliw	a2,a2,0x3
    1048:	608c                	ld	a1,0(s1)
    104a:	00000097          	auipc	ra,0x0
    104e:	8e4080e7          	jalr	-1820(ra) # 92e <memmove>
  free(stacks);
    1052:	6088                	ld	a0,0(s1)
    1054:	00000097          	auipc	ra,0x0
    1058:	d8e080e7          	jalr	-626(ra) # de2 <free>
  stacks = new_stacks;
    105c:	0124b023          	sd	s2,0(s1)
}
    1060:	4501                	li	a0,0
    1062:	60e2                	ld	ra,24(sp)
    1064:	6442                	ld	s0,16(sp)
    1066:	64a2                	ld	s1,8(sp)
    1068:	6902                	ld	s2,0(sp)
    106a:	6105                	addi	sp,sp,32
    106c:	8082                	ret

000000000000106e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    106e:	7179                	addi	sp,sp,-48
    1070:	f406                	sd	ra,40(sp)
    1072:	f022                	sd	s0,32(sp)
    1074:	e84a                	sd	s2,16(sp)
    1076:	e44e                	sd	s3,8(sp)
    1078:	1800                	addi	s0,sp,48
    107a:	892a                	mv	s2,a0
    107c:	89ae                	mv	s3,a1
  if (stacks == 0) {
    107e:	00001797          	auipc	a5,0x1
    1082:	7727b783          	ld	a5,1906(a5) # 27f0 <stacks>
    1086:	c3d9                	beqz	a5,110c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1088:	00001797          	auipc	a5,0x1
    108c:	7507a783          	lw	a5,1872(a5) # 27d8 <max_stacks>
    1090:	00001717          	auipc	a4,0x1
    1094:	76872703          	lw	a4,1896(a4) # 27f8 <num_threads>
    1098:	0af71363          	bne	a4,a5,113e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    109c:	04000713          	li	a4,64
    10a0:	08e78563          	beq	a5,a4,112a <ithread_create+0xbc>
    10a4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    10a6:	00000097          	auipc	ra,0x0
    10aa:	f64080e7          	jalr	-156(ra) # 100a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    10ae:	6505                	lui	a0,0x1
    10b0:	00000097          	auipc	ra,0x0
    10b4:	db8080e7          	jalr	-584(ra) # e68 <malloc>
    10b8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    10ba:	00001717          	auipc	a4,0x1
    10be:	73e72703          	lw	a4,1854(a4) # 27f8 <num_threads>
    10c2:	070e                	slli	a4,a4,0x3
    10c4:	00001797          	auipc	a5,0x1
    10c8:	72c7b783          	ld	a5,1836(a5) # 27f0 <stacks>
    10cc:	97ba                	add	a5,a5,a4
    10ce:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    10d0:	00000697          	auipc	a3,0x0
    10d4:	e9268693          	addi	a3,a3,-366 # f62 <ithread_exit>
    10d8:	862a                	mv	a2,a0
    10da:	85ce                	mv	a1,s3
    10dc:	854a                	mv	a0,s2
    10de:	00000097          	auipc	ra,0x0
    10e2:	9b2080e7          	jalr	-1614(ra) # a90 <create_thread>
    10e6:	892a                	mv	s2,a0
  if (res != -1) {
    10e8:	57fd                	li	a5,-1
    10ea:	04f50c63          	beq	a0,a5,1142 <ithread_create+0xd4>
    num_threads++;
    10ee:	00001717          	auipc	a4,0x1
    10f2:	70a70713          	addi	a4,a4,1802 # 27f8 <num_threads>
    10f6:	431c                	lw	a5,0(a4)
    10f8:	2785                	addiw	a5,a5,1
    10fa:	c31c                	sw	a5,0(a4)
    10fc:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    10fe:	854a                	mv	a0,s2
    1100:	70a2                	ld	ra,40(sp)
    1102:	7402                	ld	s0,32(sp)
    1104:	6942                	ld	s2,16(sp)
    1106:	69a2                	ld	s3,8(sp)
    1108:	6145                	addi	sp,sp,48
    110a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    110c:	00001517          	auipc	a0,0x1
    1110:	6cc52503          	lw	a0,1740(a0) # 27d8 <max_stacks>
    1114:	0035151b          	slliw	a0,a0,0x3
    1118:	00000097          	auipc	ra,0x0
    111c:	d50080e7          	jalr	-688(ra) # e68 <malloc>
    1120:	00001797          	auipc	a5,0x1
    1124:	6ca7b823          	sd	a0,1744(a5) # 27f0 <stacks>
    1128:	b785                	j	1088 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    112a:	00000517          	auipc	a0,0x0
    112e:	4ae50513          	addi	a0,a0,1198 # 15d8 <ithread_join+0x470>
    1132:	00000097          	auipc	ra,0x0
    1136:	c7a080e7          	jalr	-902(ra) # dac <printf>
      return -1;
    113a:	597d                	li	s2,-1
    113c:	b7c9                	j	10fe <ithread_create+0x90>
    113e:	ec26                	sd	s1,24(sp)
    1140:	b7bd                	j	10ae <ithread_create+0x40>
    free(stack_ptr);
    1142:	8526                	mv	a0,s1
    1144:	00000097          	auipc	ra,0x0
    1148:	c9e080e7          	jalr	-866(ra) # de2 <free>
    stacks[num_threads] = 0;
    114c:	00001717          	auipc	a4,0x1
    1150:	6ac72703          	lw	a4,1708(a4) # 27f8 <num_threads>
    1154:	070e                	slli	a4,a4,0x3
    1156:	00001797          	auipc	a5,0x1
    115a:	69a7b783          	ld	a5,1690(a5) # 27f0 <stacks>
    115e:	97ba                	add	a5,a5,a4
    1160:	0007b023          	sd	zero,0(a5)
    1164:	64e2                	ld	s1,24(sp)
    1166:	bf61                	j	10fe <ithread_create+0x90>

0000000000001168 <ithread_join>:

int ithread_join(int thread_id) {
    1168:	1101                	addi	sp,sp,-32
    116a:	ec06                	sd	ra,24(sp)
    116c:	e822                	sd	s0,16(sp)
    116e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1170:	ff040793          	addi	a5,s0,-16
    1174:	ffc7859b          	addiw	a1,a5,-4
    1178:	00000097          	auipc	ra,0x0
    117c:	920080e7          	jalr	-1760(ra) # a98 <join_thread>
  threads_done++;
    1180:	00001717          	auipc	a4,0x1
    1184:	67c70713          	addi	a4,a4,1660 # 27fc <threads_done>
    1188:	431c                	lw	a5,0(a4)
    118a:	2785                	addiw	a5,a5,1
    118c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    118e:	00001717          	auipc	a4,0x1
    1192:	66a72703          	lw	a4,1642(a4) # 27f8 <num_threads>
    1196:	00f70863          	beq	a4,a5,11a6 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    119a:	fec42503          	lw	a0,-20(s0)
    119e:	60e2                	ld	ra,24(sp)
    11a0:	6442                	ld	s0,16(sp)
    11a2:	6105                	addi	sp,sp,32
    11a4:	8082                	ret
    free_stacks();
    11a6:	00000097          	auipc	ra,0x0
    11aa:	dd6080e7          	jalr	-554(ra) # f7c <free_stacks>
    11ae:	b7f5                	j	119a <ithread_join+0x32>
