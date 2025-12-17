
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
      52:	16250513          	addi	a0,a0,354 # 11b0 <ithread_join+0x4c>
      56:	00001097          	auipc	ra,0x1
      5a:	d50080e7          	jalr	-688(ra) # da6 <printf>
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
      a2:	13250513          	addi	a0,a0,306 # 11d0 <ithread_join+0x6c>
      a6:	00001097          	auipc	ra,0x1
      aa:	d00080e7          	jalr	-768(ra) # da6 <printf>
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
      ce:	13e50513          	addi	a0,a0,318 # 1208 <ithread_join+0xa4>
      d2:	00001097          	auipc	ra,0x1
      d6:	cd4080e7          	jalr	-812(ra) # da6 <printf>
  fail = p[0]; // this should ideally trap or fail
      da:	00002797          	auipc	a5,0x2
      de:	6f67b783          	ld	a5,1782(a5) # 27d0 <p>
      e2:	4384                	lw	s1,0(a5)
  printf("Read after free: %d\n", fail);
      e4:	85a6                	mv	a1,s1
      e6:	00001517          	auipc	a0,0x1
      ea:	15250513          	addi	a0,a0,338 # 1238 <ithread_join+0xd4>
      ee:	00001097          	auipc	ra,0x1
      f2:	cb8080e7          	jalr	-840(ra) # da6 <printf>
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);
      f6:	85a6                	mv	a1,s1
      f8:	00001517          	auipc	a0,0x1
      fc:	15850513          	addi	a0,a0,344 # 1250 <ithread_join+0xec>
     100:	00001097          	auipc	ra,0x1
     104:	ca6080e7          	jalr	-858(ra) # da6 <printf>
}
     108:	4501                	li	a0,0
     10a:	60e2                	ld	ra,24(sp)
     10c:	6442                	ld	s0,16(sp)
     10e:	64a2                	ld	s1,8(sp)
     110:	6105                	addi	sp,sp,32
     112:	8082                	ret
    printf("FAIL: p is invalid\n");
     114:	00001517          	auipc	a0,0x1
     118:	0dc50513          	addi	a0,a0,220 # 11f0 <ithread_join+0x8c>
     11c:	00001097          	auipc	ra,0x1
     120:	c8a080e7          	jalr	-886(ra) # da6 <printf>
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
     164:	14050513          	addi	a0,a0,320 # 12a0 <ithread_join+0x13c>
     168:	00001097          	auipc	ra,0x1
     16c:	c3e080e7          	jalr	-962(ra) # da6 <printf>
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
     17e:	10650513          	addi	a0,a0,262 # 1280 <ithread_join+0x11c>
     182:	00001097          	auipc	ra,0x1
     186:	c24080e7          	jalr	-988(ra) # da6 <printf>
    return 0;
     18a:	b7dd                	j	170 <prop_mem_alloc2+0x4a>
    printf("PASSED\n");
     18c:	00001517          	auipc	a0,0x1
     190:	10c50513          	addi	a0,a0,268 # 1298 <ithread_join+0x134>
     194:	00001097          	auipc	ra,0x1
     198:	c12080e7          	jalr	-1006(ra) # da6 <printf>
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
     224:	00052903          	lw	s2,0(a0) # 1000 <free_stacks+0x8a>
  printf("Thread %d is running\n", val);
     228:	85ca                	mv	a1,s2
     22a:	00001517          	auipc	a0,0x1
     22e:	0a650513          	addi	a0,a0,166 # 12d0 <ithread_join+0x16c>
     232:	00001097          	auipc	ra,0x1
     236:	b74080e7          	jalr	-1164(ra) # da6 <printf>
  free(arg);
     23a:	8526                	mv	a0,s1
     23c:	00001097          	auipc	ra,0x1
     240:	ba0080e7          	jalr	-1120(ra) # ddc <free>
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
     262:	cfe080e7          	jalr	-770(ra) # f5c <ithread_exit>
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
     27c:	07050513          	addi	a0,a0,112 # 12e8 <ithread_join+0x184>
     280:	00001097          	auipc	ra,0x1
     284:	b26080e7          	jalr	-1242(ra) # da6 <printf>
  int *arg = malloc(sizeof(int));
     288:	4511                	li	a0,4
     28a:	00001097          	auipc	ra,0x1
     28e:	bd8080e7          	jalr	-1064(ra) # e62 <malloc>
     292:	85aa                	mv	a1,a0
  *arg = 0;
     294:	00052023          	sw	zero,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     298:	00000517          	auipc	a0,0x0
     29c:	f7e50513          	addi	a0,a0,-130 # 216 <thread_func_basic>
     2a0:	00001097          	auipc	ra,0x1
     2a4:	dc8080e7          	jalr	-568(ra) # 1068 <ithread_create>
  if (tid < 0) {
     2a8:	02054763          	bltz	a0,2d6 <test_thread_create+0x66>
     2ac:	e426                	sd	s1,8(sp)
     2ae:	84aa                	mv	s1,a0
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
     2b0:	85aa                	mv	a1,a0
     2b2:	00001517          	auipc	a0,0x1
     2b6:	07e50513          	addi	a0,a0,126 # 1330 <ithread_join+0x1cc>
     2ba:	00001097          	auipc	ra,0x1
     2be:	aec080e7          	jalr	-1300(ra) # da6 <printf>
    ithread_join(tid);
     2c2:	8526                	mv	a0,s1
     2c4:	00001097          	auipc	ra,0x1
     2c8:	ea0080e7          	jalr	-352(ra) # 1164 <ithread_join>
     2cc:	64a2                	ld	s1,8(sp)
}
     2ce:	60e2                	ld	ra,24(sp)
     2d0:	6442                	ld	s0,16(sp)
     2d2:	6105                	addi	sp,sp,32
     2d4:	8082                	ret
    printf("Test 1 FAILED - Thread not created\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	03250513          	addi	a0,a0,50 # 1308 <ithread_join+0x1a4>
     2de:	00001097          	auipc	ra,0x1
     2e2:	ac8080e7          	jalr	-1336(ra) # da6 <printf>
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
     2f8:	06c50513          	addi	a0,a0,108 # 1360 <ithread_join+0x1fc>
     2fc:	00001097          	auipc	ra,0x1
     300:	aaa080e7          	jalr	-1366(ra) # da6 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
     304:	4581                	li	a1,0
     306:	00000517          	auipc	a0,0x0
     30a:	e9850513          	addi	a0,a0,-360 # 19e <prop_mem_dealloc1>
     30e:	00001097          	auipc	ra,0x1
     312:	d5a080e7          	jalr	-678(ra) # 1068 <ithread_create>
     316:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
     318:	4581                	li	a1,0
     31a:	00000517          	auipc	a0,0x0
     31e:	d6250513          	addi	a0,a0,-670 # 7c <prop_mem_dealloc2>
     322:	00001097          	auipc	ra,0x1
     326:	d46080e7          	jalr	-698(ra) # 1068 <ithread_create>
     32a:	84aa                	mv	s1,a0
  ithread_join(tid1);
     32c:	854a                	mv	a0,s2
     32e:	00001097          	auipc	ra,0x1
     332:	e36080e7          	jalr	-458(ra) # 1164 <ithread_join>
  ithread_join(tid2);
     336:	8526                	mv	a0,s1
     338:	00001097          	auipc	ra,0x1
     33c:	e2c080e7          	jalr	-468(ra) # 1164 <ithread_join>
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
     35c:	02050513          	addi	a0,a0,32 # 1378 <ithread_join+0x214>
     360:	00001097          	auipc	ra,0x1
     364:	a46080e7          	jalr	-1466(ra) # da6 <printf>
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
     368:	4581                	li	a1,0
     36a:	00000517          	auipc	a0,0x0
     36e:	e7c50513          	addi	a0,a0,-388 # 1e6 <prop_mem_alloc1>
     372:	00001097          	auipc	ra,0x1
     376:	cf6080e7          	jalr	-778(ra) # 1068 <ithread_create>
     37a:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
     37c:	4581                	li	a1,0
     37e:	00000517          	auipc	a0,0x0
     382:	da850513          	addi	a0,a0,-600 # 126 <prop_mem_alloc2>
     386:	00001097          	auipc	ra,0x1
     38a:	ce2080e7          	jalr	-798(ra) # 1068 <ithread_create>
     38e:	84aa                	mv	s1,a0
  ithread_join(tid1);
     390:	854a                	mv	a0,s2
     392:	00001097          	auipc	ra,0x1
     396:	dd2080e7          	jalr	-558(ra) # 1164 <ithread_join>
  ithread_join(tid2);
     39a:	8526                	mv	a0,s1
     39c:	00001097          	auipc	ra,0x1
     3a0:	dc8080e7          	jalr	-568(ra) # 1164 <ithread_join>

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
     3bc:	fd850513          	addi	a0,a0,-40 # 1390 <ithread_join+0x22c>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	9e6080e7          	jalr	-1562(ra) # da6 <printf>

  int *arg = malloc(sizeof(int));
     3c8:	4511                	li	a0,4
     3ca:	00001097          	auipc	ra,0x1
     3ce:	a98080e7          	jalr	-1384(ra) # e62 <malloc>
     3d2:	85aa                	mv	a1,a0
  *arg = 100;
     3d4:	06400793          	li	a5,100
     3d8:	c11c                	sw	a5,0(a0)
  int tid = ithread_create(thread_func_basic, arg);
     3da:	00000517          	auipc	a0,0x0
     3de:	e3c50513          	addi	a0,a0,-452 # 216 <thread_func_basic>
     3e2:	00001097          	auipc	ra,0x1
     3e6:	c86080e7          	jalr	-890(ra) # 1068 <ithread_create>

  if (tid < 0) {
     3ea:	02054763          	bltz	a0,418 <test_thread_join+0x68>
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
     3ee:	00001097          	auipc	ra,0x1
     3f2:	d76080e7          	jalr	-650(ra) # 1164 <ithread_join>
     3f6:	85aa                	mv	a1,a0
  if (status == 101) {
     3f8:	06500793          	li	a5,101
     3fc:	02f50763          	beq	a0,a5,42a <test_thread_join+0x7a>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
     400:	00001517          	auipc	a0,0x1
     404:	01050513          	addi	a0,a0,16 # 1410 <ithread_join+0x2ac>
     408:	00001097          	auipc	ra,0x1
     40c:	99e080e7          	jalr	-1634(ra) # da6 <printf>
  }
}
     410:	60a2                	ld	ra,8(sp)
     412:	6402                	ld	s0,0(sp)
     414:	0141                	addi	sp,sp,16
     416:	8082                	ret
    printf("Test 2 FAILED - Could not create thread\n");
     418:	00001517          	auipc	a0,0x1
     41c:	f9850513          	addi	a0,a0,-104 # 13b0 <ithread_join+0x24c>
     420:	00001097          	auipc	ra,0x1
     424:	986080e7          	jalr	-1658(ra) # da6 <printf>
    return;
     428:	b7e5                	j	410 <test_thread_join+0x60>
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
     42a:	00001517          	auipc	a0,0x1
     42e:	fb650513          	addi	a0,a0,-74 # 13e0 <ithread_join+0x27c>
     432:	00001097          	auipc	ra,0x1
     436:	974080e7          	jalr	-1676(ra) # da6 <printf>
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
     450:	fec50513          	addi	a0,a0,-20 # 1438 <ithread_join+0x2d4>
     454:	00001097          	auipc	ra,0x1
     458:	952080e7          	jalr	-1710(ra) # da6 <printf>

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
     47e:	bee080e7          	jalr	-1042(ra) # 1068 <ithread_create>
     482:	00a92023          	sw	a0,0(s2)
  for (int i = 0; i < 4; i++) {
     486:	0911                	addi	s2,s2,4
     488:	ff3917e3          	bne	s2,s3,476 <test_shared_memory+0x3a>
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
     48c:	4088                	lw	a0,0(s1)
     48e:	00001097          	auipc	ra,0x1
     492:	cd6080e7          	jalr	-810(ra) # 1164 <ithread_join>
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
     4b0:	fdc50513          	addi	a0,a0,-36 # 1488 <ithread_join+0x324>
     4b4:	00001097          	auipc	ra,0x1
     4b8:	8f2080e7          	jalr	-1806(ra) # da6 <printf>
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
     4d0:	f9450513          	addi	a0,a0,-108 # 1460 <ithread_join+0x2fc>
     4d4:	00001097          	auipc	ra,0x1
     4d8:	8d2080e7          	jalr	-1838(ra) # da6 <printf>
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
     4ea:	fca50513          	addi	a0,a0,-54 # 14b0 <ithread_join+0x34c>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	8b8080e7          	jalr	-1864(ra) # da6 <printf>

  int tid = ithread_create(thread_func_exit, 0);
     4f6:	4581                	li	a1,0
     4f8:	00000517          	auipc	a0,0x0
     4fc:	d5c50513          	addi	a0,a0,-676 # 254 <thread_func_exit>
     500:	00001097          	auipc	ra,0x1
     504:	b68080e7          	jalr	-1176(ra) # 1068 <ithread_create>
  int status = ithread_join(tid);
     508:	00001097          	auipc	ra,0x1
     50c:	c5c080e7          	jalr	-932(ra) # 1164 <ithread_join>
     510:	85aa                	mv	a1,a0

  if (status == 0) {
     512:	ed09                	bnez	a0,52c <test_exit+0x4e>
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
     514:	00001517          	auipc	a0,0x1
     518:	fc450513          	addi	a0,a0,-60 # 14d8 <ithread_join+0x374>
     51c:	00001097          	auipc	ra,0x1
     520:	88a080e7          	jalr	-1910(ra) # da6 <printf>
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
     530:	fec50513          	addi	a0,a0,-20 # 1518 <ithread_join+0x3b4>
     534:	00001097          	auipc	ra,0x1
     538:	872080e7          	jalr	-1934(ra) # da6 <printf>
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
     558:	ff450513          	addi	a0,a0,-12 # 1548 <ithread_join+0x3e4>
     55c:	00001097          	auipc	ra,0x1
     560:	84a080e7          	jalr	-1974(ra) # da6 <printf>
  int *num = malloc(10*sizeof(int));
     564:	02800513          	li	a0,40
     568:	00001097          	auipc	ra,0x1
     56c:	8fa080e7          	jalr	-1798(ra) # e62 <malloc>
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
     592:	ada080e7          	jalr	-1318(ra) # 1068 <ithread_create>
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
     5ae:	bba080e7          	jalr	-1094(ra) # 1164 <ithread_join>
  for (int i = 0; i < 10; i++) {
     5b2:	0491                	addi	s1,s1,4
     5b4:	ff249ae3          	bne	s1,s2,5a8 <test_exit_all+0x6a>
  }
  free(num);
     5b8:	855e                	mv	a0,s7
     5ba:	00001097          	auipc	ra,0x1
     5be:	822080e7          	jalr	-2014(ra) # ddc <free>
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
     5ee:	f8e50513          	addi	a0,a0,-114 # 1578 <ithread_join+0x414>
     5f2:	00000097          	auipc	ra,0x0
     5f6:	7b4080e7          	jalr	1972(ra) # da6 <printf>
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
     62c:	fdc70713          	addi	a4,a4,-36 # 1604 <ithread_join+0x4a0>
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
     682:	f2250513          	addi	a0,a0,-222 # 15a0 <ithread_join+0x43c>
     686:	00000097          	auipc	ra,0x0
     68a:	720080e7          	jalr	1824(ra) # da6 <printf>
     68e:	a849                	j	720 <main+0x148>
  }
  }else{
   test_thread_create();
     690:	00000097          	auipc	ra,0x0
     694:	be0080e7          	jalr	-1056(ra) # 270 <test_thread_create>
   printf("\n");
     698:	00001517          	auipc	a0,0x1
     69c:	f3050513          	addi	a0,a0,-208 # 15c8 <ithread_join+0x464>
     6a0:	00000097          	auipc	ra,0x0
     6a4:	706080e7          	jalr	1798(ra) # da6 <printf>
   test_thread_join();
     6a8:	00000097          	auipc	ra,0x0
     6ac:	d08080e7          	jalr	-760(ra) # 3b0 <test_thread_join>
   printf("\n");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	f1850513          	addi	a0,a0,-232 # 15c8 <ithread_join+0x464>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	6ee080e7          	jalr	1774(ra) # da6 <printf>
   test_shared_memory();
     6c0:	00000097          	auipc	ra,0x0
     6c4:	d7c080e7          	jalr	-644(ra) # 43c <test_shared_memory>
   printf("\n");
     6c8:	00001517          	auipc	a0,0x1
     6cc:	f0050513          	addi	a0,a0,-256 # 15c8 <ithread_join+0x464>
     6d0:	00000097          	auipc	ra,0x0
     6d4:	6d6080e7          	jalr	1750(ra) # da6 <printf>
   test_exit();
     6d8:	00000097          	auipc	ra,0x0
     6dc:	e06080e7          	jalr	-506(ra) # 4de <test_exit>
   printf("\n");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	ee850513          	addi	a0,a0,-280 # 15c8 <ithread_join+0x464>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	6be080e7          	jalr	1726(ra) # da6 <printf>
   // test_exit_all();
   printf("\n");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	ed850513          	addi	a0,a0,-296 # 15c8 <ithread_join+0x464>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	6ae080e7          	jalr	1710(ra) # da6 <printf>
   test_global_pointer_alloc();
     700:	00000097          	auipc	ra,0x0
     704:	c4c080e7          	jalr	-948(ra) # 34c <test_global_pointer_alloc>
   printf("\n");
     708:	00001517          	auipc	a0,0x1
     70c:	ec050513          	addi	a0,a0,-320 # 15c8 <ithread_join+0x464>
     710:	00000097          	auipc	ra,0x0
     714:	696080e7          	jalr	1686(ra) # da6 <printf>
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

0000000000000aba <send>:
.global send
send:
 li a7, SYS_send
     aba:	48fd                	li	a7,31
 ecall
     abc:	00000073          	ecall
 ret
     ac0:	8082                	ret

0000000000000ac2 <recv>:
.global recv
recv:
 li a7, SYS_recv
     ac2:	02000893          	li	a7,32
 ecall
     ac6:	00000073          	ecall
 ret
     aca:	8082                	ret

0000000000000acc <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     acc:	02100893          	li	a7,33
 ecall
     ad0:	00000073          	ecall
 ret
     ad4:	8082                	ret

0000000000000ad6 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
     ad6:	02200893          	li	a7,34
 ecall
     ada:	00000073          	ecall
 ret
     ade:	8082                	ret

0000000000000ae0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ae0:	1101                	addi	sp,sp,-32
     ae2:	ec06                	sd	ra,24(sp)
     ae4:	e822                	sd	s0,16(sp)
     ae6:	1000                	addi	s0,sp,32
     ae8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     aec:	4605                	li	a2,1
     aee:	fef40593          	addi	a1,s0,-17
     af2:	00000097          	auipc	ra,0x0
     af6:	f00080e7          	jalr	-256(ra) # 9f2 <write>
}
     afa:	60e2                	ld	ra,24(sp)
     afc:	6442                	ld	s0,16(sp)
     afe:	6105                	addi	sp,sp,32
     b00:	8082                	ret

0000000000000b02 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     b02:	7139                	addi	sp,sp,-64
     b04:	fc06                	sd	ra,56(sp)
     b06:	f822                	sd	s0,48(sp)
     b08:	f04a                	sd	s2,32(sp)
     b0a:	ec4e                	sd	s3,24(sp)
     b0c:	0080                	addi	s0,sp,64
     b0e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     b10:	cad9                	beqz	a3,ba6 <printint+0xa4>
     b12:	01f5d79b          	srliw	a5,a1,0x1f
     b16:	cbc1                	beqz	a5,ba6 <printint+0xa4>
    neg = 1;
    x = -xx;
     b18:	40b005bb          	negw	a1,a1
    neg = 1;
     b1c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     b1e:	fc040993          	addi	s3,s0,-64
  neg = 0;
     b22:	86ce                	mv	a3,s3
  i = 0;
     b24:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     b26:	00001817          	auipc	a6,0x1
     b2a:	b5280813          	addi	a6,a6,-1198 # 1678 <digits>
     b2e:	88ba                	mv	a7,a4
     b30:	0017051b          	addiw	a0,a4,1
     b34:	872a                	mv	a4,a0
     b36:	02c5f7bb          	remuw	a5,a1,a2
     b3a:	1782                	slli	a5,a5,0x20
     b3c:	9381                	srli	a5,a5,0x20
     b3e:	97c2                	add	a5,a5,a6
     b40:	0007c783          	lbu	a5,0(a5)
     b44:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     b48:	87ae                	mv	a5,a1
     b4a:	02c5d5bb          	divuw	a1,a1,a2
     b4e:	0685                	addi	a3,a3,1
     b50:	fcc7ffe3          	bgeu	a5,a2,b2e <printint+0x2c>
  if(neg)
     b54:	00030c63          	beqz	t1,b6c <printint+0x6a>
    buf[i++] = '-';
     b58:	fd050793          	addi	a5,a0,-48
     b5c:	00878533          	add	a0,a5,s0
     b60:	02d00793          	li	a5,45
     b64:	fef50823          	sb	a5,-16(a0)
     b68:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     b6c:	02e05763          	blez	a4,b9a <printint+0x98>
     b70:	f426                	sd	s1,40(sp)
     b72:	377d                	addiw	a4,a4,-1
     b74:	00e984b3          	add	s1,s3,a4
     b78:	19fd                	addi	s3,s3,-1
     b7a:	99ba                	add	s3,s3,a4
     b7c:	1702                	slli	a4,a4,0x20
     b7e:	9301                	srli	a4,a4,0x20
     b80:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b84:	0004c583          	lbu	a1,0(s1)
     b88:	854a                	mv	a0,s2
     b8a:	00000097          	auipc	ra,0x0
     b8e:	f56080e7          	jalr	-170(ra) # ae0 <putc>
  while(--i >= 0)
     b92:	14fd                	addi	s1,s1,-1
     b94:	ff3498e3          	bne	s1,s3,b84 <printint+0x82>
     b98:	74a2                	ld	s1,40(sp)
}
     b9a:	70e2                	ld	ra,56(sp)
     b9c:	7442                	ld	s0,48(sp)
     b9e:	7902                	ld	s2,32(sp)
     ba0:	69e2                	ld	s3,24(sp)
     ba2:	6121                	addi	sp,sp,64
     ba4:	8082                	ret
  neg = 0;
     ba6:	4301                	li	t1,0
     ba8:	bf9d                	j	b1e <printint+0x1c>

