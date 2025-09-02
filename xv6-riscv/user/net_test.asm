
user/_net_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <udp_basic_test>:
#define CLIENT_PORT 78
#define MSG "hello over udp"

void
udp_basic_test(void)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
  int server_fd, client_fd;
  struct sockaddr_in server_addr, client_addr;
  char buf[64];

  printf("udp_basic_test...\n");
   c:	00001517          	auipc	a0,0x1
  10:	cc450513          	addi	a0,a0,-828 # cd0 <ithread_join+0x52>
  14:	00001097          	auipc	ra,0x1
  18:	8ae080e7          	jalr	-1874(ra) # 8c2 <printf>
  // if (server_fd < 0) {
  //   printf("server socket failed\n");
  //   exit(1);
  // }
  //
  memset(&server_addr, 0, sizeof(server_addr));
  1c:	4641                	li	a2,16
  1e:	4581                	li	a1,0
  20:	fd040513          	addi	a0,s0,-48
  24:	00000097          	auipc	ra,0x0
  28:	2b8080e7          	jalr	696(ra) # 2dc <memset>
  server_addr.sin_family = AF_INET;
  2c:	4509                	li	a0,2
  2e:	fca41823          	sh	a0,-48(s0)
  server_addr.sin_port = htons(SERVER_PORT);
  32:	6789                	lui	a5,0x2
  34:	04e78793          	addi	a5,a5,78 # 204e <base+0xa5e>
  38:	fcf41923          	sh	a5,-46(s0)
  server_addr.sin_addr.s_addr = htonl(0xc0a8fe74);
  3c:	74feb7b7          	lui	a5,0x74feb
  40:	8c078793          	addi	a5,a5,-1856 # 74fea8c0 <base+0x74fe92d0>
  44:	fcf42a23          	sw	a5,-44(s0)
  //   printf("server bind failed\n");
  //   exit(1);
  // }
  //
  // --- Create client socket
  client_fd = socket(AF_INET, SOCK_DGRAM, 0);
  48:	4601                	li	a2,0
  4a:	85aa                	mv	a1,a0
  4c:	00000097          	auipc	ra,0x0
  50:	572080e7          	jalr	1394(ra) # 5be <socket>
  if (client_fd < 0) {
  54:	08054b63          	bltz	a0,ea <udp_basic_test+0xea>
  58:	84aa                	mv	s1,a0
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  5a:	fc040913          	addi	s2,s0,-64
  5e:	4641                	li	a2,16
  60:	4581                	li	a1,0
  62:	854a                	mv	a0,s2
  64:	00000097          	auipc	ra,0x0
  68:	278080e7          	jalr	632(ra) # 2dc <memset>
  client_addr.sin_family = AF_INET;
  6c:	4789                	li	a5,2
  6e:	fcf41023          	sh	a5,-64(s0)
  client_addr.sin_port = htons(CLIENT_PORT);
  72:	6795                	lui	a5,0x5
  74:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x3810>
  78:	fcf41123          	sh	a5,-62(s0)
  client_addr.sin_addr.s_addr = INADDR_ANY;
  7c:	4785                	li	a5,1
  7e:	fcf42223          	sw	a5,-60(s0)

  if (bind(client_fd, (struct sockaddr *)&client_addr, sizeof(client_addr)) < 0) {
  82:	4641                	li	a2,16
  84:	85ca                	mv	a1,s2
  86:	8526                	mv	a0,s1
  88:	00000097          	auipc	ra,0x0
  8c:	53e080e7          	jalr	1342(ra) # 5c6 <bind>
  90:	06054a63          	bltz	a0,104 <udp_basic_test+0x104>
    printf("client bind failed\n");
    exit(1);
  }

  // --- Client sends message to server
  printf("sending payload\n");
  94:	00001517          	auipc	a0,0x1
  98:	c8450513          	addi	a0,a0,-892 # d18 <ithread_join+0x9a>
  9c:	00001097          	auipc	ra,0x1
  a0:	826080e7          	jalr	-2010(ra) # 8c2 <printf>
  if (sendto(client_fd, MSG, strlen(MSG), 0,
  a4:	00001517          	auipc	a0,0x1
  a8:	c8c50513          	addi	a0,a0,-884 # d30 <ithread_join+0xb2>
  ac:	00000097          	auipc	ra,0x0
  b0:	202080e7          	jalr	514(ra) # 2ae <strlen>
  b4:	862a                	mv	a2,a0
  b6:	47c1                	li	a5,16
  b8:	fd040713          	addi	a4,s0,-48
  bc:	4681                	li	a3,0
  be:	00001597          	auipc	a1,0x1
  c2:	c7258593          	addi	a1,a1,-910 # d30 <ithread_join+0xb2>
  c6:	8526                	mv	a0,s1
  c8:	00000097          	auipc	ra,0x0
  cc:	530080e7          	jalr	1328(ra) # 5f8 <sendto>
  d0:	04054763          	bltz	a0,11e <udp_basic_test+0x11e>
  //   printf("UDP PACKET RECEIVED: \n\t");
  //   printf("%s\n", buf);
  // }

  // close(client_fd);
  close(client_fd);
  d4:	8526                	mv	a0,s1
  d6:	00000097          	auipc	ra,0x0
  da:	450080e7          	jalr	1104(ra) # 526 <close>
}
  de:	70e2                	ld	ra,56(sp)
  e0:	7442                	ld	s0,48(sp)
  e2:	74a2                	ld	s1,40(sp)
  e4:	7902                	ld	s2,32(sp)
  e6:	6121                	addi	sp,sp,64
  e8:	8082                	ret
    printf("client socket failed\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	bfe50513          	addi	a0,a0,-1026 # ce8 <ithread_join+0x6a>
  f2:	00000097          	auipc	ra,0x0
  f6:	7d0080e7          	jalr	2000(ra) # 8c2 <printf>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	402080e7          	jalr	1026(ra) # 4fe <exit>
    printf("client bind failed\n");
 104:	00001517          	auipc	a0,0x1
 108:	bfc50513          	addi	a0,a0,-1028 # d00 <ithread_join+0x82>
 10c:	00000097          	auipc	ra,0x0
 110:	7b6080e7          	jalr	1974(ra) # 8c2 <printf>
    exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	3e8080e7          	jalr	1000(ra) # 4fe <exit>
    printf("sendto failed\n");
 11e:	00001517          	auipc	a0,0x1
 122:	c2250513          	addi	a0,a0,-990 # d40 <ithread_join+0xc2>
 126:	00000097          	auipc	ra,0x0
 12a:	79c080e7          	jalr	1948(ra) # 8c2 <printf>
    exit(1);
 12e:	4505                	li	a0,1
 130:	00000097          	auipc	ra,0x0
 134:	3ce080e7          	jalr	974(ra) # 4fe <exit>

0000000000000138 <tcp_test3>:
int tcp_test3() {
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
 140:	4781                	li	a5,0
 142:	4709                	li	a4,2
 144:	c398                	sw	a4,0(a5)
  p->ai_socktype = SOCK_STREAM;
 146:	4705                	li	a4,1
 148:	c3d8                	sw	a4,4(a5)
  p->ai_protocol = 0;
 14a:	0007a623          	sw	zero,12(a5)
  //   return -1;
  // }
  // 
  // printf("socket_test3: PASSED\n");
  return 0;
}
 14e:	4501                	li	a0,0
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <tcp_test2>:

int tcp_test2() {
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	1000                	addi	s0,sp,32
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
 162:	4509                	li	a0,2
 164:	4781                	li	a5,0
 166:	c388                	sw	a0,0(a5)
  p->ai_socktype = SOCK_STREAM;
 168:	4485                	li	s1,1
 16a:	c3c4                	sw	s1,4(a5)
  p->ai_protocol = 0;
 16c:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
 170:	4601                	li	a2,0
 172:	85a6                	mv	a1,s1
 174:	00000097          	auipc	ra,0x0
 178:	44a080e7          	jalr	1098(ra) # 5be <socket>

  if (fd != 1) {
 17c:	02951d63          	bne	a0,s1,1b6 <tcp_test2+0x5e>
    printf("socket_test2: SOCKET FAILED\n");
    return -1;
  }

  if (bind(fd, p->ai_addr, p->ai_addrlen) == -1) {
 180:	4781                	li	a5,0
 182:	4b90                	lw	a2,16(a5)
 184:	6f8c                	ld	a1,24(a5)
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	43e080e7          	jalr	1086(ra) # 5c6 <bind>
 190:	84aa                	mv	s1,a0
 192:	57fd                	li	a5,-1
 194:	02f50b63          	beq	a0,a5,1ca <tcp_test2+0x72>
    printf("socket_test2: BIND FAILED\n");
    return -1;
  }
  
  printf("socket_test2: PASSED\n");
 198:	00001517          	auipc	a0,0x1
 19c:	bf850513          	addi	a0,a0,-1032 # d90 <ithread_join+0x112>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	722080e7          	jalr	1826(ra) # 8c2 <printf>

  return 0;
 1a8:	4481                	li	s1,0
}
 1aa:	8526                	mv	a0,s1
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	64a2                	ld	s1,8(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    printf("socket_test2: SOCKET FAILED\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	b9a50513          	addi	a0,a0,-1126 # d50 <ithread_join+0xd2>
 1be:	00000097          	auipc	ra,0x0
 1c2:	704080e7          	jalr	1796(ra) # 8c2 <printf>
    return -1;
 1c6:	54fd                	li	s1,-1
 1c8:	b7cd                	j	1aa <tcp_test2+0x52>
    printf("socket_test2: BIND FAILED\n");
 1ca:	00001517          	auipc	a0,0x1
 1ce:	ba650513          	addi	a0,a0,-1114 # d70 <ithread_join+0xf2>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	6f0080e7          	jalr	1776(ra) # 8c2 <printf>
    return -1;
 1da:	bfc1                	j	1aa <tcp_test2+0x52>

00000000000001dc <tcp_test1>:

int tcp_test1() {
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  struct addrinfo hints, *servinfo, *p;
  p->ai_family = AF_INET;
 1e4:	4509                	li	a0,2
 1e6:	4781                	li	a5,0
 1e8:	c388                	sw	a0,0(a5)
  p->ai_socktype = SOCK_STREAM;
 1ea:	4585                	li	a1,1
 1ec:	c3cc                	sw	a1,4(a5)
  p->ai_protocol = 0;
 1ee:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
 1f2:	4601                	li	a2,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	3ca080e7          	jalr	970(ra) # 5be <socket>

  if (fd == 0) 
 1fc:	ed11                	bnez	a0,218 <tcp_test1+0x3c>
    printf("socket_test1: PASSED\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	baa50513          	addi	a0,a0,-1110 # da8 <ithread_join+0x12a>
 206:	00000097          	auipc	ra,0x0
 20a:	6bc080e7          	jalr	1724(ra) # 8c2 <printf>
  else
    printf("socket_test1: FAILED\n");

  return 0;
}
 20e:	4501                	li	a0,0
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
    printf("socket_test1: FAILED\n");
 218:	00001517          	auipc	a0,0x1
 21c:	ba850513          	addi	a0,a0,-1112 # dc0 <ithread_join+0x142>
 220:	00000097          	auipc	ra,0x0
 224:	6a2080e7          	jalr	1698(ra) # 8c2 <printf>
 228:	b7dd                	j	20e <tcp_test1+0x32>

000000000000022a <main>:

int main() {
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  udp_basic_test();
 232:	00000097          	auipc	ra,0x0
 236:	dce080e7          	jalr	-562(ra) # 0 <udp_basic_test>
  // tcp_test1();
  // tcp_test2();
  // tcp_test3();
}
 23a:	4501                	li	a0,0
 23c:	60a2                	ld	ra,8(sp)
 23e:	6402                	ld	s0,0(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 24c:	00000097          	auipc	ra,0x0
 250:	fde080e7          	jalr	-34(ra) # 22a <main>
  exit(0);
 254:	4501                	li	a0,0
 256:	00000097          	auipc	ra,0x0
 25a:	2a8080e7          	jalr	680(ra) # 4fe <exit>

000000000000025e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 266:	87aa                	mv	a5,a0
 268:	0585                	addi	a1,a1,1
 26a:	0785                	addi	a5,a5,1
 26c:	fff5c703          	lbu	a4,-1(a1)
 270:	fee78fa3          	sb	a4,-1(a5)
 274:	fb75                	bnez	a4,268 <strcpy+0xa>
    ;
  return os;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 286:	00054783          	lbu	a5,0(a0)
 28a:	cb91                	beqz	a5,29e <strcmp+0x20>
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00f71763          	bne	a4,a5,29e <strcmp+0x20>
    p++, q++;
 294:	0505                	addi	a0,a0,1
 296:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 298:	00054783          	lbu	a5,0(a0)
 29c:	fbe5                	bnez	a5,28c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 29e:	0005c503          	lbu	a0,0(a1)
}
 2a2:	40a7853b          	subw	a0,a5,a0
 2a6:	60a2                	ld	ra,8(sp)
 2a8:	6402                	ld	s0,0(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <strlen>:

uint
strlen(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	cf99                	beqz	a5,2d8 <strlen+0x2a>
 2bc:	0505                	addi	a0,a0,1
 2be:	87aa                	mv	a5,a0
 2c0:	86be                	mv	a3,a5
 2c2:	0785                	addi	a5,a5,1
 2c4:	fff7c703          	lbu	a4,-1(a5)
 2c8:	ff65                	bnez	a4,2c0 <strlen+0x12>
 2ca:	40a6853b          	subw	a0,a3,a0
 2ce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  for(n = 0; s[n]; n++)
 2d8:	4501                	li	a0,0
 2da:	bfdd                	j	2d0 <strlen+0x22>

00000000000002dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e4:	ca19                	beqz	a2,2fa <memset+0x1e>
 2e6:	87aa                	mv	a5,a0
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f4:	0785                	addi	a5,a5,1
 2f6:	fee79de3          	bne	a5,a4,2f0 <memset+0x14>
  }
  return dst;
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <strchr>:

char*
strchr(const char *s, char c)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30a:	00054783          	lbu	a5,0(a0)
 30e:	cf81                	beqz	a5,326 <strchr+0x24>
    if(*s == c)
 310:	00f58763          	beq	a1,a5,31e <strchr+0x1c>
  for(; *s; s++)
 314:	0505                	addi	a0,a0,1
 316:	00054783          	lbu	a5,0(a0)
 31a:	fbfd                	bnez	a5,310 <strchr+0xe>
      return (char*)s;
  return 0;
 31c:	4501                	li	a0,0
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <strchr+0x1c>

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	7159                	addi	sp,sp,-112
 32c:	f486                	sd	ra,104(sp)
 32e:	f0a2                	sd	s0,96(sp)
 330:	eca6                	sd	s1,88(sp)
 332:	e8ca                	sd	s2,80(sp)
 334:	e4ce                	sd	s3,72(sp)
 336:	e0d2                	sd	s4,64(sp)
 338:	fc56                	sd	s5,56(sp)
 33a:	f85a                	sd	s6,48(sp)
 33c:	f45e                	sd	s7,40(sp)
 33e:	f062                	sd	s8,32(sp)
 340:	ec66                	sd	s9,24(sp)
 342:	e86a                	sd	s10,16(sp)
 344:	1880                	addi	s0,sp,112
 346:	8caa                	mv	s9,a0
 348:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34a:	892a                	mv	s2,a0
 34c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 34e:	f9f40b13          	addi	s6,s0,-97
 352:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 354:	4ba9                	li	s7,10
 356:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 358:	8d26                	mv	s10,s1
 35a:	0014899b          	addiw	s3,s1,1
 35e:	84ce                	mv	s1,s3
 360:	0349d763          	bge	s3,s4,38e <gets+0x64>
    cc = read(0, &c, 1);
 364:	8656                	mv	a2,s5
 366:	85da                	mv	a1,s6
 368:	4501                	li	a0,0
 36a:	00000097          	auipc	ra,0x0
 36e:	1ac080e7          	jalr	428(ra) # 516 <read>
    if(cc < 1)
 372:	00a05e63          	blez	a0,38e <gets+0x64>
    buf[i++] = c;
 376:	f9f44783          	lbu	a5,-97(s0)
 37a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37e:	01778763          	beq	a5,s7,38c <gets+0x62>
 382:	0905                	addi	s2,s2,1
 384:	fd879ae3          	bne	a5,s8,358 <gets+0x2e>
    buf[i++] = c;
 388:	8d4e                	mv	s10,s3
 38a:	a011                	j	38e <gets+0x64>
 38c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 38e:	9d66                	add	s10,s10,s9
 390:	000d0023          	sb	zero,0(s10)
  return buf;
}
 394:	8566                	mv	a0,s9
 396:	70a6                	ld	ra,104(sp)
 398:	7406                	ld	s0,96(sp)
 39a:	64e6                	ld	s1,88(sp)
 39c:	6946                	ld	s2,80(sp)
 39e:	69a6                	ld	s3,72(sp)
 3a0:	6a06                	ld	s4,64(sp)
 3a2:	7ae2                	ld	s5,56(sp)
 3a4:	7b42                	ld	s6,48(sp)
 3a6:	7ba2                	ld	s7,40(sp)
 3a8:	7c02                	ld	s8,32(sp)
 3aa:	6ce2                	ld	s9,24(sp)
 3ac:	6d42                	ld	s10,16(sp)
 3ae:	6165                	addi	sp,sp,112
 3b0:	8082                	ret

00000000000003b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	e04a                	sd	s2,0(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3be:	4581                	li	a1,0
 3c0:	00000097          	auipc	ra,0x0
 3c4:	17e080e7          	jalr	382(ra) # 53e <open>
  if(fd < 0)
 3c8:	02054663          	bltz	a0,3f4 <stat+0x42>
 3cc:	e426                	sd	s1,8(sp)
 3ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d0:	85ca                	mv	a1,s2
 3d2:	00000097          	auipc	ra,0x0
 3d6:	184080e7          	jalr	388(ra) # 556 <fstat>
 3da:	892a                	mv	s2,a0
  close(fd);
 3dc:	8526                	mv	a0,s1
 3de:	00000097          	auipc	ra,0x0
 3e2:	148080e7          	jalr	328(ra) # 526 <close>
  return r;
 3e6:	64a2                	ld	s1,8(sp)
}
 3e8:	854a                	mv	a0,s2
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6902                	ld	s2,0(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret
    return -1;
 3f4:	597d                	li	s2,-1
 3f6:	bfcd                	j	3e8 <stat+0x36>

00000000000003f8 <atoi>:

int
atoi(const char *s)
{
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e406                	sd	ra,8(sp)
 3fc:	e022                	sd	s0,0(sp)
 3fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 400:	00054683          	lbu	a3,0(a0)
 404:	fd06879b          	addiw	a5,a3,-48
 408:	0ff7f793          	zext.b	a5,a5
 40c:	4625                	li	a2,9
 40e:	02f66963          	bltu	a2,a5,440 <atoi+0x48>
 412:	872a                	mv	a4,a0
  n = 0;
 414:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 416:	0705                	addi	a4,a4,1
 418:	0025179b          	slliw	a5,a0,0x2
 41c:	9fa9                	addw	a5,a5,a0
 41e:	0017979b          	slliw	a5,a5,0x1
 422:	9fb5                	addw	a5,a5,a3
 424:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 428:	00074683          	lbu	a3,0(a4)
 42c:	fd06879b          	addiw	a5,a3,-48
 430:	0ff7f793          	zext.b	a5,a5
 434:	fef671e3          	bgeu	a2,a5,416 <atoi+0x1e>
  return n;
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret
  n = 0;
 440:	4501                	li	a0,0
 442:	bfdd                	j	438 <atoi+0x40>

0000000000000444 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 444:	1141                	addi	sp,sp,-16
 446:	e406                	sd	ra,8(sp)
 448:	e022                	sd	s0,0(sp)
 44a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 44c:	02b57563          	bgeu	a0,a1,476 <memmove+0x32>
    while(n-- > 0)
 450:	00c05f63          	blez	a2,46e <memmove+0x2a>
 454:	1602                	slli	a2,a2,0x20
 456:	9201                	srli	a2,a2,0x20
 458:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 45c:	872a                	mv	a4,a0
      *dst++ = *src++;
 45e:	0585                	addi	a1,a1,1
 460:	0705                	addi	a4,a4,1
 462:	fff5c683          	lbu	a3,-1(a1)
 466:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 46a:	fee79ae3          	bne	a5,a4,45e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret
    dst += n;
 476:	00c50733          	add	a4,a0,a2
    src += n;
 47a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 47c:	fec059e3          	blez	a2,46e <memmove+0x2a>
 480:	fff6079b          	addiw	a5,a2,-1
 484:	1782                	slli	a5,a5,0x20
 486:	9381                	srli	a5,a5,0x20
 488:	fff7c793          	not	a5,a5
 48c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 48e:	15fd                	addi	a1,a1,-1
 490:	177d                	addi	a4,a4,-1
 492:	0005c683          	lbu	a3,0(a1)
 496:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49a:	fef71ae3          	bne	a4,a5,48e <memmove+0x4a>
 49e:	bfc1                	j	46e <memmove+0x2a>

00000000000004a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e406                	sd	ra,8(sp)
 4a4:	e022                	sd	s0,0(sp)
 4a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a8:	ca0d                	beqz	a2,4da <memcmp+0x3a>
 4aa:	fff6069b          	addiw	a3,a2,-1
 4ae:	1682                	slli	a3,a3,0x20
 4b0:	9281                	srli	a3,a3,0x20
 4b2:	0685                	addi	a3,a3,1
 4b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b6:	00054783          	lbu	a5,0(a0)
 4ba:	0005c703          	lbu	a4,0(a1)
 4be:	00e79863          	bne	a5,a4,4ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4c2:	0505                	addi	a0,a0,1
    p2++;
 4c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c6:	fed518e3          	bne	a0,a3,4b6 <memcmp+0x16>
  }
  return 0;
 4ca:	4501                	li	a0,0
 4cc:	a019                	j	4d2 <memcmp+0x32>
      return *p1 - *p2;
 4ce:	40e7853b          	subw	a0,a5,a4
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  return 0;
 4da:	4501                	li	a0,0
 4dc:	bfdd                	j	4d2 <memcmp+0x32>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	00000097          	auipc	ra,0x0
 4ea:	f5e080e7          	jalr	-162(ra) # 444 <memmove>
}
 4ee:	60a2                	ld	ra,8(sp)
 4f0:	6402                	ld	s0,0(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret

00000000000004f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f6:	4885                	li	a7,1
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fe:	4889                	li	a7,2
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <wait>:
.global wait
wait:
 li a7, SYS_wait
 506:	488d                	li	a7,3
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50e:	4891                	li	a7,4
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <read>:
.global read
read:
 li a7, SYS_read
 516:	4895                	li	a7,5
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <write>:
.global write
write:
 li a7, SYS_write
 51e:	48c1                	li	a7,16
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <close>:
.global close
close:
 li a7, SYS_close
 526:	48d5                	li	a7,21
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <kill>:
.global kill
kill:
 li a7, SYS_kill
 52e:	4899                	li	a7,6
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <exec>:
.global exec
exec:
 li a7, SYS_exec
 536:	489d                	li	a7,7
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <open>:
.global open
open:
 li a7, SYS_open
 53e:	48bd                	li	a7,15
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 546:	48c5                	li	a7,17
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54e:	48c9                	li	a7,18
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 556:	48a1                	li	a7,8
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <link>:
.global link
link:
 li a7, SYS_link
 55e:	48cd                	li	a7,19
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 566:	48d1                	li	a7,20
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56e:	48a5                	li	a7,9
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <dup>:
.global dup
dup:
 li a7, SYS_dup
 576:	48a9                	li	a7,10
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57e:	48ad                	li	a7,11
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 586:	48b1                	li	a7,12
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 58e:	48b5                	li	a7,13
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 596:	48b9                	li	a7,14
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 59e:	48d9                	li	a7,22
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 5a6:	48dd                	li	a7,23
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 5ae:	48e1                	li	a7,24
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 5b6:	48e5                	li	a7,25
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <socket>:
.global socket
socket:
 li a7, SYS_socket
 5be:	48e9                	li	a7,26
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <bind>:
.global bind
bind:
 li a7, SYS_bind
 5c6:	48ed                	li	a7,27
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <accept>:
.global accept
accept:
 li a7, SYS_accept
 5ce:	48f5                	li	a7,29
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <listen>:
.global listen
listen:
 li a7, SYS_listen
 5d6:	48f1                	li	a7,28
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <connect>:
.global connect
connect:
 li a7, SYS_connect
 5de:	48f9                	li	a7,30
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <send>:
.global send
send:
 li a7, SYS_send
 5e6:	48fd                	li	a7,31
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <recv>:
.global recv
recv:
 li a7, SYS_recv
 5ee:	02000893          	li	a7,32
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 5f8:	02100893          	li	a7,33
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 602:	02200893          	li	a7,34
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 618:	4605                	li	a2,1
 61a:	fef40593          	addi	a1,s0,-17
 61e:	00000097          	auipc	ra,0x0
 622:	f00080e7          	jalr	-256(ra) # 51e <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	f426                	sd	s1,40(sp)
 636:	f04a                	sd	s2,32(sp)
 638:	ec4e                	sd	s3,24(sp)
 63a:	0080                	addi	s0,sp,64
 63c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63e:	c299                	beqz	a3,644 <printint+0x16>
 640:	0805c063          	bltz	a1,6c0 <printint+0x92>
  neg = 0;
 644:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 646:	fc040313          	addi	t1,s0,-64
  neg = 0;
 64a:	869a                	mv	a3,t1
  i = 0;
 64c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 64e:	00001817          	auipc	a6,0x1
 652:	81a80813          	addi	a6,a6,-2022 # e68 <digits>
 656:	88be                	mv	a7,a5
 658:	0017851b          	addiw	a0,a5,1
 65c:	87aa                	mv	a5,a0
 65e:	02c5f73b          	remuw	a4,a1,a2
 662:	1702                	slli	a4,a4,0x20
 664:	9301                	srli	a4,a4,0x20
 666:	9742                	add	a4,a4,a6
 668:	00074703          	lbu	a4,0(a4)
 66c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 670:	872e                	mv	a4,a1
 672:	02c5d5bb          	divuw	a1,a1,a2
 676:	0685                	addi	a3,a3,1
 678:	fcc77fe3          	bgeu	a4,a2,656 <printint+0x28>
  if(neg)
 67c:	000e0c63          	beqz	t3,694 <printint+0x66>
    buf[i++] = '-';
 680:	fd050793          	addi	a5,a0,-48
 684:	00878533          	add	a0,a5,s0
 688:	02d00793          	li	a5,45
 68c:	fef50823          	sb	a5,-16(a0)
 690:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 694:	fff7899b          	addiw	s3,a5,-1
 698:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 69c:	fff4c583          	lbu	a1,-1(s1)
 6a0:	854a                	mv	a0,s2
 6a2:	00000097          	auipc	ra,0x0
 6a6:	f6a080e7          	jalr	-150(ra) # 60c <putc>
  while(--i >= 0)
 6aa:	39fd                	addiw	s3,s3,-1
 6ac:	14fd                	addi	s1,s1,-1
 6ae:	fe09d7e3          	bgez	s3,69c <printint+0x6e>
}
 6b2:	70e2                	ld	ra,56(sp)
 6b4:	7442                	ld	s0,48(sp)
 6b6:	74a2                	ld	s1,40(sp)
 6b8:	7902                	ld	s2,32(sp)
 6ba:	69e2                	ld	s3,24(sp)
 6bc:	6121                	addi	sp,sp,64
 6be:	8082                	ret
    x = -xx;
 6c0:	40b005bb          	negw	a1,a1
    neg = 1;
 6c4:	4e05                	li	t3,1
    x = -xx;
 6c6:	b741                	j	646 <printint+0x18>

00000000000006c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c8:	715d                	addi	sp,sp,-80
 6ca:	e486                	sd	ra,72(sp)
 6cc:	e0a2                	sd	s0,64(sp)
 6ce:	f84a                	sd	s2,48(sp)
 6d0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d2:	0005c903          	lbu	s2,0(a1)
 6d6:	1a090a63          	beqz	s2,88a <vprintf+0x1c2>
 6da:	fc26                	sd	s1,56(sp)
 6dc:	f44e                	sd	s3,40(sp)
 6de:	f052                	sd	s4,32(sp)
 6e0:	ec56                	sd	s5,24(sp)
 6e2:	e85a                	sd	s6,16(sp)
 6e4:	e45e                	sd	s7,8(sp)
 6e6:	8aaa                	mv	s5,a0
 6e8:	8bb2                	mv	s7,a2
 6ea:	00158493          	addi	s1,a1,1
  state = 0;
 6ee:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6f0:	02500a13          	li	s4,37
 6f4:	4b55                	li	s6,21
 6f6:	a839                	j	714 <vprintf+0x4c>
        putc(fd, c);
 6f8:	85ca                	mv	a1,s2
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	f10080e7          	jalr	-240(ra) # 60c <putc>
 704:	a019                	j	70a <vprintf+0x42>
    } else if(state == '%'){
 706:	01498d63          	beq	s3,s4,720 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 70a:	0485                	addi	s1,s1,1
 70c:	fff4c903          	lbu	s2,-1(s1)
 710:	16090763          	beqz	s2,87e <vprintf+0x1b6>
    if(state == 0){
 714:	fe0999e3          	bnez	s3,706 <vprintf+0x3e>
      if(c == '%'){
 718:	ff4910e3          	bne	s2,s4,6f8 <vprintf+0x30>
        state = '%';
 71c:	89d2                	mv	s3,s4
 71e:	b7f5                	j	70a <vprintf+0x42>
      if(c == 'd'){
 720:	13490463          	beq	s2,s4,848 <vprintf+0x180>
 724:	f9d9079b          	addiw	a5,s2,-99
 728:	0ff7f793          	zext.b	a5,a5
 72c:	12fb6763          	bltu	s6,a5,85a <vprintf+0x192>
 730:	f9d9079b          	addiw	a5,s2,-99
 734:	0ff7f713          	zext.b	a4,a5
 738:	12eb6163          	bltu	s6,a4,85a <vprintf+0x192>
 73c:	00271793          	slli	a5,a4,0x2
 740:	00000717          	auipc	a4,0x0
 744:	6d070713          	addi	a4,a4,1744 # e10 <ithread_join+0x192>
 748:	97ba                	add	a5,a5,a4
 74a:	439c                	lw	a5,0(a5)
 74c:	97ba                	add	a5,a5,a4
 74e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 750:	008b8913          	addi	s2,s7,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	ed0080e7          	jalr	-304(ra) # 62e <printint>
 766:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 768:	4981                	li	s3,0
 76a:	b745                	j	70a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4629                	li	a2,10
 774:	000ba583          	lw	a1,0(s7)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	eb4080e7          	jalr	-332(ra) # 62e <printint>
 782:	8bca                	mv	s7,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	b751                	j	70a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 788:	008b8913          	addi	s2,s7,8
 78c:	4681                	li	a3,0
 78e:	4641                	li	a2,16
 790:	000ba583          	lw	a1,0(s7)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	e98080e7          	jalr	-360(ra) # 62e <printint>
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b7a5                	j	70a <vprintf+0x42>
 7a4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a6:	008b8c13          	addi	s8,s7,8
 7aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ae:	03000593          	li	a1,48
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e58080e7          	jalr	-424(ra) # 60c <putc>
  putc(fd, 'x');
 7bc:	07800593          	li	a1,120
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e4a080e7          	jalr	-438(ra) # 60c <putc>
 7ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7cc:	00000b97          	auipc	s7,0x0
 7d0:	69cb8b93          	addi	s7,s7,1692 # e68 <digits>
 7d4:	03c9d793          	srli	a5,s3,0x3c
 7d8:	97de                	add	a5,a5,s7
 7da:	0007c583          	lbu	a1,0(a5)
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e2c080e7          	jalr	-468(ra) # 60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e8:	0992                	slli	s3,s3,0x4
 7ea:	397d                	addiw	s2,s2,-1
 7ec:	fe0914e3          	bnez	s2,7d4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7f0:	8be2                	mv	s7,s8
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	6c02                	ld	s8,0(sp)
 7f6:	bf11                	j	70a <vprintf+0x42>
        s = va_arg(ap, char*);
 7f8:	008b8993          	addi	s3,s7,8
 7fc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 800:	02090163          	beqz	s2,822 <vprintf+0x15a>
        while(*s != 0){
 804:	00094583          	lbu	a1,0(s2)
 808:	c9a5                	beqz	a1,878 <vprintf+0x1b0>
          putc(fd, *s);
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e00080e7          	jalr	-512(ra) # 60c <putc>
          s++;
 814:	0905                	addi	s2,s2,1
        while(*s != 0){
 816:	00094583          	lbu	a1,0(s2)
 81a:	f9e5                	bnez	a1,80a <vprintf+0x142>
        s = va_arg(ap, char*);
 81c:	8bce                	mv	s7,s3
      state = 0;
 81e:	4981                	li	s3,0
 820:	b5ed                	j	70a <vprintf+0x42>
          s = "(null)";
 822:	00000917          	auipc	s2,0x0
 826:	5b690913          	addi	s2,s2,1462 # dd8 <ithread_join+0x15a>
        while(*s != 0){
 82a:	02800593          	li	a1,40
 82e:	bff1                	j	80a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 830:	008b8913          	addi	s2,s7,8
 834:	000bc583          	lbu	a1,0(s7)
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	dd2080e7          	jalr	-558(ra) # 60c <putc>
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
 846:	b5d1                	j	70a <vprintf+0x42>
        putc(fd, c);
 848:	02500593          	li	a1,37
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	dbe080e7          	jalr	-578(ra) # 60c <putc>
      state = 0;
 856:	4981                	li	s3,0
 858:	bd4d                	j	70a <vprintf+0x42>
        putc(fd, '%');
 85a:	02500593          	li	a1,37
 85e:	8556                	mv	a0,s5
 860:	00000097          	auipc	ra,0x0
 864:	dac080e7          	jalr	-596(ra) # 60c <putc>
        putc(fd, c);
 868:	85ca                	mv	a1,s2
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	da0080e7          	jalr	-608(ra) # 60c <putc>
      state = 0;
 874:	4981                	li	s3,0
 876:	bd51                	j	70a <vprintf+0x42>
        s = va_arg(ap, char*);
 878:	8bce                	mv	s7,s3
      state = 0;
 87a:	4981                	li	s3,0
 87c:	b579                	j	70a <vprintf+0x42>
 87e:	74e2                	ld	s1,56(sp)
 880:	79a2                	ld	s3,40(sp)
 882:	7a02                	ld	s4,32(sp)
 884:	6ae2                	ld	s5,24(sp)
 886:	6b42                	ld	s6,16(sp)
 888:	6ba2                	ld	s7,8(sp)
    }
  }
}
 88a:	60a6                	ld	ra,72(sp)
 88c:	6406                	ld	s0,64(sp)
 88e:	7942                	ld	s2,48(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret

0000000000000894 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 894:	715d                	addi	sp,sp,-80
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e010                	sd	a2,0(s0)
 89e:	e414                	sd	a3,8(s0)
 8a0:	e818                	sd	a4,16(s0)
 8a2:	ec1c                	sd	a5,24(s0)
 8a4:	03043023          	sd	a6,32(s0)
 8a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ac:	8622                	mv	a2,s0
 8ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b2:	00000097          	auipc	ra,0x0
 8b6:	e16080e7          	jalr	-490(ra) # 6c8 <vprintf>
}
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6442                	ld	s0,16(sp)
 8be:	6161                	addi	sp,sp,80
 8c0:	8082                	ret

00000000000008c2 <printf>:

void
printf(const char *fmt, ...)
{
 8c2:	711d                	addi	sp,sp,-96
 8c4:	ec06                	sd	ra,24(sp)
 8c6:	e822                	sd	s0,16(sp)
 8c8:	1000                	addi	s0,sp,32
 8ca:	e40c                	sd	a1,8(s0)
 8cc:	e810                	sd	a2,16(s0)
 8ce:	ec14                	sd	a3,24(s0)
 8d0:	f018                	sd	a4,32(s0)
 8d2:	f41c                	sd	a5,40(s0)
 8d4:	03043823          	sd	a6,48(s0)
 8d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8dc:	00840613          	addi	a2,s0,8
 8e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e4:	85aa                	mv	a1,a0
 8e6:	4505                	li	a0,1
 8e8:	00000097          	auipc	ra,0x0
 8ec:	de0080e7          	jalr	-544(ra) # 6c8 <vprintf>
}
 8f0:	60e2                	ld	ra,24(sp)
 8f2:	6442                	ld	s0,16(sp)
 8f4:	6125                	addi	sp,sp,96
 8f6:	8082                	ret

00000000000008f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f8:	1141                	addi	sp,sp,-16
 8fa:	e406                	sd	ra,8(sp)
 8fc:	e022                	sd	s0,0(sp)
 8fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 900:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 904:	00001797          	auipc	a5,0x1
 908:	ccc7b783          	ld	a5,-820(a5) # 15d0 <freep>
 90c:	a02d                	j	936 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90e:	4618                	lw	a4,8(a2)
 910:	9f2d                	addw	a4,a4,a1
 912:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	6310                	ld	a2,0(a4)
 91a:	a83d                	j	958 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91c:	ff852703          	lw	a4,-8(a0)
 920:	9f31                	addw	a4,a4,a2
 922:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 924:	ff053683          	ld	a3,-16(a0)
 928:	a091                	j	96c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	6398                	ld	a4,0(a5)
 92c:	00e7e463          	bltu	a5,a4,934 <free+0x3c>
 930:	00e6ea63          	bltu	a3,a4,944 <free+0x4c>
{
 934:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 936:	fed7fae3          	bgeu	a5,a3,92a <free+0x32>
 93a:	6398                	ld	a4,0(a5)
 93c:	00e6e463          	bltu	a3,a4,944 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	fee7eae3          	bltu	a5,a4,934 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 944:	ff852583          	lw	a1,-8(a0)
 948:	6390                	ld	a2,0(a5)
 94a:	02059813          	slli	a6,a1,0x20
 94e:	01c85713          	srli	a4,a6,0x1c
 952:	9736                	add	a4,a4,a3
 954:	fae60de3          	beq	a2,a4,90e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95c:	4790                	lw	a2,8(a5)
 95e:	02061593          	slli	a1,a2,0x20
 962:	01c5d713          	srli	a4,a1,0x1c
 966:	973e                	add	a4,a4,a5
 968:	fae68ae3          	beq	a3,a4,91c <free+0x24>
    p->s.ptr = bp->s.ptr;
 96c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96e:	00001717          	auipc	a4,0x1
 972:	c6f73123          	sd	a5,-926(a4) # 15d0 <freep>
}
 976:	60a2                	ld	ra,8(sp)
 978:	6402                	ld	s0,0(sp)
 97a:	0141                	addi	sp,sp,16
 97c:	8082                	ret

000000000000097e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97e:	7139                	addi	sp,sp,-64
 980:	fc06                	sd	ra,56(sp)
 982:	f822                	sd	s0,48(sp)
 984:	f04a                	sd	s2,32(sp)
 986:	ec4e                	sd	s3,24(sp)
 988:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98a:	02051993          	slli	s3,a0,0x20
 98e:	0209d993          	srli	s3,s3,0x20
 992:	09bd                	addi	s3,s3,15
 994:	0049d993          	srli	s3,s3,0x4
 998:	2985                	addiw	s3,s3,1
 99a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 99c:	00001517          	auipc	a0,0x1
 9a0:	c3453503          	ld	a0,-972(a0) # 15d0 <freep>
 9a4:	c905                	beqz	a0,9d4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	09377a63          	bgeu	a4,s3,a3e <malloc+0xc0>
 9ae:	f426                	sd	s1,40(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b6:	8a4e                	mv	s4,s3
 9b8:	6705                	lui	a4,0x1
 9ba:	00e9f363          	bgeu	s3,a4,9c0 <malloc+0x42>
 9be:	6a05                	lui	s4,0x1
 9c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c8:	00001497          	auipc	s1,0x1
 9cc:	c0848493          	addi	s1,s1,-1016 # 15d0 <freep>
  if(p == (char*)-1)
 9d0:	5afd                	li	s5,-1
 9d2:	a089                	j	a14 <malloc+0x96>
 9d4:	f426                	sd	s1,40(sp)
 9d6:	e852                	sd	s4,16(sp)
 9d8:	e456                	sd	s5,8(sp)
 9da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9dc:	00001797          	auipc	a5,0x1
 9e0:	c1478793          	addi	a5,a5,-1004 # 15f0 <base>
 9e4:	00001717          	auipc	a4,0x1
 9e8:	bef73623          	sd	a5,-1044(a4) # 15d0 <freep>
 9ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f2:	b7d1                	j	9b6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9f4:	6398                	ld	a4,0(a5)
 9f6:	e118                	sd	a4,0(a0)
 9f8:	a8b9                	j	a56 <malloc+0xd8>
  hp->s.size = nu;
 9fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fe:	0541                	addi	a0,a0,16
 a00:	00000097          	auipc	ra,0x0
 a04:	ef8080e7          	jalr	-264(ra) # 8f8 <free>
  return freep;
 a08:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a0a:	c135                	beqz	a0,a6e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0e:	4798                	lw	a4,8(a5)
 a10:	03277363          	bgeu	a4,s2,a36 <malloc+0xb8>
    if(p == freep)
 a14:	6098                	ld	a4,0(s1)
 a16:	853e                	mv	a0,a5
 a18:	fef71ae3          	bne	a4,a5,a0c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a1c:	8552                	mv	a0,s4
 a1e:	00000097          	auipc	ra,0x0
 a22:	b68080e7          	jalr	-1176(ra) # 586 <sbrk>
  if(p == (char*)-1)
 a26:	fd551ae3          	bne	a0,s5,9fa <malloc+0x7c>
        return 0;
 a2a:	4501                	li	a0,0
 a2c:	74a2                	ld	s1,40(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
 a34:	a03d                	j	a62 <malloc+0xe4>
 a36:	74a2                	ld	s1,40(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a3e:	fae90be3          	beq	s2,a4,9f4 <malloc+0x76>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00001717          	auipc	a4,0x1
 a5a:	b6a73d23          	sd	a0,-1158(a4) # 15d0 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6121                	addi	sp,sp,64
 a6c:	8082                	ret
 a6e:	74a2                	ld	s1,40(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	b7f5                	j	a62 <malloc+0xe4>

0000000000000a78 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a78:	1141                	addi	sp,sp,-16
 a7a:	e406                	sd	ra,8(sp)
 a7c:	e022                	sd	s0,0(sp)
 a7e:	0800                	addi	s0,sp,16
  thread_exit(status);
 a80:	2501                	sext.w	a0,a0
 a82:	00000097          	auipc	ra,0x0
 a86:	b34080e7          	jalr	-1228(ra) # 5b6 <thread_exit>
}
 a8a:	60a2                	ld	ra,8(sp)
 a8c:	6402                	ld	s0,0(sp)
 a8e:	0141                	addi	sp,sp,16
 a90:	8082                	ret

0000000000000a92 <free_stacks>:
int free_stacks() {
 a92:	7179                	addi	sp,sp,-48
 a94:	f406                	sd	ra,40(sp)
 a96:	f022                	sd	s0,32(sp)
 a98:	ec26                	sd	s1,24(sp)
 a9a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 a9c:	00001797          	auipc	a5,0x1
 aa0:	b447a783          	lw	a5,-1212(a5) # 15e0 <num_threads>
 aa4:	04f05063          	blez	a5,ae4 <free_stacks+0x52>
 aa8:	e84a                	sd	s2,16(sp)
 aaa:	e44e                	sd	s3,8(sp)
 aac:	4481                	li	s1,0
    free(stacks[i]);
 aae:	00001997          	auipc	s3,0x1
 ab2:	b2a98993          	addi	s3,s3,-1238 # 15d8 <stacks>
  for (int i = 0; i < num_threads; i++) {
 ab6:	00001917          	auipc	s2,0x1
 aba:	b2a90913          	addi	s2,s2,-1238 # 15e0 <num_threads>
    free(stacks[i]);
 abe:	0009b783          	ld	a5,0(s3)
 ac2:	00349713          	slli	a4,s1,0x3
 ac6:	97ba                	add	a5,a5,a4
 ac8:	6388                	ld	a0,0(a5)
 aca:	00000097          	auipc	ra,0x0
 ace:	e2e080e7          	jalr	-466(ra) # 8f8 <free>
  for (int i = 0; i < num_threads; i++) {
 ad2:	0485                	addi	s1,s1,1
 ad4:	00092703          	lw	a4,0(s2)
 ad8:	0004879b          	sext.w	a5,s1
 adc:	fee7c1e3          	blt	a5,a4,abe <free_stacks+0x2c>
 ae0:	6942                	ld	s2,16(sp)
 ae2:	69a2                	ld	s3,8(sp)
  free(stacks);
 ae4:	00001497          	auipc	s1,0x1
 ae8:	af448493          	addi	s1,s1,-1292 # 15d8 <stacks>
 aec:	6088                	ld	a0,0(s1)
 aee:	00000097          	auipc	ra,0x0
 af2:	e0a080e7          	jalr	-502(ra) # 8f8 <free>
  stacks = 0;
 af6:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 afa:	00001797          	auipc	a5,0x1
 afe:	ae07a323          	sw	zero,-1306(a5) # 15e0 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b02:	47a1                	li	a5,8
 b04:	00001717          	auipc	a4,0x1
 b08:	aaf72e23          	sw	a5,-1348(a4) # 15c0 <max_stacks>
  threads_done = 0;
 b0c:	00001797          	auipc	a5,0x1
 b10:	ac07ac23          	sw	zero,-1320(a5) # 15e4 <threads_done>
}
 b14:	4501                	li	a0,0
 b16:	70a2                	ld	ra,40(sp)
 b18:	7402                	ld	s0,32(sp)
 b1a:	64e2                	ld	s1,24(sp)
 b1c:	6145                	addi	sp,sp,48
 b1e:	8082                	ret

0000000000000b20 <expand_num_threads>:
int expand_num_threads() {
 b20:	1101                	addi	sp,sp,-32
 b22:	ec06                	sd	ra,24(sp)
 b24:	e822                	sd	s0,16(sp)
 b26:	e426                	sd	s1,8(sp)
 b28:	e04a                	sd	s2,0(sp)
 b2a:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b2c:	00001797          	auipc	a5,0x1
 b30:	a9478793          	addi	a5,a5,-1388 # 15c0 <max_stacks>
 b34:	4388                	lw	a0,0(a5)
 b36:	0015151b          	slliw	a0,a0,0x1
 b3a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b3c:	0035151b          	slliw	a0,a0,0x3
 b40:	00000097          	auipc	ra,0x0
 b44:	e3e080e7          	jalr	-450(ra) # 97e <malloc>
 b48:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b4a:	00001617          	auipc	a2,0x1
 b4e:	a9662603          	lw	a2,-1386(a2) # 15e0 <num_threads>
 b52:	00001497          	auipc	s1,0x1
 b56:	a8648493          	addi	s1,s1,-1402 # 15d8 <stacks>
 b5a:	0036161b          	slliw	a2,a2,0x3
 b5e:	608c                	ld	a1,0(s1)
 b60:	00000097          	auipc	ra,0x0
 b64:	8e4080e7          	jalr	-1820(ra) # 444 <memmove>
  free(stacks);
 b68:	6088                	ld	a0,0(s1)
 b6a:	00000097          	auipc	ra,0x0
 b6e:	d8e080e7          	jalr	-626(ra) # 8f8 <free>
  stacks = new_stacks;
 b72:	0124b023          	sd	s2,0(s1)
}
 b76:	4501                	li	a0,0
 b78:	60e2                	ld	ra,24(sp)
 b7a:	6442                	ld	s0,16(sp)
 b7c:	64a2                	ld	s1,8(sp)
 b7e:	6902                	ld	s2,0(sp)
 b80:	6105                	addi	sp,sp,32
 b82:	8082                	ret

0000000000000b84 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b84:	7179                	addi	sp,sp,-48
 b86:	f406                	sd	ra,40(sp)
 b88:	f022                	sd	s0,32(sp)
 b8a:	e84a                	sd	s2,16(sp)
 b8c:	e44e                	sd	s3,8(sp)
 b8e:	1800                	addi	s0,sp,48
 b90:	892a                	mv	s2,a0
 b92:	89ae                	mv	s3,a1
  if (stacks == 0) {
 b94:	00001797          	auipc	a5,0x1
 b98:	a447b783          	ld	a5,-1468(a5) # 15d8 <stacks>
 b9c:	c3d9                	beqz	a5,c22 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 b9e:	00001797          	auipc	a5,0x1
 ba2:	a227a783          	lw	a5,-1502(a5) # 15c0 <max_stacks>
 ba6:	00001717          	auipc	a4,0x1
 baa:	a3a72703          	lw	a4,-1478(a4) # 15e0 <num_threads>
 bae:	0af71363          	bne	a4,a5,c54 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 bb2:	04000713          	li	a4,64
 bb6:	08e78563          	beq	a5,a4,c40 <ithread_create+0xbc>
 bba:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 bbc:	00000097          	auipc	ra,0x0
 bc0:	f64080e7          	jalr	-156(ra) # b20 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 bc4:	6505                	lui	a0,0x1
 bc6:	00000097          	auipc	ra,0x0
 bca:	db8080e7          	jalr	-584(ra) # 97e <malloc>
 bce:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 bd0:	00001717          	auipc	a4,0x1
 bd4:	a1072703          	lw	a4,-1520(a4) # 15e0 <num_threads>
 bd8:	070e                	slli	a4,a4,0x3
 bda:	00001797          	auipc	a5,0x1
 bde:	9fe7b783          	ld	a5,-1538(a5) # 15d8 <stacks>
 be2:	97ba                	add	a5,a5,a4
 be4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 be6:	00000697          	auipc	a3,0x0
 bea:	e9268693          	addi	a3,a3,-366 # a78 <ithread_exit>
 bee:	862a                	mv	a2,a0
 bf0:	85ce                	mv	a1,s3
 bf2:	854a                	mv	a0,s2
 bf4:	00000097          	auipc	ra,0x0
 bf8:	9b2080e7          	jalr	-1614(ra) # 5a6 <create_thread>
 bfc:	892a                	mv	s2,a0
  if (res != -1) {
 bfe:	57fd                	li	a5,-1
 c00:	04f50c63          	beq	a0,a5,c58 <ithread_create+0xd4>
    num_threads++;
 c04:	00001717          	auipc	a4,0x1
 c08:	9dc70713          	addi	a4,a4,-1572 # 15e0 <num_threads>
 c0c:	431c                	lw	a5,0(a4)
 c0e:	2785                	addiw	a5,a5,1
 c10:	c31c                	sw	a5,0(a4)
 c12:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c14:	854a                	mv	a0,s2
 c16:	70a2                	ld	ra,40(sp)
 c18:	7402                	ld	s0,32(sp)
 c1a:	6942                	ld	s2,16(sp)
 c1c:	69a2                	ld	s3,8(sp)
 c1e:	6145                	addi	sp,sp,48
 c20:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c22:	00001517          	auipc	a0,0x1
 c26:	99e52503          	lw	a0,-1634(a0) # 15c0 <max_stacks>
 c2a:	0035151b          	slliw	a0,a0,0x3
 c2e:	00000097          	auipc	ra,0x0
 c32:	d50080e7          	jalr	-688(ra) # 97e <malloc>
 c36:	00001797          	auipc	a5,0x1
 c3a:	9aa7b123          	sd	a0,-1630(a5) # 15d8 <stacks>
 c3e:	b785                	j	b9e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c40:	00000517          	auipc	a0,0x0
 c44:	1a050513          	addi	a0,a0,416 # de0 <ithread_join+0x162>
 c48:	00000097          	auipc	ra,0x0
 c4c:	c7a080e7          	jalr	-902(ra) # 8c2 <printf>
      return -1;
 c50:	597d                	li	s2,-1
 c52:	b7c9                	j	c14 <ithread_create+0x90>
 c54:	ec26                	sd	s1,24(sp)
 c56:	b7bd                	j	bc4 <ithread_create+0x40>
    free(stack_ptr);
 c58:	8526                	mv	a0,s1
 c5a:	00000097          	auipc	ra,0x0
 c5e:	c9e080e7          	jalr	-866(ra) # 8f8 <free>
    stacks[num_threads] = 0;
 c62:	00001717          	auipc	a4,0x1
 c66:	97e72703          	lw	a4,-1666(a4) # 15e0 <num_threads>
 c6a:	070e                	slli	a4,a4,0x3
 c6c:	00001797          	auipc	a5,0x1
 c70:	96c7b783          	ld	a5,-1684(a5) # 15d8 <stacks>
 c74:	97ba                	add	a5,a5,a4
 c76:	0007b023          	sd	zero,0(a5)
 c7a:	64e2                	ld	s1,24(sp)
 c7c:	bf61                	j	c14 <ithread_create+0x90>

0000000000000c7e <ithread_join>:

int ithread_join(int thread_id) {
 c7e:	1101                	addi	sp,sp,-32
 c80:	ec06                	sd	ra,24(sp)
 c82:	e822                	sd	s0,16(sp)
 c84:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c86:	ff040793          	addi	a5,s0,-16
 c8a:	ffc7859b          	addiw	a1,a5,-4
 c8e:	00000097          	auipc	ra,0x0
 c92:	920080e7          	jalr	-1760(ra) # 5ae <join_thread>
  threads_done++;
 c96:	00001717          	auipc	a4,0x1
 c9a:	94e70713          	addi	a4,a4,-1714 # 15e4 <threads_done>
 c9e:	431c                	lw	a5,0(a4)
 ca0:	2785                	addiw	a5,a5,1
 ca2:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ca4:	00001717          	auipc	a4,0x1
 ca8:	93c72703          	lw	a4,-1732(a4) # 15e0 <num_threads>
 cac:	00f70863          	beq	a4,a5,cbc <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 cb0:	fec42503          	lw	a0,-20(s0)
 cb4:	60e2                	ld	ra,24(sp)
 cb6:	6442                	ld	s0,16(sp)
 cb8:	6105                	addi	sp,sp,32
 cba:	8082                	ret
    free_stacks();
 cbc:	00000097          	auipc	ra,0x0
 cc0:	dd6080e7          	jalr	-554(ra) # a92 <free_stacks>
 cc4:	b7f5                	j	cb0 <ithread_join+0x32>
