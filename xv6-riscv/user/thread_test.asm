
user/_thread_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_nothing2>:
  }
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  return 0;
}

void *do_nothing2(void *args) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  int *tidx = (int *)args;
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
   a:	4104                	lw	s1,0(a0)
   c:	00000097          	auipc	ra,0x0
  10:	6fc080e7          	jalr	1788(ra) # 708 <getpid>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	00001517          	auipc	a0,0x1
  1c:	df850513          	addi	a0,a0,-520 # e10 <ithread_join+0x52>
  20:	00001097          	auipc	ra,0x1
  24:	a02080e7          	jalr	-1534(ra) # a22 <printf>
  printf("Global value: %d\n", global);
  28:	00002497          	auipc	s1,0x2
  2c:	fd848493          	addi	s1,s1,-40 # 2000 <global>
  30:	408c                	lw	a1,0(s1)
  32:	00001517          	auipc	a0,0x1
  36:	e0650513          	addi	a0,a0,-506 # e38 <ithread_join+0x7a>
  3a:	00001097          	auipc	ra,0x1
  3e:	9e8080e7          	jalr	-1560(ra) # a22 <printf>
  global += 5;
  42:	409c                	lw	a5,0(s1)
  44:	2795                	addiw	a5,a5,5
  46:	c09c                	sw	a5,0(s1)
  return 0;
}
  48:	4501                	li	a0,0
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6105                	addi	sp,sp,32
  52:	8082                	ret

0000000000000054 <prop_mem_dealloc2>:
  p = (int *)sbrk(-4096);            // deallocate
  return 0;
}

void *prop_mem_dealloc2(void *arg)
{
  54:	1101                	addi	sp,sp,-32
  56:	ec06                	sd	ra,24(sp)
  58:	e822                	sd	s0,16(sp)
  5a:	e426                	sd	s1,8(sp)
  5c:	1000                	addi	s0,sp,32
  sleep(50); // wait for allocation
  5e:	03200513          	li	a0,50
  62:	00000097          	auipc	ra,0x0
  66:	6b6080e7          	jalr	1718(ra) # 718 <sleep>
  int val = p[0]; // should be 42 before deallocation
  6a:	00002497          	auipc	s1,0x2
  6e:	f9e48493          	addi	s1,s1,-98 # 2008 <p>
  72:	609c                	ld	a5,0(s1)
  printf("Read before free: %d\n", val);
  74:	438c                	lw	a1,0(a5)
  76:	00001517          	auipc	a0,0x1
  7a:	dda50513          	addi	a0,a0,-550 # e50 <ithread_join+0x92>
  7e:	00001097          	auipc	ra,0x1
  82:	9a4080e7          	jalr	-1628(ra) # a22 <printf>

  sleep(60); // wait for deallocation
  86:	03c00513          	li	a0,60
  8a:	00000097          	auipc	ra,0x0
  8e:	68e080e7          	jalr	1678(ra) # 718 <sleep>

  // Try to access deallocated memory
  int fail = 0;
  if (p == (int *)0xdeadbeef) {
  92:	6098                	ld	a4,0(s1)
  94:	37ab77b7          	lui	a5,0x37ab7
  98:	078a                	slli	a5,a5,0x2
  9a:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4eaf>
  9e:	02f70d63          	beq	a4,a5,d8 <prop_mem_dealloc2+0x84>
    printf("FAIL: p is invalid\n");
    return 0;
  }

  // Expect a fault or incorrect behavior
  printf("Read after free: ");
  a2:	00001517          	auipc	a0,0x1
  a6:	dde50513          	addi	a0,a0,-546 # e80 <ithread_join+0xc2>
  aa:	00001097          	auipc	ra,0x1
  ae:	978080e7          	jalr	-1672(ra) # a22 <printf>
  fail = p[0]; // this should ideally trap or fail
  printf("%d (expected trap or garbage)\n", fail);
  b2:	00002797          	auipc	a5,0x2
  b6:	f567b783          	ld	a5,-170(a5) # 2008 <p>
  ba:	438c                	lw	a1,0(a5)
  bc:	00001517          	auipc	a0,0x1
  c0:	ddc50513          	addi	a0,a0,-548 # e98 <ithread_join+0xda>
  c4:	00001097          	auipc	ra,0x1
  c8:	95e080e7          	jalr	-1698(ra) # a22 <printf>

  return 0;
}
  cc:	4501                	li	a0,0
  ce:	60e2                	ld	ra,24(sp)
  d0:	6442                	ld	s0,16(sp)
  d2:	64a2                	ld	s1,8(sp)
  d4:	6105                	addi	sp,sp,32
  d6:	8082                	ret
    printf("FAIL: p is invalid\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	d9050513          	addi	a0,a0,-624 # e68 <ithread_join+0xaa>
  e0:	00001097          	auipc	ra,0x1
  e4:	942080e7          	jalr	-1726(ra) # a22 <printf>
    return 0;
  e8:	b7d5                	j	cc <prop_mem_dealloc2+0x78>

00000000000000ea <prop_mem_add2>:
  p[1] = 2;
  return 0;
}

void *prop_mem_add2(void *arg)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  sleep(50);
  f2:	03200513          	li	a0,50
  f6:	00000097          	auipc	ra,0x0
  fa:	622080e7          	jalr	1570(ra) # 718 <sleep>
  if(p == (int *)0xdeadbeef) {
  fe:	00002717          	auipc	a4,0x2
 102:	f0a73703          	ld	a4,-246(a4) # 2008 <p>
 106:	37ab77b7          	lui	a5,0x37ab7
 10a:	078a                	slli	a5,a5,0x2
 10c:	eef78793          	addi	a5,a5,-273 # 37ab6eef <base+0x37ab4eaf>
 110:	02f70763          	beq	a4,a5,13e <prop_mem_add2+0x54>
    printf("FAIL: p == 0xdeadbeef\n");
    return 0;
  }

  if(p[0] == 3 && p[1] == 2) {
 114:	4314                	lw	a3,0(a4)
 116:	478d                	li	a5,3
 118:	00f69663          	bne	a3,a5,124 <prop_mem_add2+0x3a>
 11c:	4358                	lw	a4,4(a4)
 11e:	4789                	li	a5,2
 120:	02f70863          	beq	a4,a5,150 <prop_mem_add2+0x66>
    printf("PASSED\n");
    // SUCCESS
  } else {
    printf("FAIL: values did not change for siblings\n");
 124:	00001517          	auipc	a0,0x1
 128:	db450513          	addi	a0,a0,-588 # ed8 <ithread_join+0x11a>
 12c:	00001097          	auipc	ra,0x1
 130:	8f6080e7          	jalr	-1802(ra) # a22 <printf>
    // FAIL
  }
  return 0;
}
 134:	4501                	li	a0,0
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
    printf("FAIL: p == 0xdeadbeef\n");
 13e:	00001517          	auipc	a0,0x1
 142:	d7a50513          	addi	a0,a0,-646 # eb8 <ithread_join+0xfa>
 146:	00001097          	auipc	ra,0x1
 14a:	8dc080e7          	jalr	-1828(ra) # a22 <printf>
    return 0;
 14e:	b7dd                	j	134 <prop_mem_add2+0x4a>
    printf("PASSED\n");
 150:	00001517          	auipc	a0,0x1
 154:	d8050513          	addi	a0,a0,-640 # ed0 <ithread_join+0x112>
 158:	00001097          	auipc	ra,0x1
 15c:	8ca080e7          	jalr	-1846(ra) # a22 <printf>
 160:	bfd1                	j	134 <prop_mem_add2+0x4a>

0000000000000162 <prop_mem_dealloc1>:
{
 162:	1101                	addi	sp,sp,-32
 164:	ec06                	sd	ra,24(sp)
 166:	e822                	sd	s0,16(sp)
 168:	e426                	sd	s1,8(sp)
 16a:	1000                	addi	s0,sp,32
  p = (int *)sbrk(4096);  // allocate a page
 16c:	6505                	lui	a0,0x1
 16e:	00000097          	auipc	ra,0x0
 172:	5a2080e7          	jalr	1442(ra) # 710 <sbrk>
 176:	00002497          	auipc	s1,0x2
 17a:	e9248493          	addi	s1,s1,-366 # 2008 <p>
 17e:	e088                	sd	a0,0(s1)
  p[0] = 42;
 180:	02a00793          	li	a5,42
 184:	c11c                	sw	a5,0(a0)
  sleep(50);              // allow thread 2 to read
 186:	03200513          	li	a0,50
 18a:	00000097          	auipc	ra,0x0
 18e:	58e080e7          	jalr	1422(ra) # 718 <sleep>
  p = (int *)sbrk(-4096);            // deallocate
 192:	757d                	lui	a0,0xfffff
 194:	00000097          	auipc	ra,0x0
 198:	57c080e7          	jalr	1404(ra) # 710 <sbrk>
 19c:	e088                	sd	a0,0(s1)
}
 19e:	4501                	li	a0,0
 1a0:	60e2                	ld	ra,24(sp)
 1a2:	6442                	ld	s0,16(sp)
 1a4:	64a2                	ld	s1,8(sp)
 1a6:	6105                	addi	sp,sp,32
 1a8:	8082                	ret