0000000000000baa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     baa:	715d                	addi	sp,sp,-80
     bac:	e486                	sd	ra,72(sp)
     bae:	e0a2                	sd	s0,64(sp)
     bb0:	f84a                	sd	s2,48(sp)
     bb2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     bb4:	0005c903          	lbu	s2,0(a1)
     bb8:	1a090b63          	beqz	s2,d6e <vprintf+0x1c4>
     bbc:	fc26                	sd	s1,56(sp)
     bbe:	f44e                	sd	s3,40(sp)
     bc0:	f052                	sd	s4,32(sp)
     bc2:	ec56                	sd	s5,24(sp)
     bc4:	e85a                	sd	s6,16(sp)
     bc6:	e45e                	sd	s7,8(sp)
     bc8:	8aaa                	mv	s5,a0
     bca:	8bb2                	mv	s7,a2
     bcc:	00158493          	addi	s1,a1,1
  state = 0;
     bd0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     bd2:	02500a13          	li	s4,37
     bd6:	4b55                	li	s6,21
     bd8:	a839                	j	bf6 <vprintf+0x4c>
        putc(fd, c);
     bda:	85ca                	mv	a1,s2
     bdc:	8556                	mv	a0,s5
     bde:	00000097          	auipc	ra,0x0
     be2:	f02080e7          	jalr	-254(ra) # ae0 <putc>
     be6:	a019                	j	bec <vprintf+0x42>
    } else if(state == '%'){
     be8:	01498d63          	beq	s3,s4,c02 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     bec:	0485                	addi	s1,s1,1
     bee:	fff4c903          	lbu	s2,-1(s1)
     bf2:	16090863          	beqz	s2,d62 <vprintf+0x1b8>
    if(state == 0){
     bf6:	fe0999e3          	bnez	s3,be8 <vprintf+0x3e>
      if(c == '%'){
     bfa:	ff4910e3          	bne	s2,s4,bda <vprintf+0x30>
        state = '%';
     bfe:	89d2                	mv	s3,s4
     c00:	b7f5                	j	bec <vprintf+0x42>
      if(c == 'd'){
     c02:	13490563          	beq	s2,s4,d2c <vprintf+0x182>
     c06:	f9d9079b          	addiw	a5,s2,-99
     c0a:	0ff7f793          	zext.b	a5,a5
     c0e:	12fb6863          	bltu	s6,a5,d3e <vprintf+0x194>
     c12:	f9d9079b          	addiw	a5,s2,-99
     c16:	0ff7f713          	zext.b	a4,a5
     c1a:	12eb6263          	bltu	s6,a4,d3e <vprintf+0x194>
     c1e:	00271793          	slli	a5,a4,0x2
     c22:	00001717          	auipc	a4,0x1
     c26:	9fe70713          	addi	a4,a4,-1538 # 1620 <ithread_join+0x4bc>
     c2a:	97ba                	add	a5,a5,a4
     c2c:	439c                	lw	a5,0(a5)
     c2e:	97ba                	add	a5,a5,a4
     c30:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     c32:	008b8913          	addi	s2,s7,8
     c36:	4685                	li	a3,1
     c38:	4629                	li	a2,10
     c3a:	000ba583          	lw	a1,0(s7)
     c3e:	8556                	mv	a0,s5
     c40:	00000097          	auipc	ra,0x0
     c44:	ec2080e7          	jalr	-318(ra) # b02 <printint>
     c48:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     c4a:	4981                	li	s3,0
     c4c:	b745                	j	bec <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c4e:	008b8913          	addi	s2,s7,8
     c52:	4681                	li	a3,0
     c54:	4629                	li	a2,10
     c56:	000ba583          	lw	a1,0(s7)
     c5a:	8556                	mv	a0,s5
     c5c:	00000097          	auipc	ra,0x0
     c60:	ea6080e7          	jalr	-346(ra) # b02 <printint>
     c64:	8bca                	mv	s7,s2
      state = 0;
     c66:	4981                	li	s3,0
     c68:	b751                	j	bec <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     c6a:	008b8913          	addi	s2,s7,8
     c6e:	4681                	li	a3,0
     c70:	4641                	li	a2,16
     c72:	000ba583          	lw	a1,0(s7)
     c76:	8556                	mv	a0,s5
     c78:	00000097          	auipc	ra,0x0
     c7c:	e8a080e7          	jalr	-374(ra) # b02 <printint>
     c80:	8bca                	mv	s7,s2
      state = 0;
     c82:	4981                	li	s3,0
     c84:	b7a5                	j	bec <vprintf+0x42>
     c86:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     c88:	008b8793          	addi	a5,s7,8
     c8c:	8c3e                	mv	s8,a5
     c8e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     c92:	03000593          	li	a1,48
     c96:	8556                	mv	a0,s5
     c98:	00000097          	auipc	ra,0x0
     c9c:	e48080e7          	jalr	-440(ra) # ae0 <putc>
  putc(fd, 'x');
     ca0:	07800593          	li	a1,120
     ca4:	8556                	mv	a0,s5
     ca6:	00000097          	auipc	ra,0x0
     caa:	e3a080e7          	jalr	-454(ra) # ae0 <putc>
     cae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     cb0:	00001b97          	auipc	s7,0x1
     cb4:	9c8b8b93          	addi	s7,s7,-1592 # 1678 <digits>
     cb8:	03c9d793          	srli	a5,s3,0x3c
     cbc:	97de                	add	a5,a5,s7
     cbe:	0007c583          	lbu	a1,0(a5)
     cc2:	8556                	mv	a0,s5
     cc4:	00000097          	auipc	ra,0x0
     cc8:	e1c080e7          	jalr	-484(ra) # ae0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ccc:	0992                	slli	s3,s3,0x4
     cce:	397d                	addiw	s2,s2,-1
     cd0:	fe0914e3          	bnez	s2,cb8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     cd4:	8be2                	mv	s7,s8
      state = 0;
     cd6:	4981                	li	s3,0
     cd8:	6c02                	ld	s8,0(sp)
     cda:	bf09                	j	bec <vprintf+0x42>
        s = va_arg(ap, char*);
     cdc:	008b8993          	addi	s3,s7,8
     ce0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     ce4:	02090163          	beqz	s2,d06 <vprintf+0x15c>
        while(*s != 0){
     ce8:	00094583          	lbu	a1,0(s2)
     cec:	c9a5                	beqz	a1,d5c <vprintf+0x1b2>
          putc(fd, *s);
     cee:	8556                	mv	a0,s5
     cf0:	00000097          	auipc	ra,0x0
     cf4:	df0080e7          	jalr	-528(ra) # ae0 <putc>
          s++;
     cf8:	0905                	addi	s2,s2,1
        while(*s != 0){
     cfa:	00094583          	lbu	a1,0(s2)
     cfe:	f9e5                	bnez	a1,cee <vprintf+0x144>
        s = va_arg(ap, char*);
     d00:	8bce                	mv	s7,s3
      state = 0;
     d02:	4981                	li	s3,0
     d04:	b5e5                	j	bec <vprintf+0x42>
          s = "(null)";
     d06:	00001917          	auipc	s2,0x1
     d0a:	8ca90913          	addi	s2,s2,-1846 # 15d0 <ithread_join+0x46c>
        while(*s != 0){
     d0e:	02800593          	li	a1,40
     d12:	bff1                	j	cee <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     d14:	008b8913          	addi	s2,s7,8
     d18:	000bc583          	lbu	a1,0(s7)
     d1c:	8556                	mv	a0,s5
     d1e:	00000097          	auipc	ra,0x0
     d22:	dc2080e7          	jalr	-574(ra) # ae0 <putc>
     d26:	8bca                	mv	s7,s2
      state = 0;
     d28:	4981                	li	s3,0
     d2a:	b5c9                	j	bec <vprintf+0x42>
        putc(fd, c);
     d2c:	02500593          	li	a1,37
     d30:	8556                	mv	a0,s5
     d32:	00000097          	auipc	ra,0x0
     d36:	dae080e7          	jalr	-594(ra) # ae0 <putc>
      state = 0;
     d3a:	4981                	li	s3,0
     d3c:	bd45                	j	bec <vprintf+0x42>
        putc(fd, '%');
     d3e:	02500593          	li	a1,37
     d42:	8556                	mv	a0,s5
     d44:	00000097          	auipc	ra,0x0
     d48:	d9c080e7          	jalr	-612(ra) # ae0 <putc>
        putc(fd, c);
     d4c:	85ca                	mv	a1,s2
     d4e:	8556                	mv	a0,s5
     d50:	00000097          	auipc	ra,0x0
     d54:	d90080e7          	jalr	-624(ra) # ae0 <putc>
      state = 0;
     d58:	4981                	li	s3,0
     d5a:	bd49                	j	bec <vprintf+0x42>
        s = va_arg(ap, char*);
     d5c:	8bce                	mv	s7,s3
      state = 0;
     d5e:	4981                	li	s3,0
     d60:	b571                	j	bec <vprintf+0x42>
     d62:	74e2                	ld	s1,56(sp)
     d64:	79a2                	ld	s3,40(sp)
     d66:	7a02                	ld	s4,32(sp)
     d68:	6ae2                	ld	s5,24(sp)
     d6a:	6b42                	ld	s6,16(sp)
     d6c:	6ba2                	ld	s7,8(sp)
    }
  }
}
     d6e:	60a6                	ld	ra,72(sp)
     d70:	6406                	ld	s0,64(sp)
     d72:	7942                	ld	s2,48(sp)
     d74:	6161                	addi	sp,sp,80
     d76:	8082                	ret

0000000000000d78 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     d78:	715d                	addi	sp,sp,-80
     d7a:	ec06                	sd	ra,24(sp)
     d7c:	e822                	sd	s0,16(sp)
     d7e:	1000                	addi	s0,sp,32
     d80:	e010                	sd	a2,0(s0)
     d82:	e414                	sd	a3,8(s0)
     d84:	e818                	sd	a4,16(s0)
     d86:	ec1c                	sd	a5,24(s0)
     d88:	03043023          	sd	a6,32(s0)
     d8c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     d90:	8622                	mv	a2,s0
     d92:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     d96:	00000097          	auipc	ra,0x0
     d9a:	e14080e7          	jalr	-492(ra) # baa <vprintf>
}
     d9e:	60e2                	ld	ra,24(sp)
     da0:	6442                	ld	s0,16(sp)
     da2:	6161                	addi	sp,sp,80
     da4:	8082                	ret

0000000000000da6 <printf>:

void
printf(const char *fmt, ...)
{
     da6:	711d                	addi	sp,sp,-96
     da8:	ec06                	sd	ra,24(sp)
     daa:	e822                	sd	s0,16(sp)
     dac:	1000                	addi	s0,sp,32
     dae:	e40c                	sd	a1,8(s0)
     db0:	e810                	sd	a2,16(s0)
     db2:	ec14                	sd	a3,24(s0)
     db4:	f018                	sd	a4,32(s0)
     db6:	f41c                	sd	a5,40(s0)
     db8:	03043823          	sd	a6,48(s0)
     dbc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     dc0:	00840613          	addi	a2,s0,8
     dc4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     dc8:	85aa                	mv	a1,a0
     dca:	4505                	li	a0,1
     dcc:	00000097          	auipc	ra,0x0
     dd0:	dde080e7          	jalr	-546(ra) # baa <vprintf>
}
     dd4:	60e2                	ld	ra,24(sp)
     dd6:	6442                	ld	s0,16(sp)
     dd8:	6125                	addi	sp,sp,96
     dda:	8082                	ret

0000000000000ddc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ddc:	1141                	addi	sp,sp,-16
     dde:	e406                	sd	ra,8(sp)
     de0:	e022                	sd	s0,0(sp)
     de2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     de4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     de8:	00002797          	auipc	a5,0x2
     dec:	a007b783          	ld	a5,-1536(a5) # 27e8 <freep>
     df0:	a039                	j	dfe <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     df2:	6398                	ld	a4,0(a5)
     df4:	00e7e463          	bltu	a5,a4,dfc <free+0x20>
     df8:	00e6ea63          	bltu	a3,a4,e0c <free+0x30>
{
     dfc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     dfe:	fed7fae3          	bgeu	a5,a3,df2 <free+0x16>
     e02:	6398                	ld	a4,0(a5)
     e04:	00e6e463          	bltu	a3,a4,e0c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e08:	fee7eae3          	bltu	a5,a4,dfc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     e0c:	ff852583          	lw	a1,-8(a0)
     e10:	6390                	ld	a2,0(a5)
     e12:	02059813          	slli	a6,a1,0x20
     e16:	01c85713          	srli	a4,a6,0x1c
     e1a:	9736                	add	a4,a4,a3
     e1c:	02e60563          	beq	a2,a4,e46 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     e20:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     e24:	4790                	lw	a2,8(a5)
     e26:	02061593          	slli	a1,a2,0x20
     e2a:	01c5d713          	srli	a4,a1,0x1c
     e2e:	973e                	add	a4,a4,a5
     e30:	02e68263          	beq	a3,a4,e54 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     e34:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     e36:	00002717          	auipc	a4,0x2
     e3a:	9af73923          	sd	a5,-1614(a4) # 27e8 <freep>
}
     e3e:	60a2                	ld	ra,8(sp)
     e40:	6402                	ld	s0,0(sp)
     e42:	0141                	addi	sp,sp,16
     e44:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
     e46:	4618                	lw	a4,8(a2)
     e48:	9f2d                	addw	a4,a4,a1
     e4a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     e4e:	6398                	ld	a4,0(a5)
     e50:	6310                	ld	a2,0(a4)
     e52:	b7f9                	j	e20 <free+0x44>
    p->s.size += bp->s.size;
     e54:	ff852703          	lw	a4,-8(a0)
     e58:	9f31                	addw	a4,a4,a2
     e5a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     e5c:	ff053683          	ld	a3,-16(a0)
     e60:	bfd1                	j	e34 <free+0x58>

0000000000000e62 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     e62:	7139                	addi	sp,sp,-64
     e64:	fc06                	sd	ra,56(sp)
     e66:	f822                	sd	s0,48(sp)
     e68:	f04a                	sd	s2,32(sp)
     e6a:	ec4e                	sd	s3,24(sp)
     e6c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     e6e:	02051993          	slli	s3,a0,0x20
     e72:	0209d993          	srli	s3,s3,0x20
     e76:	09bd                	addi	s3,s3,15
     e78:	0049d993          	srli	s3,s3,0x4
     e7c:	2985                	addiw	s3,s3,1
     e7e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     e80:	00002517          	auipc	a0,0x2
     e84:	96853503          	ld	a0,-1688(a0) # 27e8 <freep>
     e88:	c905                	beqz	a0,eb8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     e8a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     e8c:	4798                	lw	a4,8(a5)
     e8e:	09377a63          	bgeu	a4,s3,f22 <malloc+0xc0>
     e92:	f426                	sd	s1,40(sp)
     e94:	e852                	sd	s4,16(sp)
     e96:	e456                	sd	s5,8(sp)
     e98:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     e9a:	8a4e                	mv	s4,s3
     e9c:	6705                	lui	a4,0x1
     e9e:	00e9f363          	bgeu	s3,a4,ea4 <malloc+0x42>
     ea2:	6a05                	lui	s4,0x1
     ea4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     ea8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     eac:	00002497          	auipc	s1,0x2
     eb0:	93c48493          	addi	s1,s1,-1732 # 27e8 <freep>
  if(p == (char*)-1)
     eb4:	5afd                	li	s5,-1
     eb6:	a089                	j	ef8 <malloc+0x96>
     eb8:	f426                	sd	s1,40(sp)
     eba:	e852                	sd	s4,16(sp)
     ebc:	e456                	sd	s5,8(sp)
     ebe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     ec0:	00002797          	auipc	a5,0x2
     ec4:	94078793          	addi	a5,a5,-1728 # 2800 <base>
     ec8:	00002717          	auipc	a4,0x2
     ecc:	92f73023          	sd	a5,-1760(a4) # 27e8 <freep>
     ed0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     ed2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     ed6:	b7d1                	j	e9a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
     ed8:	6398                	ld	a4,0(a5)
     eda:	e118                	sd	a4,0(a0)
     edc:	a8b9                	j	f3a <malloc+0xd8>
  hp->s.size = nu;
     ede:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     ee2:	0541                	addi	a0,a0,16
     ee4:	00000097          	auipc	ra,0x0
     ee8:	ef8080e7          	jalr	-264(ra) # ddc <free>
  return freep;
     eec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
     eee:	c135                	beqz	a0,f52 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     ef0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     ef2:	4798                	lw	a4,8(a5)
     ef4:	03277363          	bgeu	a4,s2,f1a <malloc+0xb8>
    if(p == freep)
     ef8:	6098                	ld	a4,0(s1)
     efa:	853e                	mv	a0,a5
     efc:	fef71ae3          	bne	a4,a5,ef0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
     f00:	8552                	mv	a0,s4
     f02:	00000097          	auipc	ra,0x0
     f06:	b58080e7          	jalr	-1192(ra) # a5a <sbrk>
  if(p == (char*)-1)
     f0a:	fd551ae3          	bne	a0,s5,ede <malloc+0x7c>
        return 0;
     f0e:	4501                	li	a0,0
     f10:	74a2                	ld	s1,40(sp)
     f12:	6a42                	ld	s4,16(sp)
     f14:	6aa2                	ld	s5,8(sp)
     f16:	6b02                	ld	s6,0(sp)
     f18:	a03d                	j	f46 <malloc+0xe4>
     f1a:	74a2                	ld	s1,40(sp)
     f1c:	6a42                	ld	s4,16(sp)
     f1e:	6aa2                	ld	s5,8(sp)
     f20:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     f22:	fae90be3          	beq	s2,a4,ed8 <malloc+0x76>
        p->s.size -= nunits;
     f26:	4137073b          	subw	a4,a4,s3
     f2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f2c:	02071693          	slli	a3,a4,0x20
     f30:	01c6d713          	srli	a4,a3,0x1c
     f34:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     f36:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     f3a:	00002717          	auipc	a4,0x2
     f3e:	8aa73723          	sd	a0,-1874(a4) # 27e8 <freep>
      return (void*)(p + 1);
     f42:	01078513          	addi	a0,a5,16
  }
}
     f46:	70e2                	ld	ra,56(sp)
     f48:	7442                	ld	s0,48(sp)
     f4a:	7902                	ld	s2,32(sp)
     f4c:	69e2                	ld	s3,24(sp)
     f4e:	6121                	addi	sp,sp,64
     f50:	8082                	ret
     f52:	74a2                	ld	s1,40(sp)
     f54:	6a42                	ld	s4,16(sp)
     f56:	6aa2                	ld	s5,8(sp)
     f58:	6b02                	ld	s6,0(sp)
     f5a:	b7f5                	j	f46 <malloc+0xe4>

0000000000000f5c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
     f5c:	1141                	addi	sp,sp,-16
     f5e:	e406                	sd	ra,8(sp)
     f60:	e022                	sd	s0,0(sp)
     f62:	0800                	addi	s0,sp,16
  thread_exit(status);
     f64:	2501                	sext.w	a0,a0
     f66:	00000097          	auipc	ra,0x0
     f6a:	b24080e7          	jalr	-1244(ra) # a8a <thread_exit>
}
     f6e:	60a2                	ld	ra,8(sp)
     f70:	6402                	ld	s0,0(sp)
     f72:	0141                	addi	sp,sp,16
     f74:	8082                	ret