00000000000001aa <prop_mem_add1>:
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  p = (int *)sbrk(4096);
 1b2:	6505                	lui	a0,0x1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	55c080e7          	jalr	1372(ra) # 710 <sbrk>
 1bc:	00002797          	auipc	a5,0x2
 1c0:	e4c78793          	addi	a5,a5,-436 # 2008 <p>
 1c4:	e388                	sd	a0,0(a5)
  p[0] = 3;
 1c6:	470d                	li	a4,3
 1c8:	c118                	sw	a4,0(a0)
  p[1] = 2;
 1ca:	639c                	ld	a5,0(a5)
 1cc:	4709                	li	a4,2
 1ce:	c3d8                	sw	a4,4(a5)
}
 1d0:	4501                	li	a0,0
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <do_nothing>:
void *do_nothing(void *args) {
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	1000                	addi	s0,sp,32
 1e4:	84aa                	mv	s1,a0
  if (*tidx == 1) {
 1e6:	4118                	lw	a4,0(a0)
 1e8:	4785                	li	a5,1
 1ea:	02f70763          	beq	a4,a5,218 <do_nothing+0x3e>
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
 1ee:	4084                	lw	s1,0(s1)
 1f0:	00000097          	auipc	ra,0x0
 1f4:	518080e7          	jalr	1304(ra) # 708 <getpid>
 1f8:	862a                	mv	a2,a0
 1fa:	85a6                	mv	a1,s1
 1fc:	00001517          	auipc	a0,0x1
 200:	c1450513          	addi	a0,a0,-1004 # e10 <ithread_join+0x52>
 204:	00001097          	auipc	ra,0x1
 208:	81e080e7          	jalr	-2018(ra) # a22 <printf>
}
 20c:	4501                	li	a0,0
 20e:	60e2                	ld	ra,24(sp)
 210:	6442                	ld	s0,16(sp)
 212:	64a2                	ld	s1,8(sp)
 214:	6105                	addi	sp,sp,32
 216:	8082                	ret
    sleep(20);
 218:	4551                	li	a0,20
 21a:	00000097          	auipc	ra,0x0
 21e:	4fe080e7          	jalr	1278(ra) # 718 <sleep>
 222:	b7f1                	j	1ee <do_nothing+0x14>

0000000000000224 <test_global_pointer_alloc>:

void test_global_pointer_alloc() {
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
  printf("--- BEGIN sbrk(+) TEST ---\n");
 230:	00001517          	auipc	a0,0x1
 234:	cd850513          	addi	a0,a0,-808 # f08 <ithread_join+0x14a>
 238:	00000097          	auipc	ra,0x0
 23c:	7ea080e7          	jalr	2026(ra) # a22 <printf>
  int tid1 = ithread_create(prop_mem_add1, (void *)0);
 240:	4581                	li	a1,0
 242:	00000517          	auipc	a0,0x0
 246:	f6850513          	addi	a0,a0,-152 # 1aa <prop_mem_add1>
 24a:	00001097          	auipc	ra,0x1
 24e:	a80080e7          	jalr	-1408(ra) # cca <ithread_create>
 252:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_add2, (void *)0);
 254:	4581                	li	a1,0
 256:	00000517          	auipc	a0,0x0
 25a:	e9450513          	addi	a0,a0,-364 # ea <prop_mem_add2>
 25e:	00001097          	auipc	ra,0x1
 262:	a6c080e7          	jalr	-1428(ra) # cca <ithread_create>
 266:	84aa                	mv	s1,a0
  ithread_join(tid1);
 268:	854a                	mv	a0,s2
 26a:	00001097          	auipc	ra,0x1
 26e:	b54080e7          	jalr	-1196(ra) # dbe <ithread_join>
  ithread_join(tid2);
 272:	8526                	mv	a0,s1
 274:	00001097          	auipc	ra,0x1
 278:	b4a080e7          	jalr	-1206(ra) # dbe <ithread_join>

}
 27c:	60e2                	ld	ra,24(sp)
 27e:	6442                	ld	s0,16(sp)
 280:	64a2                	ld	s1,8(sp)
 282:	6902                	ld	s2,0(sp)
 284:	6105                	addi	sp,sp,32
 286:	8082                	ret

0000000000000288 <test_global_pointer_free>:

void test_global_pointer_free() {
 288:	1101                	addi	sp,sp,-32
 28a:	ec06                	sd	ra,24(sp)
 28c:	e822                	sd	s0,16(sp)
 28e:	e426                	sd	s1,8(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
  printf("--- BEGIN sbrk(-) TEST ---\n");
 294:	00001517          	auipc	a0,0x1
 298:	c9450513          	addi	a0,a0,-876 # f28 <ithread_join+0x16a>
 29c:	00000097          	auipc	ra,0x0
 2a0:	786080e7          	jalr	1926(ra) # a22 <printf>
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
 2a4:	4581                	li	a1,0
 2a6:	00000517          	auipc	a0,0x0
 2aa:	ebc50513          	addi	a0,a0,-324 # 162 <prop_mem_dealloc1>
 2ae:	00001097          	auipc	ra,0x1
 2b2:	a1c080e7          	jalr	-1508(ra) # cca <ithread_create>
 2b6:	892a                	mv	s2,a0
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
 2b8:	4581                	li	a1,0
 2ba:	00000517          	auipc	a0,0x0
 2be:	d9a50513          	addi	a0,a0,-614 # 54 <prop_mem_dealloc2>
 2c2:	00001097          	auipc	ra,0x1
 2c6:	a08080e7          	jalr	-1528(ra) # cca <ithread_create>
 2ca:	84aa                	mv	s1,a0
  // int tid3 = ithread_create(prop_mem_dealloc2, 0);

  ithread_join(tid1);
 2cc:	854a                	mv	a0,s2
 2ce:	00001097          	auipc	ra,0x1
 2d2:	af0080e7          	jalr	-1296(ra) # dbe <ithread_join>
  ithread_join(tid2);
 2d6:	8526                	mv	a0,s1
 2d8:	00001097          	auipc	ra,0x1
 2dc:	ae6080e7          	jalr	-1306(ra) # dbe <ithread_join>
  // ithread_join(tid3);
}
 2e0:	60e2                	ld	ra,24(sp)
 2e2:	6442                	ld	s0,16(sp)
 2e4:	64a2                	ld	s1,8(sp)
 2e6:	6902                	ld	s2,0(sp)
 2e8:	6105                	addi	sp,sp,32
 2ea:	8082                	ret

00000000000002ec <test_many_threads>:

void test_many_threads() {
 2ec:	715d                	addi	sp,sp,-80
 2ee:	e486                	sd	ra,72(sp)
 2f0:	e0a2                	sd	s0,64(sp)
 2f2:	fc26                	sd	s1,56(sp)
 2f4:	f84a                	sd	s2,48(sp)
 2f6:	f44e                	sd	s3,40(sp)
 2f8:	f052                	sd	s4,32(sp)
 2fa:	ec56                	sd	s5,24(sp)
 2fc:	e85a                	sd	s6,16(sp)
 2fe:	e45e                	sd	s7,8(sp)
 300:	e062                	sd	s8,0(sp)
 302:	0880                	addi	s0,sp,80
  printf("--- BEGIN MANY THREADS TEST ---\n");
 304:	00001517          	auipc	a0,0x1
 308:	c4450513          	addi	a0,a0,-956 # f48 <ithread_join+0x18a>
 30c:	00000097          	auipc	ra,0x0
 310:	716080e7          	jalr	1814(ra) # a22 <printf>
  uint64 *tids = malloc(sizeof(uint64)*(MAX_THREADS));
 314:	20000513          	li	a0,512
 318:	00000097          	auipc	ra,0x0
 31c:	7c2080e7          	jalr	1986(ra) # ada <malloc>
 320:	8aaa                	mv	s5,a0
  int *nums = malloc(sizeof(int)*(MAX_THREADS));
 322:	10000513          	li	a0,256
 326:	00000097          	auipc	ra,0x0
 32a:	7b4080e7          	jalr	1972(ra) # ada <malloc>
 32e:	8b2a                	mv	s6,a0
  for (int i = 0; i < MAX_THREADS; i++) {
 330:	892a                	mv	s2,a0
 332:	89d6                	mv	s3,s5
  int *nums = malloc(sizeof(int)*(MAX_THREADS));
 334:	8a56                	mv	s4,s5
  for (int i = 0; i < MAX_THREADS; i++) {
 336:	4481                	li	s1,0
    nums[i] = i;
    tids[i] = ithread_create(do_nothing2, (void *)&nums[i]);
 338:	00000c17          	auipc	s8,0x0
 33c:	cc8c0c13          	addi	s8,s8,-824 # 0 <do_nothing2>
  for (int i = 0; i < MAX_THREADS; i++) {
 340:	04000b93          	li	s7,64
    nums[i] = i;
 344:	00992023          	sw	s1,0(s2)
    tids[i] = ithread_create(do_nothing2, (void *)&nums[i]);
 348:	85ca                	mv	a1,s2
 34a:	8562                	mv	a0,s8
 34c:	00001097          	auipc	ra,0x1
 350:	97e080e7          	jalr	-1666(ra) # cca <ithread_create>
 354:	00aa3023          	sd	a0,0(s4)
  for (int i = 0; i < MAX_THREADS; i++) {
 358:	2485                	addiw	s1,s1,1
 35a:	0911                	addi	s2,s2,4
 35c:	0a21                	addi	s4,s4,8
 35e:	ff7493e3          	bne	s1,s7,344 <test_many_threads+0x58>
  }
  sleep(10);
 362:	4529                	li	a0,10
 364:	00000097          	auipc	ra,0x0
 368:	3b4080e7          	jalr	948(ra) # 718 <sleep>
 36c:	4485                	li	s1,1
  for (int i = 0; i < MAX_THREADS; i++) {
    if (tids[i] != -1) {
 36e:	5a7d                	li	s4,-1
      int result = ithread_join(tids[i]);
      printf("Joined thread %d (tid = %d) returned %d!\n", i + 1, tids[i], result);
 370:	00001b97          	auipc	s7,0x1
 374:	c00b8b93          	addi	s7,s7,-1024 # f70 <ithread_join+0x1b2>
  for (int i = 0; i < MAX_THREADS; i++) {
 378:	04100913          	li	s2,65
 37c:	a029                	j	386 <test_many_threads+0x9a>
 37e:	09a1                	addi	s3,s3,8
 380:	2485                	addiw	s1,s1,1
 382:	03248563          	beq	s1,s2,3ac <test_many_threads+0xc0>
    if (tids[i] != -1) {
 386:	0009b503          	ld	a0,0(s3)
 38a:	ff450ae3          	beq	a0,s4,37e <test_many_threads+0x92>
      int result = ithread_join(tids[i]);
 38e:	2501                	sext.w	a0,a0
 390:	00001097          	auipc	ra,0x1
 394:	a2e080e7          	jalr	-1490(ra) # dbe <ithread_join>
 398:	86aa                	mv	a3,a0
      printf("Joined thread %d (tid = %d) returned %d!\n", i + 1, tids[i], result);
 39a:	0009b603          	ld	a2,0(s3)
 39e:	85a6                	mv	a1,s1
 3a0:	855e                	mv	a0,s7
 3a2:	00000097          	auipc	ra,0x0
 3a6:	680080e7          	jalr	1664(ra) # a22 <printf>
 3aa:	bfd1                	j	37e <test_many_threads+0x92>
    }
  }
  free(nums);
 3ac:	855a                	mv	a0,s6
 3ae:	00000097          	auipc	ra,0x0
 3b2:	6aa080e7          	jalr	1706(ra) # a58 <free>
  free(tids);
 3b6:	8556                	mv	a0,s5
 3b8:	00000097          	auipc	ra,0x0
 3bc:	6a0080e7          	jalr	1696(ra) # a58 <free>
}
 3c0:	60a6                	ld	ra,72(sp)
 3c2:	6406                	ld	s0,64(sp)
 3c4:	74e2                	ld	s1,56(sp)
 3c6:	7942                	ld	s2,48(sp)
 3c8:	79a2                	ld	s3,40(sp)
 3ca:	7a02                	ld	s4,32(sp)
 3cc:	6ae2                	ld	s5,24(sp)
 3ce:	6b42                	ld	s6,16(sp)
 3d0:	6ba2                	ld	s7,8(sp)
 3d2:	6c02                	ld	s8,0(sp)
 3d4:	6161                	addi	sp,sp,80
 3d6:	8082                	ret

00000000000003d8 <main>:

int main(int argc, char *argv[]) {
 3d8:	1141                	addi	sp,sp,-16
 3da:	e406                	sd	ra,8(sp)
 3dc:	e022                	sd	s0,0(sp)
 3de:	0800                	addi	s0,sp,16
  //   int result = join_thread(tids[i], (uint64)&status);
  //   printf("Joined thread %d (tid = %d) returned %d! status = %d\n", i, tids[i], result, status);
  // }
  // for (int i = 0; i < MAX_THREADS; i++) {
  // test_global_pointer_alloc();
  test_global_pointer_free();
 3e0:	00000097          	auipc	ra,0x0
 3e4:	ea8080e7          	jalr	-344(ra) # 288 <test_global_pointer_free>
  // }
  printf("Tests complete!\n");
 3e8:	00001517          	auipc	a0,0x1
 3ec:	bb850513          	addi	a0,a0,-1096 # fa0 <ithread_join+0x1e2>
 3f0:	00000097          	auipc	ra,0x0
 3f4:	632080e7          	jalr	1586(ra) # a22 <printf>
  return 0;
}
 3f8:	4501                	li	a0,0
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  extern int main();
  main();
 40a:	00000097          	auipc	ra,0x0
 40e:	fce080e7          	jalr	-50(ra) # 3d8 <main>
  exit(0);
 412:	4501                	li	a0,0
 414:	00000097          	auipc	ra,0x0
 418:	274080e7          	jalr	628(ra) # 688 <exit>

000000000000041c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 41c:	1141                	addi	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 422:	87aa                	mv	a5,a0
 424:	0585                	addi	a1,a1,1
 426:	0785                	addi	a5,a5,1
 428:	fff5c703          	lbu	a4,-1(a1)
 42c:	fee78fa3          	sb	a4,-1(a5)
 430:	fb75                	bnez	a4,424 <strcpy+0x8>
    ;
  return os;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret

0000000000000438 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 43e:	00054783          	lbu	a5,0(a0)
 442:	cb91                	beqz	a5,456 <strcmp+0x1e>
 444:	0005c703          	lbu	a4,0(a1)
 448:	00f71763          	bne	a4,a5,456 <strcmp+0x1e>
    p++, q++;
 44c:	0505                	addi	a0,a0,1
 44e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 450:	00054783          	lbu	a5,0(a0)
 454:	fbe5                	bnez	a5,444 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 456:	0005c503          	lbu	a0,0(a1)
}
 45a:	40a7853b          	subw	a0,a5,a0
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret

0000000000000464 <strlen>:

uint
strlen(const char *s)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 46a:	00054783          	lbu	a5,0(a0)
 46e:	cf91                	beqz	a5,48a <strlen+0x26>
 470:	0505                	addi	a0,a0,1
 472:	87aa                	mv	a5,a0
 474:	4685                	li	a3,1
 476:	9e89                	subw	a3,a3,a0
 478:	00f6853b          	addw	a0,a3,a5
 47c:	0785                	addi	a5,a5,1
 47e:	fff7c703          	lbu	a4,-1(a5)
 482:	fb7d                	bnez	a4,478 <strlen+0x14>
    ;
  return n;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
  for(n = 0; s[n]; n++)
 48a:	4501                	li	a0,0
 48c:	bfe5                	j	484 <strlen+0x20>

000000000000048e <memset>:

void*
memset(void *dst, int c, uint n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e422                	sd	s0,8(sp)
 492:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 494:	ca19                	beqz	a2,4aa <memset+0x1c>
 496:	87aa                	mv	a5,a0
 498:	1602                	slli	a2,a2,0x20
 49a:	9201                	srli	a2,a2,0x20
 49c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4a4:	0785                	addi	a5,a5,1
 4a6:	fee79de3          	bne	a5,a4,4a0 <memset+0x12>
  }
  return dst;
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret

00000000000004b0 <strchr>:

char*
strchr(const char *s, char c)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4b6:	00054783          	lbu	a5,0(a0)
 4ba:	cb99                	beqz	a5,4d0 <strchr+0x20>
    if(*s == c)
 4bc:	00f58763          	beq	a1,a5,4ca <strchr+0x1a>
  for(; *s; s++)
 4c0:	0505                	addi	a0,a0,1
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	fbfd                	bnez	a5,4bc <strchr+0xc>
      return (char*)s;
  return 0;
 4c8:	4501                	li	a0,0
}
 4ca:	6422                	ld	s0,8(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret
  return 0;
 4d0:	4501                	li	a0,0
 4d2:	bfe5                	j	4ca <strchr+0x1a>

00000000000004d4 <gets>:

char*
gets(char *buf, int max)
{
 4d4:	711d                	addi	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e4a6                	sd	s1,72(sp)
 4dc:	e0ca                	sd	s2,64(sp)
 4de:	fc4e                	sd	s3,56(sp)
 4e0:	f852                	sd	s4,48(sp)
 4e2:	f456                	sd	s5,40(sp)
 4e4:	f05a                	sd	s6,32(sp)
 4e6:	ec5e                	sd	s7,24(sp)
 4e8:	1080                	addi	s0,sp,96
 4ea:	8baa                	mv	s7,a0
 4ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ee:	892a                	mv	s2,a0
 4f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4f2:	4aa9                	li	s5,10
 4f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4f6:	89a6                	mv	s3,s1
 4f8:	2485                	addiw	s1,s1,1
 4fa:	0344d863          	bge	s1,s4,52a <gets+0x56>
    cc = read(0, &c, 1);
 4fe:	4605                	li	a2,1
 500:	faf40593          	addi	a1,s0,-81
 504:	4501                	li	a0,0
 506:	00000097          	auipc	ra,0x0
 50a:	19a080e7          	jalr	410(ra) # 6a0 <read>
    if(cc < 1)
 50e:	00a05e63          	blez	a0,52a <gets+0x56>
    buf[i++] = c;
 512:	faf44783          	lbu	a5,-81(s0)
 516:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 51a:	01578763          	beq	a5,s5,528 <gets+0x54>
 51e:	0905                	addi	s2,s2,1
 520:	fd679be3          	bne	a5,s6,4f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 524:	89a6                	mv	s3,s1
 526:	a011                	j	52a <gets+0x56>
 528:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 52a:	99de                	add	s3,s3,s7
 52c:	00098023          	sb	zero,0(s3)
  return buf;
}
 530:	855e                	mv	a0,s7
 532:	60e6                	ld	ra,88(sp)
 534:	6446                	ld	s0,80(sp)
 536:	64a6                	ld	s1,72(sp)
 538:	6906                	ld	s2,64(sp)
 53a:	79e2                	ld	s3,56(sp)
 53c:	7a42                	ld	s4,48(sp)
 53e:	7aa2                	ld	s5,40(sp)
 540:	7b02                	ld	s6,32(sp)
 542:	6be2                	ld	s7,24(sp)
 544:	6125                	addi	sp,sp,96
 546:	8082                	ret

0000000000000548 <stat>:

int
stat(const char *n, struct stat *st)
{
 548:	1101                	addi	sp,sp,-32
 54a:	ec06                	sd	ra,24(sp)
 54c:	e822                	sd	s0,16(sp)
 54e:	e426                	sd	s1,8(sp)
 550:	e04a                	sd	s2,0(sp)
 552:	1000                	addi	s0,sp,32
 554:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 556:	4581                	li	a1,0
 558:	00000097          	auipc	ra,0x0
 55c:	170080e7          	jalr	368(ra) # 6c8 <open>
  if(fd < 0)
 560:	02054563          	bltz	a0,58a <stat+0x42>
 564:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 566:	85ca                	mv	a1,s2
 568:	00000097          	auipc	ra,0x0
 56c:	178080e7          	jalr	376(ra) # 6e0 <fstat>
 570:	892a                	mv	s2,a0
  close(fd);
 572:	8526                	mv	a0,s1
 574:	00000097          	auipc	ra,0x0
 578:	13c080e7          	jalr	316(ra) # 6b0 <close>
  return r;
}
 57c:	854a                	mv	a0,s2
 57e:	60e2                	ld	ra,24(sp)
 580:	6442                	ld	s0,16(sp)
 582:	64a2                	ld	s1,8(sp)
 584:	6902                	ld	s2,0(sp)
 586:	6105                	addi	sp,sp,32
 588:	8082                	ret
    return -1;
 58a:	597d                	li	s2,-1
 58c:	bfc5                	j	57c <stat+0x34>

000000000000058e <atoi>:

int
atoi(const char *s)
{
 58e:	1141                	addi	sp,sp,-16
 590:	e422                	sd	s0,8(sp)
 592:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 594:	00054683          	lbu	a3,0(a0)
 598:	fd06879b          	addiw	a5,a3,-48
 59c:	0ff7f793          	zext.b	a5,a5
 5a0:	4625                	li	a2,9
 5a2:	02f66863          	bltu	a2,a5,5d2 <atoi+0x44>
 5a6:	872a                	mv	a4,a0
  n = 0;
 5a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5aa:	0705                	addi	a4,a4,1
 5ac:	0025179b          	slliw	a5,a0,0x2
 5b0:	9fa9                	addw	a5,a5,a0
 5b2:	0017979b          	slliw	a5,a5,0x1
 5b6:	9fb5                	addw	a5,a5,a3
 5b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5bc:	00074683          	lbu	a3,0(a4)
 5c0:	fd06879b          	addiw	a5,a3,-48
 5c4:	0ff7f793          	zext.b	a5,a5
 5c8:	fef671e3          	bgeu	a2,a5,5aa <atoi+0x1c>
  return n;
}
 5cc:	6422                	ld	s0,8(sp)
 5ce:	0141                	addi	sp,sp,16
 5d0:	8082                	ret
  n = 0;
 5d2:	4501                	li	a0,0
 5d4:	bfe5                	j	5cc <atoi+0x3e>

00000000000005d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5d6:	1141                	addi	sp,sp,-16
 5d8:	e422                	sd	s0,8(sp)
 5da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5dc:	02b57463          	bgeu	a0,a1,604 <memmove+0x2e>
    while(n-- > 0)
 5e0:	00c05f63          	blez	a2,5fe <memmove+0x28>
 5e4:	1602                	slli	a2,a2,0x20
 5e6:	9201                	srli	a2,a2,0x20
 5e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 5ee:	0585                	addi	a1,a1,1
 5f0:	0705                	addi	a4,a4,1
 5f2:	fff5c683          	lbu	a3,-1(a1)
 5f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5fa:	fee79ae3          	bne	a5,a4,5ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5fe:	6422                	ld	s0,8(sp)
 600:	0141                	addi	sp,sp,16
 602:	8082                	ret
    dst += n;
 604:	00c50733          	add	a4,a0,a2
    src += n;
 608:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 60a:	fec05ae3          	blez	a2,5fe <memmove+0x28>
 60e:	fff6079b          	addiw	a5,a2,-1
 612:	1782                	slli	a5,a5,0x20
 614:	9381                	srli	a5,a5,0x20
 616:	fff7c793          	not	a5,a5
 61a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 61c:	15fd                	addi	a1,a1,-1
 61e:	177d                	addi	a4,a4,-1
 620:	0005c683          	lbu	a3,0(a1)
 624:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 628:	fee79ae3          	bne	a5,a4,61c <memmove+0x46>
 62c:	bfc9                	j	5fe <memmove+0x28>

000000000000062e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e422                	sd	s0,8(sp)
 632:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 634:	ca05                	beqz	a2,664 <memcmp+0x36>
 636:	fff6069b          	addiw	a3,a2,-1
 63a:	1682                	slli	a3,a3,0x20
 63c:	9281                	srli	a3,a3,0x20
 63e:	0685                	addi	a3,a3,1
 640:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 642:	00054783          	lbu	a5,0(a0)
 646:	0005c703          	lbu	a4,0(a1)
 64a:	00e79863          	bne	a5,a4,65a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 64e:	0505                	addi	a0,a0,1
    p2++;
 650:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 652:	fed518e3          	bne	a0,a3,642 <memcmp+0x14>
  }
  return 0;
 656:	4501                	li	a0,0
 658:	a019                	j	65e <memcmp+0x30>
      return *p1 - *p2;
 65a:	40e7853b          	subw	a0,a5,a4
}
 65e:	6422                	ld	s0,8(sp)
 660:	0141                	addi	sp,sp,16
 662:	8082                	ret
  return 0;
 664:	4501                	li	a0,0
 666:	bfe5                	j	65e <memcmp+0x30>

0000000000000668 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 668:	1141                	addi	sp,sp,-16
 66a:	e406                	sd	ra,8(sp)
 66c:	e022                	sd	s0,0(sp)
 66e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 670:	00000097          	auipc	ra,0x0
 674:	f66080e7          	jalr	-154(ra) # 5d6 <memmove>
}
 678:	60a2                	ld	ra,8(sp)
 67a:	6402                	ld	s0,0(sp)
 67c:	0141                	addi	sp,sp,16
 67e:	8082                	ret

0000000000000680 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 680:	4885                	li	a7,1
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <exit>:
.global exit
exit:
 li a7, SYS_exit
 688:	4889                	li	a7,2
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <wait>:
.global wait
wait:
 li a7, SYS_wait
 690:	488d                	li	a7,3
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 698:	4891                	li	a7,4
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <read>:
.global read
read:
 li a7, SYS_read
 6a0:	4895                	li	a7,5
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <write>:
.global write
write:
 li a7, SYS_write
 6a8:	48c1                	li	a7,16
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <close>:
.global close
close:
 li a7, SYS_close
 6b0:	48d5                	li	a7,21
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6b8:	4899                	li	a7,6
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6c0:	489d                	li	a7,7
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <open>:
.global open
open:
 li a7, SYS_open
 6c8:	48bd                	li	a7,15
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6d0:	48c5                	li	a7,17
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6d8:	48c9                	li	a7,18
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6e0:	48a1                	li	a7,8
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <link>:
.global link
link:
 li a7, SYS_link
 6e8:	48cd                	li	a7,19
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6f0:	48d1                	li	a7,20
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6f8:	48a5                	li	a7,9
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <dup>:
.global dup
dup:
 li a7, SYS_dup
 700:	48a9                	li	a7,10
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 708:	48ad                	li	a7,11
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 710:	48b1                	li	a7,12
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 718:	48b5                	li	a7,13
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 720:	48b9                	li	a7,14
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 728:	48d9                	li	a7,22
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 730:	48dd                	li	a7,23
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 738:	48e1                	li	a7,24
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 740:	48e5                	li	a7,25
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 748:	1101                	addi	sp,sp,-32
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 754:	4605                	li	a2,1
 756:	fef40593          	addi	a1,s0,-17
 75a:	00000097          	auipc	ra,0x0
 75e:	f4e080e7          	jalr	-178(ra) # 6a8 <write>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6105                	addi	sp,sp,32
 768:	8082                	ret

000000000000076a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 76a:	7139                	addi	sp,sp,-64
 76c:	fc06                	sd	ra,56(sp)
 76e:	f822                	sd	s0,48(sp)
 770:	f426                	sd	s1,40(sp)
 772:	f04a                	sd	s2,32(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	0080                	addi	s0,sp,64
 778:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 77a:	c299                	beqz	a3,780 <printint+0x16>
 77c:	0805c963          	bltz	a1,80e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 780:	2581                	sext.w	a1,a1
  neg = 0;
 782:	4881                	li	a7,0
 784:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 788:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 78a:	2601                	sext.w	a2,a2
 78c:	00001517          	auipc	a0,0x1
 790:	88c50513          	addi	a0,a0,-1908 # 1018 <digits>
 794:	883a                	mv	a6,a4
 796:	2705                	addiw	a4,a4,1
 798:	02c5f7bb          	remuw	a5,a1,a2
 79c:	1782                	slli	a5,a5,0x20
 79e:	9381                	srli	a5,a5,0x20
 7a0:	97aa                	add	a5,a5,a0
 7a2:	0007c783          	lbu	a5,0(a5)
 7a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7aa:	0005879b          	sext.w	a5,a1
 7ae:	02c5d5bb          	divuw	a1,a1,a2
 7b2:	0685                	addi	a3,a3,1
 7b4:	fec7f0e3          	bgeu	a5,a2,794 <printint+0x2a>
  if(neg)
 7b8:	00088c63          	beqz	a7,7d0 <printint+0x66>
    buf[i++] = '-';
 7bc:	fd070793          	addi	a5,a4,-48
 7c0:	00878733          	add	a4,a5,s0
 7c4:	02d00793          	li	a5,45
 7c8:	fef70823          	sb	a5,-16(a4)
 7cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7d0:	02e05863          	blez	a4,800 <printint+0x96>
 7d4:	fc040793          	addi	a5,s0,-64
 7d8:	00e78933          	add	s2,a5,a4
 7dc:	fff78993          	addi	s3,a5,-1
 7e0:	99ba                	add	s3,s3,a4
 7e2:	377d                	addiw	a4,a4,-1
 7e4:	1702                	slli	a4,a4,0x20
 7e6:	9301                	srli	a4,a4,0x20
 7e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7ec:	fff94583          	lbu	a1,-1(s2)
 7f0:	8526                	mv	a0,s1
 7f2:	00000097          	auipc	ra,0x0
 7f6:	f56080e7          	jalr	-170(ra) # 748 <putc>
  while(--i >= 0)
 7fa:	197d                	addi	s2,s2,-1
 7fc:	ff3918e3          	bne	s2,s3,7ec <printint+0x82>
}
 800:	70e2                	ld	ra,56(sp)
 802:	7442                	ld	s0,48(sp)
 804:	74a2                	ld	s1,40(sp)
 806:	7902                	ld	s2,32(sp)
 808:	69e2                	ld	s3,24(sp)
 80a:	6121                	addi	sp,sp,64
 80c:	8082                	ret
    x = -xx;
 80e:	40b005bb          	negw	a1,a1
    neg = 1;
 812:	4885                	li	a7,1
    x = -xx;
 814:	bf85                	j	784 <printint+0x1a>

0000000000000816 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 816:	7119                	addi	sp,sp,-128
 818:	fc86                	sd	ra,120(sp)
 81a:	f8a2                	sd	s0,112(sp)
 81c:	f4a6                	sd	s1,104(sp)
 81e:	f0ca                	sd	s2,96(sp)
 820:	ecce                	sd	s3,88(sp)
 822:	e8d2                	sd	s4,80(sp)
 824:	e4d6                	sd	s5,72(sp)
 826:	e0da                	sd	s6,64(sp)
 828:	fc5e                	sd	s7,56(sp)
 82a:	f862                	sd	s8,48(sp)
 82c:	f466                	sd	s9,40(sp)
 82e:	f06a                	sd	s10,32(sp)
 830:	ec6e                	sd	s11,24(sp)
 832:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 834:	0005c903          	lbu	s2,0(a1)
 838:	18090f63          	beqz	s2,9d6 <vprintf+0x1c0>
 83c:	8aaa                	mv	s5,a0
 83e:	8b32                	mv	s6,a2
 840:	00158493          	addi	s1,a1,1
  state = 0;
 844:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 846:	02500a13          	li	s4,37
 84a:	4c55                	li	s8,21
 84c:	00000c97          	auipc	s9,0x0
 850:	774c8c93          	addi	s9,s9,1908 # fc0 <ithread_join+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 854:	02800d93          	li	s11,40
  putc(fd, 'x');
 858:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 85a:	00000b97          	auipc	s7,0x0
 85e:	7beb8b93          	addi	s7,s7,1982 # 1018 <digits>
 862:	a839                	j	880 <vprintf+0x6a>
        putc(fd, c);
 864:	85ca                	mv	a1,s2
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	ee0080e7          	jalr	-288(ra) # 748 <putc>
 870:	a019                	j	876 <vprintf+0x60>
    } else if(state == '%'){
 872:	01498d63          	beq	s3,s4,88c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 876:	0485                	addi	s1,s1,1
 878:	fff4c903          	lbu	s2,-1(s1)
 87c:	14090d63          	beqz	s2,9d6 <vprintf+0x1c0>
    if(state == 0){
 880:	fe0999e3          	bnez	s3,872 <vprintf+0x5c>
      if(c == '%'){
 884:	ff4910e3          	bne	s2,s4,864 <vprintf+0x4e>
        state = '%';
 888:	89d2                	mv	s3,s4
 88a:	b7f5                	j	876 <vprintf+0x60>
      if(c == 'd'){
 88c:	11490c63          	beq	s2,s4,9a4 <vprintf+0x18e>
 890:	f9d9079b          	addiw	a5,s2,-99
 894:	0ff7f793          	zext.b	a5,a5
 898:	10fc6e63          	bltu	s8,a5,9b4 <vprintf+0x19e>
 89c:	f9d9079b          	addiw	a5,s2,-99
 8a0:	0ff7f713          	zext.b	a4,a5
 8a4:	10ec6863          	bltu	s8,a4,9b4 <vprintf+0x19e>
 8a8:	00271793          	slli	a5,a4,0x2
 8ac:	97e6                	add	a5,a5,s9
 8ae:	439c                	lw	a5,0(a5)
 8b0:	97e6                	add	a5,a5,s9
 8b2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8b4:	008b0913          	addi	s2,s6,8
 8b8:	4685                	li	a3,1
 8ba:	4629                	li	a2,10
 8bc:	000b2583          	lw	a1,0(s6)
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	ea8080e7          	jalr	-344(ra) # 76a <printint>
 8ca:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b765                	j	876 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d0:	008b0913          	addi	s2,s6,8
 8d4:	4681                	li	a3,0
 8d6:	4629                	li	a2,10
 8d8:	000b2583          	lw	a1,0(s6)
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	e8c080e7          	jalr	-372(ra) # 76a <printint>
 8e6:	8b4a                	mv	s6,s2
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	b771                	j	876 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8ec:	008b0913          	addi	s2,s6,8
 8f0:	4681                	li	a3,0
 8f2:	866a                	mv	a2,s10
 8f4:	000b2583          	lw	a1,0(s6)
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	e70080e7          	jalr	-400(ra) # 76a <printint>
 902:	8b4a                	mv	s6,s2
      state = 0;
 904:	4981                	li	s3,0
 906:	bf85                	j	876 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 908:	008b0793          	addi	a5,s6,8
 90c:	f8f43423          	sd	a5,-120(s0)
 910:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 914:	03000593          	li	a1,48
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	e2e080e7          	jalr	-466(ra) # 748 <putc>
  putc(fd, 'x');
 922:	07800593          	li	a1,120
 926:	8556                	mv	a0,s5
 928:	00000097          	auipc	ra,0x0
 92c:	e20080e7          	jalr	-480(ra) # 748 <putc>
 930:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 932:	03c9d793          	srli	a5,s3,0x3c
 936:	97de                	add	a5,a5,s7
 938:	0007c583          	lbu	a1,0(a5)
 93c:	8556                	mv	a0,s5
 93e:	00000097          	auipc	ra,0x0
 942:	e0a080e7          	jalr	-502(ra) # 748 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 946:	0992                	slli	s3,s3,0x4
 948:	397d                	addiw	s2,s2,-1
 94a:	fe0914e3          	bnez	s2,932 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 94e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 952:	4981                	li	s3,0
 954:	b70d                	j	876 <vprintf+0x60>
        s = va_arg(ap, char*);
 956:	008b0913          	addi	s2,s6,8
 95a:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 95e:	02098163          	beqz	s3,980 <vprintf+0x16a>
        while(*s != 0){
 962:	0009c583          	lbu	a1,0(s3)
 966:	c5ad                	beqz	a1,9d0 <vprintf+0x1ba>
          putc(fd, *s);
 968:	8556                	mv	a0,s5
 96a:	00000097          	auipc	ra,0x0
 96e:	dde080e7          	jalr	-546(ra) # 748 <putc>
          s++;
 972:	0985                	addi	s3,s3,1
        while(*s != 0){
 974:	0009c583          	lbu	a1,0(s3)
 978:	f9e5                	bnez	a1,968 <vprintf+0x152>
        s = va_arg(ap, char*);
 97a:	8b4a                	mv	s6,s2
      state = 0;
 97c:	4981                	li	s3,0
 97e:	bde5                	j	876 <vprintf+0x60>
          s = "(null)";
 980:	00000997          	auipc	s3,0x0
 984:	63898993          	addi	s3,s3,1592 # fb8 <ithread_join+0x1fa>
        while(*s != 0){
 988:	85ee                	mv	a1,s11
 98a:	bff9                	j	968 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 98c:	008b0913          	addi	s2,s6,8
 990:	000b4583          	lbu	a1,0(s6)
 994:	8556                	mv	a0,s5
 996:	00000097          	auipc	ra,0x0
 99a:	db2080e7          	jalr	-590(ra) # 748 <putc>
 99e:	8b4a                	mv	s6,s2
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	bdd1                	j	876 <vprintf+0x60>
        putc(fd, c);
 9a4:	85d2                	mv	a1,s4
 9a6:	8556                	mv	a0,s5
 9a8:	00000097          	auipc	ra,0x0
 9ac:	da0080e7          	jalr	-608(ra) # 748 <putc>
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	b5d1                	j	876 <vprintf+0x60>
        putc(fd, '%');
 9b4:	85d2                	mv	a1,s4
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	d90080e7          	jalr	-624(ra) # 748 <putc>
        putc(fd, c);
 9c0:	85ca                	mv	a1,s2
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	d84080e7          	jalr	-636(ra) # 748 <putc>
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	b565                	j	876 <vprintf+0x60>
        s = va_arg(ap, char*);
 9d0:	8b4a                	mv	s6,s2
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	b54d                	j	876 <vprintf+0x60>
    }
  }
}
 9d6:	70e6                	ld	ra,120(sp)
 9d8:	7446                	ld	s0,112(sp)
 9da:	74a6                	ld	s1,104(sp)
 9dc:	7906                	ld	s2,96(sp)
 9de:	69e6                	ld	s3,88(sp)
 9e0:	6a46                	ld	s4,80(sp)
 9e2:	6aa6                	ld	s5,72(sp)
 9e4:	6b06                	ld	s6,64(sp)
 9e6:	7be2                	ld	s7,56(sp)
 9e8:	7c42                	ld	s8,48(sp)
 9ea:	7ca2                	ld	s9,40(sp)
 9ec:	7d02                	ld	s10,32(sp)
 9ee:	6de2                	ld	s11,24(sp)
 9f0:	6109                	addi	sp,sp,128
 9f2:	8082                	ret

00000000000009f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9f4:	715d                	addi	sp,sp,-80
 9f6:	ec06                	sd	ra,24(sp)
 9f8:	e822                	sd	s0,16(sp)
 9fa:	1000                	addi	s0,sp,32
 9fc:	e010                	sd	a2,0(s0)
 9fe:	e414                	sd	a3,8(s0)
 a00:	e818                	sd	a4,16(s0)
 a02:	ec1c                	sd	a5,24(s0)
 a04:	03043023          	sd	a6,32(s0)
 a08:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a0c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a10:	8622                	mv	a2,s0
 a12:	00000097          	auipc	ra,0x0
 a16:	e04080e7          	jalr	-508(ra) # 816 <vprintf>
}
 a1a:	60e2                	ld	ra,24(sp)
 a1c:	6442                	ld	s0,16(sp)
 a1e:	6161                	addi	sp,sp,80
 a20:	8082                	ret

0000000000000a22 <printf>:

void
printf(const char *fmt, ...)
{
 a22:	711d                	addi	sp,sp,-96
 a24:	ec06                	sd	ra,24(sp)
 a26:	e822                	sd	s0,16(sp)
 a28:	1000                	addi	s0,sp,32
 a2a:	e40c                	sd	a1,8(s0)
 a2c:	e810                	sd	a2,16(s0)
 a2e:	ec14                	sd	a3,24(s0)
 a30:	f018                	sd	a4,32(s0)
 a32:	f41c                	sd	a5,40(s0)
 a34:	03043823          	sd	a6,48(s0)
 a38:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a3c:	00840613          	addi	a2,s0,8
 a40:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a44:	85aa                	mv	a1,a0
 a46:	4505                	li	a0,1
 a48:	00000097          	auipc	ra,0x0
 a4c:	dce080e7          	jalr	-562(ra) # 816 <vprintf>
}
 a50:	60e2                	ld	ra,24(sp)
 a52:	6442                	ld	s0,16(sp)
 a54:	6125                	addi	sp,sp,96
 a56:	8082                	ret

0000000000000a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a58:	1141                	addi	sp,sp,-16
 a5a:	e422                	sd	s0,8(sp)
 a5c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a5e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a62:	00001797          	auipc	a5,0x1
 a66:	5be7b783          	ld	a5,1470(a5) # 2020 <freep>
 a6a:	a02d                	j	a94 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a6c:	4618                	lw	a4,8(a2)
 a6e:	9f2d                	addw	a4,a4,a1
 a70:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	6310                	ld	a2,0(a4)
 a78:	a83d                	j	ab6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a7a:	ff852703          	lw	a4,-8(a0)
 a7e:	9f31                	addw	a4,a4,a2
 a80:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a82:	ff053683          	ld	a3,-16(a0)
 a86:	a091                	j	aca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a88:	6398                	ld	a4,0(a5)
 a8a:	00e7e463          	bltu	a5,a4,a92 <free+0x3a>
 a8e:	00e6ea63          	bltu	a3,a4,aa2 <free+0x4a>
{
 a92:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a94:	fed7fae3          	bgeu	a5,a3,a88 <free+0x30>
 a98:	6398                	ld	a4,0(a5)
 a9a:	00e6e463          	bltu	a3,a4,aa2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9e:	fee7eae3          	bltu	a5,a4,a92 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 aa2:	ff852583          	lw	a1,-8(a0)
 aa6:	6390                	ld	a2,0(a5)
 aa8:	02059813          	slli	a6,a1,0x20
 aac:	01c85713          	srli	a4,a6,0x1c
 ab0:	9736                	add	a4,a4,a3
 ab2:	fae60de3          	beq	a2,a4,a6c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ab6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aba:	4790                	lw	a2,8(a5)
 abc:	02061593          	slli	a1,a2,0x20
 ac0:	01c5d713          	srli	a4,a1,0x1c
 ac4:	973e                	add	a4,a4,a5
 ac6:	fae68ae3          	beq	a3,a4,a7a <free+0x22>
    p->s.ptr = bp->s.ptr;
 aca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 acc:	00001717          	auipc	a4,0x1
 ad0:	54f73a23          	sd	a5,1364(a4) # 2020 <freep>
}
 ad4:	6422                	ld	s0,8(sp)
 ad6:	0141                	addi	sp,sp,16
 ad8:	8082                	ret

0000000000000ada <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ada:	7139                	addi	sp,sp,-64
 adc:	fc06                	sd	ra,56(sp)
 ade:	f822                	sd	s0,48(sp)
 ae0:	f426                	sd	s1,40(sp)
 ae2:	f04a                	sd	s2,32(sp)
 ae4:	ec4e                	sd	s3,24(sp)
 ae6:	e852                	sd	s4,16(sp)
 ae8:	e456                	sd	s5,8(sp)
 aea:	e05a                	sd	s6,0(sp)
 aec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aee:	02051493          	slli	s1,a0,0x20
 af2:	9081                	srli	s1,s1,0x20
 af4:	04bd                	addi	s1,s1,15
 af6:	8091                	srli	s1,s1,0x4
 af8:	0014899b          	addiw	s3,s1,1
 afc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 afe:	00001517          	auipc	a0,0x1
 b02:	52253503          	ld	a0,1314(a0) # 2020 <freep>
 b06:	c515                	beqz	a0,b32 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b0a:	4798                	lw	a4,8(a5)
 b0c:	02977f63          	bgeu	a4,s1,b4a <malloc+0x70>
 b10:	8a4e                	mv	s4,s3
 b12:	0009871b          	sext.w	a4,s3
 b16:	6685                	lui	a3,0x1
 b18:	00d77363          	bgeu	a4,a3,b1e <malloc+0x44>
 b1c:	6a05                	lui	s4,0x1
 b1e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b22:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b26:	00001917          	auipc	s2,0x1
 b2a:	4fa90913          	addi	s2,s2,1274 # 2020 <freep>
  if(p == (char*)-1)
 b2e:	5afd                	li	s5,-1
 b30:	a895                	j	ba4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b32:	00001797          	auipc	a5,0x1
 b36:	50e78793          	addi	a5,a5,1294 # 2040 <base>
 b3a:	00001717          	auipc	a4,0x1
 b3e:	4ef73323          	sd	a5,1254(a4) # 2020 <freep>
 b42:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b48:	b7e1                	j	b10 <malloc+0x36>
      if(p->s.size == nunits)
 b4a:	02e48c63          	beq	s1,a4,b82 <malloc+0xa8>
        p->s.size -= nunits;
 b4e:	4137073b          	subw	a4,a4,s3
 b52:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b54:	02071693          	slli	a3,a4,0x20
 b58:	01c6d713          	srli	a4,a3,0x1c
 b5c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b5e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b62:	00001717          	auipc	a4,0x1
 b66:	4aa73f23          	sd	a0,1214(a4) # 2020 <freep>
      return (void*)(p + 1);
 b6a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b6e:	70e2                	ld	ra,56(sp)
 b70:	7442                	ld	s0,48(sp)
 b72:	74a2                	ld	s1,40(sp)
 b74:	7902                	ld	s2,32(sp)
 b76:	69e2                	ld	s3,24(sp)
 b78:	6a42                	ld	s4,16(sp)
 b7a:	6aa2                	ld	s5,8(sp)
 b7c:	6b02                	ld	s6,0(sp)
 b7e:	6121                	addi	sp,sp,64
 b80:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b82:	6398                	ld	a4,0(a5)
 b84:	e118                	sd	a4,0(a0)
 b86:	bff1                	j	b62 <malloc+0x88>
  hp->s.size = nu;
 b88:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b8c:	0541                	addi	a0,a0,16
 b8e:	00000097          	auipc	ra,0x0
 b92:	eca080e7          	jalr	-310(ra) # a58 <free>
  return freep;
 b96:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b9a:	d971                	beqz	a0,b6e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b9e:	4798                	lw	a4,8(a5)
 ba0:	fa9775e3          	bgeu	a4,s1,b4a <malloc+0x70>
    if(p == freep)
 ba4:	00093703          	ld	a4,0(s2)
 ba8:	853e                	mv	a0,a5
 baa:	fef719e3          	bne	a4,a5,b9c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bae:	8552                	mv	a0,s4
 bb0:	00000097          	auipc	ra,0x0
 bb4:	b60080e7          	jalr	-1184(ra) # 710 <sbrk>
  if(p == (char*)-1)
 bb8:	fd5518e3          	bne	a0,s5,b88 <malloc+0xae>
        return 0;
 bbc:	4501                	li	a0,0
 bbe:	bf45                	j	b6e <malloc+0x94>

0000000000000bc0 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 bc0:	1141                	addi	sp,sp,-16
 bc2:	e406                	sd	ra,8(sp)
 bc4:	e022                	sd	s0,0(sp)
 bc6:	0800                	addi	s0,sp,16
  thread_exit(status);
 bc8:	00000097          	auipc	ra,0x0
 bcc:	b78080e7          	jalr	-1160(ra) # 740 <thread_exit>
}
 bd0:	60a2                	ld	ra,8(sp)
 bd2:	6402                	ld	s0,0(sp)
 bd4:	0141                	addi	sp,sp,16
 bd6:	8082                	ret

0000000000000bd8 <free_stacks>:
int free_stacks() {
 bd8:	7179                	addi	sp,sp,-48
 bda:	f406                	sd	ra,40(sp)
 bdc:	f022                	sd	s0,32(sp)
 bde:	ec26                	sd	s1,24(sp)
 be0:	e84a                	sd	s2,16(sp)
 be2:	e44e                	sd	s3,8(sp)
 be4:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 be6:	00001797          	auipc	a5,0x1
 bea:	44a7a783          	lw	a5,1098(a5) # 2030 <num_threads>
 bee:	02f05c63          	blez	a5,c26 <free_stacks+0x4e>
 bf2:	4481                	li	s1,0
    free(stacks[i]);
 bf4:	00001997          	auipc	s3,0x1
 bf8:	43498993          	addi	s3,s3,1076 # 2028 <stacks>
  for (int i = 0; i < num_threads; i++) {
 bfc:	00001917          	auipc	s2,0x1
 c00:	43490913          	addi	s2,s2,1076 # 2030 <num_threads>
    free(stacks[i]);
 c04:	0009b783          	ld	a5,0(s3)
 c08:	00349713          	slli	a4,s1,0x3
 c0c:	97ba                	add	a5,a5,a4
 c0e:	6388                	ld	a0,0(a5)
 c10:	00000097          	auipc	ra,0x0
 c14:	e48080e7          	jalr	-440(ra) # a58 <free>
  for (int i = 0; i < num_threads; i++) {
 c18:	0485                	addi	s1,s1,1
 c1a:	00092703          	lw	a4,0(s2)
 c1e:	0004879b          	sext.w	a5,s1
 c22:	fee7c1e3          	blt	a5,a4,c04 <free_stacks+0x2c>
  free(stacks);
 c26:	00001497          	auipc	s1,0x1
 c2a:	40248493          	addi	s1,s1,1026 # 2028 <stacks>
 c2e:	6088                	ld	a0,0(s1)
 c30:	00000097          	auipc	ra,0x0
 c34:	e28080e7          	jalr	-472(ra) # a58 <free>
  stacks = 0;
 c38:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 c3c:	00001797          	auipc	a5,0x1
 c40:	3e07aa23          	sw	zero,1012(a5) # 2030 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 c44:	47a1                	li	a5,8
 c46:	00001717          	auipc	a4,0x1
 c4a:	3cf72523          	sw	a5,970(a4) # 2010 <max_stacks>
  threads_done = 0;
 c4e:	00001797          	auipc	a5,0x1
 c52:	3e07a323          	sw	zero,998(a5) # 2034 <threads_done>
}
 c56:	4501                	li	a0,0
 c58:	70a2                	ld	ra,40(sp)
 c5a:	7402                	ld	s0,32(sp)
 c5c:	64e2                	ld	s1,24(sp)
 c5e:	6942                	ld	s2,16(sp)
 c60:	69a2                	ld	s3,8(sp)
 c62:	6145                	addi	sp,sp,48
 c64:	8082                	ret

0000000000000c66 <expand_num_threads>:
int expand_num_threads() {
 c66:	1101                	addi	sp,sp,-32
 c68:	ec06                	sd	ra,24(sp)
 c6a:	e822                	sd	s0,16(sp)
 c6c:	e426                	sd	s1,8(sp)
 c6e:	e04a                	sd	s2,0(sp)
 c70:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 c72:	00001797          	auipc	a5,0x1
 c76:	39e78793          	addi	a5,a5,926 # 2010 <max_stacks>
 c7a:	4388                	lw	a0,0(a5)
 c7c:	0015151b          	slliw	a0,a0,0x1
 c80:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 c82:	0035151b          	slliw	a0,a0,0x3
 c86:	00000097          	auipc	ra,0x0
 c8a:	e54080e7          	jalr	-428(ra) # ada <malloc>
 c8e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 c90:	00001617          	auipc	a2,0x1
 c94:	3a062603          	lw	a2,928(a2) # 2030 <num_threads>
 c98:	00001497          	auipc	s1,0x1
 c9c:	39048493          	addi	s1,s1,912 # 2028 <stacks>
 ca0:	0036161b          	slliw	a2,a2,0x3
 ca4:	608c                	ld	a1,0(s1)
 ca6:	00000097          	auipc	ra,0x0
 caa:	930080e7          	jalr	-1744(ra) # 5d6 <memmove>
  free(stacks);
 cae:	6088                	ld	a0,0(s1)
 cb0:	00000097          	auipc	ra,0x0
 cb4:	da8080e7          	jalr	-600(ra) # a58 <free>
  stacks = new_stacks;
 cb8:	0124b023          	sd	s2,0(s1)
}
 cbc:	4501                	li	a0,0
 cbe:	60e2                	ld	ra,24(sp)
 cc0:	6442                	ld	s0,16(sp)
 cc2:	64a2                	ld	s1,8(sp)
 cc4:	6902                	ld	s2,0(sp)
 cc6:	6105                	addi	sp,sp,32
 cc8:	8082                	ret

0000000000000cca <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 cca:	7179                	addi	sp,sp,-48
 ccc:	f406                	sd	ra,40(sp)
 cce:	f022                	sd	s0,32(sp)
 cd0:	ec26                	sd	s1,24(sp)
 cd2:	e84a                	sd	s2,16(sp)
 cd4:	e44e                	sd	s3,8(sp)
 cd6:	1800                	addi	s0,sp,48
 cd8:	892a                	mv	s2,a0
 cda:	89ae                	mv	s3,a1
  if (stacks == 0) {
 cdc:	00001797          	auipc	a5,0x1
 ce0:	34c7b783          	ld	a5,844(a5) # 2028 <stacks>
 ce4:	c3d1                	beqz	a5,d68 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ce6:	00001797          	auipc	a5,0x1
 cea:	32a7a783          	lw	a5,810(a5) # 2010 <max_stacks>
 cee:	00001717          	auipc	a4,0x1
 cf2:	34272703          	lw	a4,834(a4) # 2030 <num_threads>
 cf6:	00f71a63          	bne	a4,a5,d0a <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
 cfa:	04000713          	li	a4,64
 cfe:	08e78463          	beq	a5,a4,d86 <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 d02:	00000097          	auipc	ra,0x0
 d06:	f64080e7          	jalr	-156(ra) # c66 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 d0a:	6505                	lui	a0,0x1
 d0c:	00000097          	auipc	ra,0x0
 d10:	dce080e7          	jalr	-562(ra) # ada <malloc>
 d14:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 d16:	00001717          	auipc	a4,0x1
 d1a:	31a72703          	lw	a4,794(a4) # 2030 <num_threads>
 d1e:	070e                	slli	a4,a4,0x3
 d20:	00001797          	auipc	a5,0x1
 d24:	3087b783          	ld	a5,776(a5) # 2028 <stacks>
 d28:	97ba                	add	a5,a5,a4
 d2a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 d2c:	00000697          	auipc	a3,0x0
 d30:	e9468693          	addi	a3,a3,-364 # bc0 <ithread_exit>
 d34:	862a                	mv	a2,a0
 d36:	85ce                	mv	a1,s3
 d38:	854a                	mv	a0,s2
 d3a:	00000097          	auipc	ra,0x0
 d3e:	9f6080e7          	jalr	-1546(ra) # 730 <create_thread>
 d42:	892a                	mv	s2,a0
  if (res != -1) {
 d44:	57fd                	li	a5,-1
 d46:	04f50a63          	beq	a0,a5,d9a <ithread_create+0xd0>
    num_threads++;
 d4a:	00001717          	auipc	a4,0x1
 d4e:	2e670713          	addi	a4,a4,742 # 2030 <num_threads>
 d52:	431c                	lw	a5,0(a4)
 d54:	2785                	addiw	a5,a5,1
 d56:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 d58:	854a                	mv	a0,s2
 d5a:	70a2                	ld	ra,40(sp)
 d5c:	7402                	ld	s0,32(sp)
 d5e:	64e2                	ld	s1,24(sp)
 d60:	6942                	ld	s2,16(sp)
 d62:	69a2                	ld	s3,8(sp)
 d64:	6145                	addi	sp,sp,48
 d66:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 d68:	00001517          	auipc	a0,0x1
 d6c:	2a852503          	lw	a0,680(a0) # 2010 <max_stacks>
 d70:	0035151b          	slliw	a0,a0,0x3
 d74:	00000097          	auipc	ra,0x0
 d78:	d66080e7          	jalr	-666(ra) # ada <malloc>
 d7c:	00001797          	auipc	a5,0x1
 d80:	2aa7b623          	sd	a0,684(a5) # 2028 <stacks>
 d84:	b78d                	j	ce6 <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
 d86:	00000517          	auipc	a0,0x0
 d8a:	2aa50513          	addi	a0,a0,682 # 1030 <digits+0x18>
 d8e:	00000097          	auipc	ra,0x0
 d92:	c94080e7          	jalr	-876(ra) # a22 <printf>
      return -1;
 d96:	597d                	li	s2,-1
 d98:	b7c1                	j	d58 <ithread_create+0x8e>
    free(stack_ptr);
 d9a:	8526                	mv	a0,s1
 d9c:	00000097          	auipc	ra,0x0
 da0:	cbc080e7          	jalr	-836(ra) # a58 <free>
    stacks[num_threads] = 0;
 da4:	00001717          	auipc	a4,0x1
 da8:	28c72703          	lw	a4,652(a4) # 2030 <num_threads>
 dac:	070e                	slli	a4,a4,0x3
 dae:	00001797          	auipc	a5,0x1
 db2:	27a7b783          	ld	a5,634(a5) # 2028 <stacks>
 db6:	97ba                	add	a5,a5,a4
 db8:	0007b023          	sd	zero,0(a5)
 dbc:	bf71                	j	d58 <ithread_create+0x8e>

0000000000000dbe <ithread_join>:

int ithread_join(int thread_id) {
 dbe:	1101                	addi	sp,sp,-32
 dc0:	ec06                	sd	ra,24(sp)
 dc2:	e822                	sd	s0,16(sp)
 dc4:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 dc6:	fec40593          	addi	a1,s0,-20
 dca:	00000097          	auipc	ra,0x0
 dce:	96e080e7          	jalr	-1682(ra) # 738 <join_thread>
  threads_done++;
 dd2:	00001717          	auipc	a4,0x1
 dd6:	26270713          	addi	a4,a4,610 # 2034 <threads_done>
 dda:	431c                	lw	a5,0(a4)
 ddc:	2785                	addiw	a5,a5,1
 dde:	0007869b          	sext.w	a3,a5
 de2:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 de4:	00001797          	auipc	a5,0x1
 de8:	24c7a783          	lw	a5,588(a5) # 2030 <num_threads>
 dec:	00d78863          	beq	a5,a3,dfc <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 df0:	fec42503          	lw	a0,-20(s0)
 df4:	60e2                	ld	ra,24(sp)
 df6:	6442                	ld	s0,16(sp)
 df8:	6105                	addi	sp,sp,32
 dfa:	8082                	ret
    free_stacks();
 dfc:	00000097          	auipc	ra,0x0
 e00:	ddc080e7          	jalr	-548(ra) # bd8 <free_stacks>
 e04:	b7f5                	j	df0 <ithread_join+0x32>