0000000000000f76 <free_stacks>:
int free_stacks() {
     f76:	7179                	addi	sp,sp,-48
     f78:	f406                	sd	ra,40(sp)
     f7a:	f022                	sd	s0,32(sp)
     f7c:	ec26                	sd	s1,24(sp)
     f7e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
     f80:	00002797          	auipc	a5,0x2
     f84:	8787a783          	lw	a5,-1928(a5) # 27f8 <num_threads>
     f88:	04f05063          	blez	a5,fc8 <free_stacks+0x52>
     f8c:	e84a                	sd	s2,16(sp)
     f8e:	e44e                	sd	s3,8(sp)
     f90:	4481                	li	s1,0
    free(stacks[i]);
     f92:	00002997          	auipc	s3,0x2
     f96:	85e98993          	addi	s3,s3,-1954 # 27f0 <stacks>
  for (int i = 0; i < num_threads; i++) {
     f9a:	00002917          	auipc	s2,0x2
     f9e:	85e90913          	addi	s2,s2,-1954 # 27f8 <num_threads>
    free(stacks[i]);
     fa2:	0009b783          	ld	a5,0(s3)
     fa6:	00349713          	slli	a4,s1,0x3
     faa:	97ba                	add	a5,a5,a4
     fac:	6388                	ld	a0,0(a5)
     fae:	00000097          	auipc	ra,0x0
     fb2:	e2e080e7          	jalr	-466(ra) # ddc <free>
  for (int i = 0; i < num_threads; i++) {
     fb6:	0485                	addi	s1,s1,1
     fb8:	00092703          	lw	a4,0(s2)
     fbc:	0004879b          	sext.w	a5,s1
     fc0:	fee7c1e3          	blt	a5,a4,fa2 <free_stacks+0x2c>
     fc4:	6942                	ld	s2,16(sp)
     fc6:	69a2                	ld	s3,8(sp)
  free(stacks);
     fc8:	00002497          	auipc	s1,0x2
     fcc:	82848493          	addi	s1,s1,-2008 # 27f0 <stacks>
     fd0:	6088                	ld	a0,0(s1)
     fd2:	00000097          	auipc	ra,0x0
     fd6:	e0a080e7          	jalr	-502(ra) # ddc <free>
  stacks = 0;
     fda:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
     fde:	00002797          	auipc	a5,0x2
     fe2:	8007ad23          	sw	zero,-2022(a5) # 27f8 <num_threads>
  max_stacks = INIT_MAX_STACKS;
     fe6:	47a1                	li	a5,8
     fe8:	00001717          	auipc	a4,0x1
     fec:	7ef72823          	sw	a5,2032(a4) # 27d8 <max_stacks>
  threads_done = 0;
     ff0:	00002797          	auipc	a5,0x2
     ff4:	8007a623          	sw	zero,-2036(a5) # 27fc <threads_done>
}
     ff8:	4501                	li	a0,0
     ffa:	70a2                	ld	ra,40(sp)
     ffc:	7402                	ld	s0,32(sp)
     ffe:	64e2                	ld	s1,24(sp)
    1000:	6145                	addi	sp,sp,48
    1002:	8082                	ret

0000000000001004 <expand_num_threads>:
int expand_num_threads() {
    1004:	1101                	addi	sp,sp,-32
    1006:	ec06                	sd	ra,24(sp)
    1008:	e822                	sd	s0,16(sp)
    100a:	e426                	sd	s1,8(sp)
    100c:	e04a                	sd	s2,0(sp)
    100e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    1010:	00001797          	auipc	a5,0x1
    1014:	7c878793          	addi	a5,a5,1992 # 27d8 <max_stacks>
    1018:	4388                	lw	a0,0(a5)
    101a:	0015151b          	slliw	a0,a0,0x1
    101e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    1020:	0035151b          	slliw	a0,a0,0x3
    1024:	00000097          	auipc	ra,0x0
    1028:	e3e080e7          	jalr	-450(ra) # e62 <malloc>
    102c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    102e:	00001617          	auipc	a2,0x1
    1032:	7ca62603          	lw	a2,1994(a2) # 27f8 <num_threads>
    1036:	00001497          	auipc	s1,0x1
    103a:	7ba48493          	addi	s1,s1,1978 # 27f0 <stacks>
    103e:	0036161b          	slliw	a2,a2,0x3
    1042:	608c                	ld	a1,0(s1)
    1044:	00000097          	auipc	ra,0x0
    1048:	8d8080e7          	jalr	-1832(ra) # 91c <memmove>
  free(stacks);
    104c:	6088                	ld	a0,0(s1)
    104e:	00000097          	auipc	ra,0x0
    1052:	d8e080e7          	jalr	-626(ra) # ddc <free>
  stacks = new_stacks;
    1056:	0124b023          	sd	s2,0(s1)
}
    105a:	4501                	li	a0,0
    105c:	60e2                	ld	ra,24(sp)
    105e:	6442                	ld	s0,16(sp)
    1060:	64a2                	ld	s1,8(sp)
    1062:	6902                	ld	s2,0(sp)
    1064:	6105                	addi	sp,sp,32
    1066:	8082                	ret

0000000000001068 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1068:	7179                	addi	sp,sp,-48
    106a:	f406                	sd	ra,40(sp)
    106c:	f022                	sd	s0,32(sp)
    106e:	e84a                	sd	s2,16(sp)
    1070:	e44e                	sd	s3,8(sp)
    1072:	1800                	addi	s0,sp,48
    1074:	892a                	mv	s2,a0
    1076:	89ae                	mv	s3,a1
  if (stacks == 0) {
    1078:	00001797          	auipc	a5,0x1
    107c:	7787b783          	ld	a5,1912(a5) # 27f0 <stacks>
    1080:	c3d9                	beqz	a5,1106 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    1082:	00001797          	auipc	a5,0x1
    1086:	7567a783          	lw	a5,1878(a5) # 27d8 <max_stacks>
    108a:	00001717          	auipc	a4,0x1
    108e:	76e72703          	lw	a4,1902(a4) # 27f8 <num_threads>
    1092:	0af71463          	bne	a4,a5,113a <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
    1096:	04000713          	li	a4,64
    109a:	08e78563          	beq	a5,a4,1124 <ithread_create+0xbc>
    109e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    10a0:	00000097          	auipc	ra,0x0
    10a4:	f64080e7          	jalr	-156(ra) # 1004 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    10a8:	6505                	lui	a0,0x1
    10aa:	00000097          	auipc	ra,0x0
    10ae:	db8080e7          	jalr	-584(ra) # e62 <malloc>
    10b2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    10b4:	00001717          	auipc	a4,0x1
    10b8:	74472703          	lw	a4,1860(a4) # 27f8 <num_threads>
    10bc:	070e                	slli	a4,a4,0x3
    10be:	00001797          	auipc	a5,0x1
    10c2:	7327b783          	ld	a5,1842(a5) # 27f0 <stacks>
    10c6:	97ba                	add	a5,a5,a4
    10c8:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    10ca:	00000697          	auipc	a3,0x0
    10ce:	e9268693          	addi	a3,a3,-366 # f5c <ithread_exit>
    10d2:	862a                	mv	a2,a0
    10d4:	85ce                	mv	a1,s3
    10d6:	854a                	mv	a0,s2
    10d8:	00000097          	auipc	ra,0x0
    10dc:	9a2080e7          	jalr	-1630(ra) # a7a <create_thread>
    10e0:	892a                	mv	s2,a0
  if (res != -1) {
    10e2:	57fd                	li	a5,-1
    10e4:	04f50d63          	beq	a0,a5,113e <ithread_create+0xd6>
    num_threads++;
    10e8:	00001717          	auipc	a4,0x1
    10ec:	71070713          	addi	a4,a4,1808 # 27f8 <num_threads>
    10f0:	431c                	lw	a5,0(a4)
    10f2:	2785                	addiw	a5,a5,1
    10f4:	c31c                	sw	a5,0(a4)
    10f6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    10f8:	854a                	mv	a0,s2
    10fa:	70a2                	ld	ra,40(sp)
    10fc:	7402                	ld	s0,32(sp)
    10fe:	6942                	ld	s2,16(sp)
    1100:	69a2                	ld	s3,8(sp)
    1102:	6145                	addi	sp,sp,48
    1104:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    1106:	00001517          	auipc	a0,0x1
    110a:	6d252503          	lw	a0,1746(a0) # 27d8 <max_stacks>
    110e:	0035151b          	slliw	a0,a0,0x3
    1112:	00000097          	auipc	ra,0x0
    1116:	d50080e7          	jalr	-688(ra) # e62 <malloc>
    111a:	00001797          	auipc	a5,0x1
    111e:	6ca7bb23          	sd	a0,1750(a5) # 27f0 <stacks>
    1122:	b785                	j	1082 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    1124:	00000517          	auipc	a0,0x0
    1128:	4b450513          	addi	a0,a0,1204 # 15d8 <ithread_join+0x474>
    112c:	00000097          	auipc	ra,0x0
    1130:	c7a080e7          	jalr	-902(ra) # da6 <printf>
      return -1;
    1134:	57fd                	li	a5,-1
    1136:	893e                	mv	s2,a5
    1138:	b7c1                	j	10f8 <ithread_create+0x90>
    113a:	ec26                	sd	s1,24(sp)
    113c:	b7b5                	j	10a8 <ithread_create+0x40>
    free(stack_ptr);
    113e:	8526                	mv	a0,s1
    1140:	00000097          	auipc	ra,0x0
    1144:	c9c080e7          	jalr	-868(ra) # ddc <free>
    stacks[num_threads] = 0;
    1148:	00001717          	auipc	a4,0x1
    114c:	6b072703          	lw	a4,1712(a4) # 27f8 <num_threads>
    1150:	070e                	slli	a4,a4,0x3
    1152:	00001797          	auipc	a5,0x1
    1156:	69e7b783          	ld	a5,1694(a5) # 27f0 <stacks>
    115a:	97ba                	add	a5,a5,a4
    115c:	0007b023          	sd	zero,0(a5)
    1160:	64e2                	ld	s1,24(sp)
    1162:	bf59                	j	10f8 <ithread_create+0x90>

0000000000001164 <ithread_join>:

int ithread_join(int thread_id) {
    1164:	1101                	addi	sp,sp,-32
    1166:	ec06                	sd	ra,24(sp)
    1168:	e822                	sd	s0,16(sp)
    116a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    116c:	ff040793          	addi	a5,s0,-16
    1170:	ffc7859b          	addiw	a1,a5,-4
    1174:	00000097          	auipc	ra,0x0
    1178:	90e080e7          	jalr	-1778(ra) # a82 <join_thread>
  threads_done++;
    117c:	00001717          	auipc	a4,0x1
    1180:	68070713          	addi	a4,a4,1664 # 27fc <threads_done>
    1184:	431c                	lw	a5,0(a4)
    1186:	2785                	addiw	a5,a5,1
    1188:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    118a:	00001717          	auipc	a4,0x1
    118e:	66e72703          	lw	a4,1646(a4) # 27f8 <num_threads>
    1192:	00f70863          	beq	a4,a5,11a2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
    1196:	fec42503          	lw	a0,-20(s0)
    119a:	60e2                	ld	ra,24(sp)
    119c:	6442                	ld	s0,16(sp)
    119e:	6105                	addi	sp,sp,32
    11a0:	8082                	ret
    free_stacks();
    11a2:	00000097          	auipc	ra,0x0
    11a6:	dd4080e7          	jalr	-556(ra) # f76 <free_stacks>
    11aa:	b7f5                	j	1196 <ithread_join+0x32>
