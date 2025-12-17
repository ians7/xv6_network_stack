
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
  10:	cc450513          	addi	a0,a0,-828 # cd0 <ithread_join+0x4a>
  14:	00001097          	auipc	ra,0x1
  18:	8b4080e7          	jalr	-1868(ra) # 8c8 <printf>
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
  28:	2be080e7          	jalr	702(ra) # 2e2 <memset>
  server_addr.sin_family = AF_INET;
  2c:	4789                	li	a5,2
  2e:	fcf41823          	sh	a5,-48(s0)
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
  4a:	4589                	li	a1,2
  4c:	852e                	mv	a0,a1
  4e:	00000097          	auipc	ra,0x0
  52:	566080e7          	jalr	1382(ra) # 5b4 <socket>
  if (client_fd < 0) {
  56:	08054b63          	bltz	a0,ec <udp_basic_test+0xec>
  5a:	84aa                	mv	s1,a0
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  5c:	fc040913          	addi	s2,s0,-64
  60:	4641                	li	a2,16
  62:	4581                	li	a1,0
  64:	854a                	mv	a0,s2
  66:	00000097          	auipc	ra,0x0
  6a:	27c080e7          	jalr	636(ra) # 2e2 <memset>
  client_addr.sin_family = AF_INET;
  6e:	4789                	li	a5,2
  70:	fcf41023          	sh	a5,-64(s0)
  client_addr.sin_port = htons(CLIENT_PORT);
  74:	6795                	lui	a5,0x5
  76:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x3810>
  7a:	fcf41123          	sh	a5,-62(s0)
  client_addr.sin_addr.s_addr = INADDR_ANY;
  7e:	4785                	li	a5,1
  80:	fcf42223          	sw	a5,-60(s0)

  if (bind(client_fd, (struct sockaddr *)&client_addr, sizeof(client_addr)) < 0) {
  84:	4641                	li	a2,16
  86:	85ca                	mv	a1,s2
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	532080e7          	jalr	1330(ra) # 5bc <bind>
  92:	06054a63          	bltz	a0,106 <udp_basic_test+0x106>
    printf("client bind failed\n");
    exit(1);
  }

  // --- Client sends message to server
  printf("sending payload\n");
  96:	00001517          	auipc	a0,0x1
  9a:	c8250513          	addi	a0,a0,-894 # d18 <ithread_join+0x92>
  9e:	00001097          	auipc	ra,0x1
  a2:	82a080e7          	jalr	-2006(ra) # 8c8 <printf>
  if (sendto(client_fd, MSG, strlen(MSG), 0,
  a6:	00001517          	auipc	a0,0x1
  aa:	c8a50513          	addi	a0,a0,-886 # d30 <ithread_join+0xaa>
  ae:	00000097          	auipc	ra,0x0
  b2:	208080e7          	jalr	520(ra) # 2b6 <strlen>
  b6:	862a                	mv	a2,a0
  b8:	47c1                	li	a5,16
  ba:	fd040713          	addi	a4,s0,-48
  be:	4681                	li	a3,0
  c0:	00001597          	auipc	a1,0x1
  c4:	c7058593          	addi	a1,a1,-912 # d30 <ithread_join+0xaa>
  c8:	8526                	mv	a0,s1
  ca:	00000097          	auipc	ra,0x0
  ce:	524080e7          	jalr	1316(ra) # 5ee <sendto>
  d2:	04054763          	bltz	a0,120 <udp_basic_test+0x120>
  //   printf("UDP PACKET RECEIVED: \n\t");
  //   printf("%s\n", buf);
  // }

  // close(client_fd);
  close(client_fd);
  d6:	8526                	mv	a0,s1
  d8:	00000097          	auipc	ra,0x0
  dc:	444080e7          	jalr	1092(ra) # 51c <close>
}
  e0:	70e2                	ld	ra,56(sp)
  e2:	7442                	ld	s0,48(sp)
  e4:	74a2                	ld	s1,40(sp)
  e6:	7902                	ld	s2,32(sp)
  e8:	6121                	addi	sp,sp,64
  ea:	8082                	ret
    printf("client socket failed\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	bfc50513          	addi	a0,a0,-1028 # ce8 <ithread_join+0x62>
  f4:	00000097          	auipc	ra,0x0
  f8:	7d4080e7          	jalr	2004(ra) # 8c8 <printf>
    exit(1);
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	3f6080e7          	jalr	1014(ra) # 4f4 <exit>
    printf("client bind failed\n");
 106:	00001517          	auipc	a0,0x1
 10a:	bfa50513          	addi	a0,a0,-1030 # d00 <ithread_join+0x7a>
 10e:	00000097          	auipc	ra,0x0
 112:	7ba080e7          	jalr	1978(ra) # 8c8 <printf>
    exit(1);
 116:	4505                	li	a0,1
 118:	00000097          	auipc	ra,0x0
 11c:	3dc080e7          	jalr	988(ra) # 4f4 <exit>
    printf("sendto failed\n");
 120:	00001517          	auipc	a0,0x1
 124:	c2050513          	addi	a0,a0,-992 # d40 <ithread_join+0xba>
 128:	00000097          	auipc	ra,0x0
 12c:	7a0080e7          	jalr	1952(ra) # 8c8 <printf>
    exit(1);
 130:	4505                	li	a0,1
 132:	00000097          	auipc	ra,0x0
 136:	3c2080e7          	jalr	962(ra) # 4f4 <exit>

000000000000013a <tcp_test3>:
int tcp_test3() {
 13a:	1141                	addi	sp,sp,-16
 13c:	e406                	sd	ra,8(sp)
 13e:	e022                	sd	s0,0(sp)
 140:	0800                	addi	s0,sp,16
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
 142:	4781                	li	a5,0
 144:	4709                	li	a4,2
 146:	c398                	sw	a4,0(a5)
  p->ai_socktype = SOCK_STREAM;
 148:	4705                	li	a4,1
 14a:	c3d8                	sw	a4,4(a5)
  p->ai_protocol = 0;
 14c:	0007a623          	sw	zero,12(a5)
  //   return -1;
  // }
  // 
  // printf("socket_test3: PASSED\n");
  return 0;
}
 150:	4501                	li	a0,0
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <tcp_test2>:

int tcp_test2() {
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	1000                	addi	s0,sp,32
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
 164:	4781                	li	a5,0
 166:	4709                	li	a4,2
 168:	c398                	sw	a4,0(a5)
  p->ai_socktype = SOCK_STREAM;
 16a:	4485                	li	s1,1
 16c:	c3c4                	sw	s1,4(a5)
  p->ai_protocol = 0;
 16e:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
 172:	4601                	li	a2,0
 174:	85a6                	mv	a1,s1
 176:	853a                	mv	a0,a4
 178:	00000097          	auipc	ra,0x0
 17c:	43c080e7          	jalr	1084(ra) # 5b4 <socket>

  if (fd != 1) {
 180:	02951d63          	bne	a0,s1,1ba <tcp_test2+0x60>
    printf("socket_test2: SOCKET FAILED\n");
    return -1;
  }

  if (bind(fd, p->ai_addr, p->ai_addrlen) == -1) {
 184:	4781                	li	a5,0
 186:	4b90                	lw	a2,16(a5)
 188:	6f8c                	ld	a1,24(a5)
 18a:	4505                	li	a0,1
 18c:	00000097          	auipc	ra,0x0
 190:	430080e7          	jalr	1072(ra) # 5bc <bind>
 194:	84aa                	mv	s1,a0
 196:	57fd                	li	a5,-1
 198:	02f50b63          	beq	a0,a5,1ce <tcp_test2+0x74>
    printf("socket_test2: BIND FAILED\n");
    return -1;
  }
  
  printf("socket_test2: PASSED\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	bf450513          	addi	a0,a0,-1036 # d90 <ithread_join+0x10a>
 1a4:	00000097          	auipc	ra,0x0
 1a8:	724080e7          	jalr	1828(ra) # 8c8 <printf>

  return 0;
 1ac:	4481                	li	s1,0
}
 1ae:	8526                	mv	a0,s1
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
    printf("socket_test2: SOCKET FAILED\n");
 1ba:	00001517          	auipc	a0,0x1
 1be:	b9650513          	addi	a0,a0,-1130 # d50 <ithread_join+0xca>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	706080e7          	jalr	1798(ra) # 8c8 <printf>
    return -1;
 1ca:	54fd                	li	s1,-1
 1cc:	b7cd                	j	1ae <tcp_test2+0x54>
    printf("socket_test2: BIND FAILED\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	ba250513          	addi	a0,a0,-1118 # d70 <ithread_join+0xea>
 1d6:	00000097          	auipc	ra,0x0
 1da:	6f2080e7          	jalr	1778(ra) # 8c8 <printf>
    return -1;
 1de:	bfc1                	j	1ae <tcp_test2+0x54>

00000000000001e0 <tcp_test1>:

int tcp_test1() {
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  struct addrinfo hints, *servinfo, *p;
  p->ai_family = AF_INET;
 1e8:	4781                	li	a5,0
 1ea:	4709                	li	a4,2
 1ec:	c398                	sw	a4,0(a5)
  p->ai_socktype = SOCK_STREAM;
 1ee:	4705                	li	a4,1
 1f0:	c3d8                	sw	a4,4(a5)
  p->ai_protocol = 0;
 1f2:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
 1f6:	4601                	li	a2,0
 1f8:	85ba                	mv	a1,a4
 1fa:	4509                	li	a0,2
 1fc:	00000097          	auipc	ra,0x0
 200:	3b8080e7          	jalr	952(ra) # 5b4 <socket>

  if (fd == 0) 
 204:	ed11                	bnez	a0,220 <tcp_test1+0x40>
    printf("socket_test1: PASSED\n");
 206:	00001517          	auipc	a0,0x1
 20a:	ba250513          	addi	a0,a0,-1118 # da8 <ithread_join+0x122>
 20e:	00000097          	auipc	ra,0x0
 212:	6ba080e7          	jalr	1722(ra) # 8c8 <printf>
  else
    printf("socket_test1: FAILED\n");

  return 0;
}
 216:	4501                	li	a0,0
 218:	60a2                	ld	ra,8(sp)
 21a:	6402                	ld	s0,0(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
    printf("socket_test1: FAILED\n");
 220:	00001517          	auipc	a0,0x1
 224:	ba050513          	addi	a0,a0,-1120 # dc0 <ithread_join+0x13a>
 228:	00000097          	auipc	ra,0x0
 22c:	6a0080e7          	jalr	1696(ra) # 8c8 <printf>
 230:	b7dd                	j	216 <tcp_test1+0x36>

0000000000000232 <main>:

int main() {
 232:	1141                	addi	sp,sp,-16
 234:	e406                	sd	ra,8(sp)
 236:	e022                	sd	s0,0(sp)
 238:	0800                	addi	s0,sp,16
  udp_basic_test();
 23a:	00000097          	auipc	ra,0x0
 23e:	dc6080e7          	jalr	-570(ra) # 0 <udp_basic_test>
  // tcp_test1();
  // tcp_test2();
  // tcp_test3();
}
 242:	4501                	li	a0,0
 244:	60a2                	ld	ra,8(sp)
 246:	6402                	ld	s0,0(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  extern int main();
  main();
 254:	00000097          	auipc	ra,0x0
 258:	fde080e7          	jalr	-34(ra) # 232 <main>
  exit(0);
 25c:	4501                	li	a0,0
 25e:	00000097          	auipc	ra,0x0
 262:	296080e7          	jalr	662(ra) # 4f4 <exit>

0000000000000266 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 266:	1141                	addi	sp,sp,-16
 268:	e406                	sd	ra,8(sp)
 26a:	e022                	sd	s0,0(sp)
 26c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 26e:	87aa                	mv	a5,a0
 270:	0585                	addi	a1,a1,1
 272:	0785                	addi	a5,a5,1
 274:	fff5c703          	lbu	a4,-1(a1)
 278:	fee78fa3          	sb	a4,-1(a5)
 27c:	fb75                	bnez	a4,270 <strcpy+0xa>
    ;
  return os;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x20>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x20>
    p++, q++;
 29c:	0505                	addi	a0,a0,1
 29e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strlen>:

uint
strlen(const char *s)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	cf91                	beqz	a5,2de <strlen+0x28>
 2c4:	00150793          	addi	a5,a0,1
 2c8:	86be                	mv	a3,a5
 2ca:	0785                	addi	a5,a5,1
 2cc:	fff7c703          	lbu	a4,-1(a5)
 2d0:	ff65                	bnez	a4,2c8 <strlen+0x12>
 2d2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  for(n = 0; s[n]; n++)
 2de:	4501                	li	a0,0
 2e0:	bfdd                	j	2d6 <strlen+0x20>

00000000000002e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ea:	ca19                	beqz	a2,300 <memset+0x1e>
 2ec:	87aa                	mv	a5,a0
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fa:	0785                	addi	a5,a5,1
 2fc:	fee79de3          	bne	a5,a4,2f6 <memset+0x14>
  }
  return dst;
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strchr>:

char*
strchr(const char *s, char c)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cf81                	beqz	a5,32c <strchr+0x24>
    if(*s == c)
 316:	00f58763          	beq	a1,a5,324 <strchr+0x1c>
  for(; *s; s++)
 31a:	0505                	addi	a0,a0,1
 31c:	00054783          	lbu	a5,0(a0)
 320:	fbfd                	bnez	a5,316 <strchr+0xe>
      return (char*)s;
  return 0;
 322:	4501                	li	a0,0
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfdd                	j	324 <strchr+0x1c>

0000000000000330 <gets>:

char*
gets(char *buf, int max)
{
 330:	711d                	addi	sp,sp,-96
 332:	ec86                	sd	ra,88(sp)
 334:	e8a2                	sd	s0,80(sp)
 336:	e4a6                	sd	s1,72(sp)
 338:	e0ca                	sd	s2,64(sp)
 33a:	fc4e                	sd	s3,56(sp)
 33c:	f852                	sd	s4,48(sp)
 33e:	f456                	sd	s5,40(sp)
 340:	f05a                	sd	s6,32(sp)
 342:	ec5e                	sd	s7,24(sp)
 344:	e862                	sd	s8,16(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 350:	faf40b13          	addi	s6,s0,-81
 354:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 356:	8c26                	mv	s8,s1
 358:	0014899b          	addiw	s3,s1,1
 35c:	84ce                	mv	s1,s3
 35e:	0349d663          	bge	s3,s4,38a <gets+0x5a>
    cc = read(0, &c, 1);
 362:	8656                	mv	a2,s5
 364:	85da                	mv	a1,s6
 366:	4501                	li	a0,0
 368:	00000097          	auipc	ra,0x0
 36c:	1a4080e7          	jalr	420(ra) # 50c <read>
    if(cc < 1)
 370:	00a05d63          	blez	a0,38a <gets+0x5a>
      break;
    buf[i++] = c;
 374:	faf44783          	lbu	a5,-81(s0)
 378:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37c:	0905                	addi	s2,s2,1
 37e:	ff678713          	addi	a4,a5,-10
 382:	c319                	beqz	a4,388 <gets+0x58>
 384:	17cd                	addi	a5,a5,-13
 386:	fbe1                	bnez	a5,356 <gets+0x26>
    buf[i++] = c;
 388:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38a:	9c5e                	add	s8,s8,s7
 38c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 390:	855e                	mv	a0,s7
 392:	60e6                	ld	ra,88(sp)
 394:	6446                	ld	s0,80(sp)
 396:	64a6                	ld	s1,72(sp)
 398:	6906                	ld	s2,64(sp)
 39a:	79e2                	ld	s3,56(sp)
 39c:	7a42                	ld	s4,48(sp)
 39e:	7aa2                	ld	s5,40(sp)
 3a0:	7b02                	ld	s6,32(sp)
 3a2:	6be2                	ld	s7,24(sp)
 3a4:	6c42                	ld	s8,16(sp)
 3a6:	6125                	addi	sp,sp,96
 3a8:	8082                	ret

00000000000003aa <stat>:

int
stat(const char *n, struct stat *st)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	4581                	li	a1,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	17c080e7          	jalr	380(ra) # 534 <open>
  if(fd < 0)
 3c0:	02054663          	bltz	a0,3ec <stat+0x42>
 3c4:	e426                	sd	s1,8(sp)
 3c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c8:	85ca                	mv	a1,s2
 3ca:	00000097          	auipc	ra,0x0
 3ce:	182080e7          	jalr	386(ra) # 54c <fstat>
 3d2:	892a                	mv	s2,a0
  close(fd);
 3d4:	8526                	mv	a0,s1
 3d6:	00000097          	auipc	ra,0x0
 3da:	146080e7          	jalr	326(ra) # 51c <close>
  return r;
 3de:	64a2                	ld	s1,8(sp)
}
 3e0:	854a                	mv	a0,s2
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6902                	ld	s2,0(sp)
 3e8:	6105                	addi	sp,sp,32
 3ea:	8082                	ret
    return -1;
 3ec:	57fd                	li	a5,-1
 3ee:	893e                	mv	s2,a5
 3f0:	bfc5                	j	3e0 <stat+0x36>

00000000000003f2 <atoi>:

int
atoi(const char *s)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fa:	00054683          	lbu	a3,0(a0)
 3fe:	fd06879b          	addiw	a5,a3,-48
 402:	0ff7f793          	zext.b	a5,a5
 406:	4625                	li	a2,9
 408:	02f66963          	bltu	a2,a5,43a <atoi+0x48>
 40c:	872a                	mv	a4,a0
  n = 0;
 40e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 410:	0705                	addi	a4,a4,1
 412:	0025179b          	slliw	a5,a0,0x2
 416:	9fa9                	addw	a5,a5,a0
 418:	0017979b          	slliw	a5,a5,0x1
 41c:	9fb5                	addw	a5,a5,a3
 41e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 422:	00074683          	lbu	a3,0(a4)
 426:	fd06879b          	addiw	a5,a3,-48
 42a:	0ff7f793          	zext.b	a5,a5
 42e:	fef671e3          	bgeu	a2,a5,410 <atoi+0x1e>
  return n;
}
 432:	60a2                	ld	ra,8(sp)
 434:	6402                	ld	s0,0(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret
  n = 0;
 43a:	4501                	li	a0,0
 43c:	bfdd                	j	432 <atoi+0x40>

000000000000043e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e406                	sd	ra,8(sp)
 442:	e022                	sd	s0,0(sp)
 444:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 446:	02b57563          	bgeu	a0,a1,470 <memmove+0x32>
    while(n-- > 0)
 44a:	00c05f63          	blez	a2,468 <memmove+0x2a>
 44e:	1602                	slli	a2,a2,0x20
 450:	9201                	srli	a2,a2,0x20
 452:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 456:	872a                	mv	a4,a0
      *dst++ = *src++;
 458:	0585                	addi	a1,a1,1
 45a:	0705                	addi	a4,a4,1
 45c:	fff5c683          	lbu	a3,-1(a1)
 460:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 464:	fee79ae3          	bne	a5,a4,458 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 468:	60a2                	ld	ra,8(sp)
 46a:	6402                	ld	s0,0(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
    while(n-- > 0)
 470:	fec05ce3          	blez	a2,468 <memmove+0x2a>
    dst += n;
 474:	00c50733          	add	a4,a0,a2
    src += n;
 478:	95b2                	add	a1,a1,a2
 47a:	fff6079b          	addiw	a5,a2,-1
 47e:	1782                	slli	a5,a5,0x20
 480:	9381                	srli	a5,a5,0x20
 482:	fff7c793          	not	a5,a5
 486:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 488:	15fd                	addi	a1,a1,-1
 48a:	177d                	addi	a4,a4,-1
 48c:	0005c683          	lbu	a3,0(a1)
 490:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 494:	fef71ae3          	bne	a4,a5,488 <memmove+0x4a>
 498:	bfc1                	j	468 <memmove+0x2a>

000000000000049a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a2:	c61d                	beqz	a2,4d0 <memcmp+0x36>
 4a4:	1602                	slli	a2,a2,0x20
 4a6:	9201                	srli	a2,a2,0x20
 4a8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	0005c703          	lbu	a4,0(a1)
 4b4:	00e79863          	bne	a5,a4,4c4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4b8:	0505                	addi	a0,a0,1
    p2++;
 4ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4bc:	fed518e3          	bne	a0,a3,4ac <memcmp+0x12>
  }
  return 0;
 4c0:	4501                	li	a0,0
 4c2:	a019                	j	4c8 <memcmp+0x2e>
      return *p1 - *p2;
 4c4:	40e7853b          	subw	a0,a5,a4
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret
  return 0;
 4d0:	4501                	li	a0,0
 4d2:	bfdd                	j	4c8 <memcmp+0x2e>

00000000000004d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f62080e7          	jalr	-158(ra) # 43e <memmove>
}
 4e4:	60a2                	ld	ra,8(sp)
 4e6:	6402                	ld	s0,0(sp)
 4e8:	0141                	addi	sp,sp,16
 4ea:	8082                	ret

00000000000004ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ec:	4885                	li	a7,1
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f4:	4889                	li	a7,2
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fc:	488d                	li	a7,3
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 504:	4891                	li	a7,4
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <read>:
.global read
read:
 li a7, SYS_read
 50c:	4895                	li	a7,5
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <write>:
.global write
write:
 li a7, SYS_write
 514:	48c1                	li	a7,16
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <close>:
.global close
close:
 li a7, SYS_close
 51c:	48d5                	li	a7,21
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <kill>:
.global kill
kill:
 li a7, SYS_kill
 524:	4899                	li	a7,6
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <exec>:
.global exec
exec:
 li a7, SYS_exec
 52c:	489d                	li	a7,7
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <open>:
.global open
open:
 li a7, SYS_open
 534:	48bd                	li	a7,15
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53c:	48c5                	li	a7,17
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 544:	48c9                	li	a7,18
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54c:	48a1                	li	a7,8
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <link>:
.global link
link:
 li a7, SYS_link
 554:	48cd                	li	a7,19
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55c:	48d1                	li	a7,20
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 564:	48a5                	li	a7,9
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <dup>:
.global dup
dup:
 li a7, SYS_dup
 56c:	48a9                	li	a7,10
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 574:	48ad                	li	a7,11
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 57c:	48b1                	li	a7,12
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 584:	48b5                	li	a7,13
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58c:	48b9                	li	a7,14
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 594:	48d9                	li	a7,22
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 59c:	48dd                	li	a7,23
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 5a4:	48e1                	li	a7,24
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 5ac:	48e5                	li	a7,25
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 5b4:	48e9                	li	a7,26
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <bind>:
.global bind
bind:
 li a7, SYS_bind
 5bc:	48ed                	li	a7,27
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 5c4:	48f5                	li	a7,29
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <listen>:
.global listen
listen:
 li a7, SYS_listen
 5cc:	48f1                	li	a7,28
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 5d4:	48f9                	li	a7,30
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <send>:
.global send
send:
 li a7, SYS_send
 5dc:	48fd                	li	a7,31
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 5e4:	02000893          	li	a7,32
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 5ee:	02100893          	li	a7,33
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 5f8:	02200893          	li	a7,34
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 602:	1101                	addi	sp,sp,-32
 604:	ec06                	sd	ra,24(sp)
 606:	e822                	sd	s0,16(sp)
 608:	1000                	addi	s0,sp,32
 60a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 60e:	4605                	li	a2,1
 610:	fef40593          	addi	a1,s0,-17
 614:	00000097          	auipc	ra,0x0
 618:	f00080e7          	jalr	-256(ra) # 514 <write>
}
 61c:	60e2                	ld	ra,24(sp)
 61e:	6442                	ld	s0,16(sp)
 620:	6105                	addi	sp,sp,32
 622:	8082                	ret

0000000000000624 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 624:	7139                	addi	sp,sp,-64
 626:	fc06                	sd	ra,56(sp)
 628:	f822                	sd	s0,48(sp)
 62a:	f04a                	sd	s2,32(sp)
 62c:	ec4e                	sd	s3,24(sp)
 62e:	0080                	addi	s0,sp,64
 630:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 632:	cad9                	beqz	a3,6c8 <printint+0xa4>
 634:	01f5d79b          	srliw	a5,a1,0x1f
 638:	cbc1                	beqz	a5,6c8 <printint+0xa4>
    neg = 1;
    x = -xx;
 63a:	40b005bb          	negw	a1,a1
    neg = 1;
 63e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 640:	fc040993          	addi	s3,s0,-64
  neg = 0;
 644:	86ce                	mv	a3,s3
  i = 0;
 646:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 648:	00001817          	auipc	a6,0x1
 64c:	82080813          	addi	a6,a6,-2016 # e68 <digits>
 650:	88ba                	mv	a7,a4
 652:	0017051b          	addiw	a0,a4,1
 656:	872a                	mv	a4,a0
 658:	02c5f7bb          	remuw	a5,a1,a2
 65c:	1782                	slli	a5,a5,0x20
 65e:	9381                	srli	a5,a5,0x20
 660:	97c2                	add	a5,a5,a6
 662:	0007c783          	lbu	a5,0(a5)
 666:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66a:	87ae                	mv	a5,a1
 66c:	02c5d5bb          	divuw	a1,a1,a2
 670:	0685                	addi	a3,a3,1
 672:	fcc7ffe3          	bgeu	a5,a2,650 <printint+0x2c>
  if(neg)
 676:	00030c63          	beqz	t1,68e <printint+0x6a>
    buf[i++] = '-';
 67a:	fd050793          	addi	a5,a0,-48
 67e:	00878533          	add	a0,a5,s0
 682:	02d00793          	li	a5,45
 686:	fef50823          	sb	a5,-16(a0)
 68a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 68e:	02e05763          	blez	a4,6bc <printint+0x98>
 692:	f426                	sd	s1,40(sp)
 694:	377d                	addiw	a4,a4,-1
 696:	00e984b3          	add	s1,s3,a4
 69a:	19fd                	addi	s3,s3,-1
 69c:	99ba                	add	s3,s3,a4
 69e:	1702                	slli	a4,a4,0x20
 6a0:	9301                	srli	a4,a4,0x20
 6a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a6:	0004c583          	lbu	a1,0(s1)
 6aa:	854a                	mv	a0,s2
 6ac:	00000097          	auipc	ra,0x0
 6b0:	f56080e7          	jalr	-170(ra) # 602 <putc>
  while(--i >= 0)
 6b4:	14fd                	addi	s1,s1,-1
 6b6:	ff3498e3          	bne	s1,s3,6a6 <printint+0x82>
 6ba:	74a2                	ld	s1,40(sp)
}
 6bc:	70e2                	ld	ra,56(sp)
 6be:	7442                	ld	s0,48(sp)
 6c0:	7902                	ld	s2,32(sp)
 6c2:	69e2                	ld	s3,24(sp)
 6c4:	6121                	addi	sp,sp,64
 6c6:	8082                	ret
  neg = 0;
 6c8:	4301                	li	t1,0
 6ca:	bf9d                	j	640 <printint+0x1c>

00000000000006cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6cc:	715d                	addi	sp,sp,-80
 6ce:	e486                	sd	ra,72(sp)
 6d0:	e0a2                	sd	s0,64(sp)
 6d2:	f84a                	sd	s2,48(sp)
 6d4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d6:	0005c903          	lbu	s2,0(a1)
 6da:	1a090b63          	beqz	s2,890 <vprintf+0x1c4>
 6de:	fc26                	sd	s1,56(sp)
 6e0:	f44e                	sd	s3,40(sp)
 6e2:	f052                	sd	s4,32(sp)
 6e4:	ec56                	sd	s5,24(sp)
 6e6:	e85a                	sd	s6,16(sp)
 6e8:	e45e                	sd	s7,8(sp)
 6ea:	8aaa                	mv	s5,a0
 6ec:	8bb2                	mv	s7,a2
 6ee:	00158493          	addi	s1,a1,1
  state = 0;
 6f2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6f4:	02500a13          	li	s4,37
 6f8:	4b55                	li	s6,21
 6fa:	a839                	j	718 <vprintf+0x4c>
        putc(fd, c);
 6fc:	85ca                	mv	a1,s2
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	f02080e7          	jalr	-254(ra) # 602 <putc>
 708:	a019                	j	70e <vprintf+0x42>
    } else if(state == '%'){
 70a:	01498d63          	beq	s3,s4,724 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 70e:	0485                	addi	s1,s1,1
 710:	fff4c903          	lbu	s2,-1(s1)
 714:	16090863          	beqz	s2,884 <vprintf+0x1b8>
    if(state == 0){
 718:	fe0999e3          	bnez	s3,70a <vprintf+0x3e>
      if(c == '%'){
 71c:	ff4910e3          	bne	s2,s4,6fc <vprintf+0x30>
        state = '%';
 720:	89d2                	mv	s3,s4
 722:	b7f5                	j	70e <vprintf+0x42>
      if(c == 'd'){
 724:	13490563          	beq	s2,s4,84e <vprintf+0x182>
 728:	f9d9079b          	addiw	a5,s2,-99
 72c:	0ff7f793          	zext.b	a5,a5
 730:	12fb6863          	bltu	s6,a5,860 <vprintf+0x194>
 734:	f9d9079b          	addiw	a5,s2,-99
 738:	0ff7f713          	zext.b	a4,a5
 73c:	12eb6263          	bltu	s6,a4,860 <vprintf+0x194>
 740:	00271793          	slli	a5,a4,0x2
 744:	00000717          	auipc	a4,0x0
 748:	6cc70713          	addi	a4,a4,1740 # e10 <ithread_join+0x18a>
 74c:	97ba                	add	a5,a5,a4
 74e:	439c                	lw	a5,0(a5)
 750:	97ba                	add	a5,a5,a4
 752:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 754:	008b8913          	addi	s2,s7,8
 758:	4685                	li	a3,1
 75a:	4629                	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	ec2080e7          	jalr	-318(ra) # 624 <printint>
 76a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b745                	j	70e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	ea6080e7          	jalr	-346(ra) # 624 <printint>
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	b751                	j	70e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 78c:	008b8913          	addi	s2,s7,8
 790:	4681                	li	a3,0
 792:	4641                	li	a2,16
 794:	000ba583          	lw	a1,0(s7)
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e8a080e7          	jalr	-374(ra) # 624 <printint>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b7a5                	j	70e <vprintf+0x42>
 7a8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7aa:	008b8793          	addi	a5,s7,8
 7ae:	8c3e                	mv	s8,a5
 7b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b4:	03000593          	li	a1,48
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e48080e7          	jalr	-440(ra) # 602 <putc>
  putc(fd, 'x');
 7c2:	07800593          	li	a1,120
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e3a080e7          	jalr	-454(ra) # 602 <putc>
 7d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d2:	00000b97          	auipc	s7,0x0
 7d6:	696b8b93          	addi	s7,s7,1686 # e68 <digits>
 7da:	03c9d793          	srli	a5,s3,0x3c
 7de:	97de                	add	a5,a5,s7
 7e0:	0007c583          	lbu	a1,0(a5)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e1c080e7          	jalr	-484(ra) # 602 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ee:	0992                	slli	s3,s3,0x4
 7f0:	397d                	addiw	s2,s2,-1
 7f2:	fe0914e3          	bnez	s2,7da <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 7f6:	8be2                	mv	s7,s8
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	6c02                	ld	s8,0(sp)
 7fc:	bf09                	j	70e <vprintf+0x42>
        s = va_arg(ap, char*);
 7fe:	008b8993          	addi	s3,s7,8
 802:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 806:	02090163          	beqz	s2,828 <vprintf+0x15c>
        while(*s != 0){
 80a:	00094583          	lbu	a1,0(s2)
 80e:	c9a5                	beqz	a1,87e <vprintf+0x1b2>
          putc(fd, *s);
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	df0080e7          	jalr	-528(ra) # 602 <putc>
          s++;
 81a:	0905                	addi	s2,s2,1
        while(*s != 0){
 81c:	00094583          	lbu	a1,0(s2)
 820:	f9e5                	bnez	a1,810 <vprintf+0x144>
        s = va_arg(ap, char*);
 822:	8bce                	mv	s7,s3
      state = 0;
 824:	4981                	li	s3,0
 826:	b5e5                	j	70e <vprintf+0x42>
          s = "(null)";
 828:	00000917          	auipc	s2,0x0
 82c:	5b090913          	addi	s2,s2,1456 # dd8 <ithread_join+0x152>
        while(*s != 0){
 830:	02800593          	li	a1,40
 834:	bff1                	j	810 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 836:	008b8913          	addi	s2,s7,8
 83a:	000bc583          	lbu	a1,0(s7)
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	dc2080e7          	jalr	-574(ra) # 602 <putc>
 848:	8bca                	mv	s7,s2
      state = 0;
 84a:	4981                	li	s3,0
 84c:	b5c9                	j	70e <vprintf+0x42>
        putc(fd, c);
 84e:	02500593          	li	a1,37
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	dae080e7          	jalr	-594(ra) # 602 <putc>
      state = 0;
 85c:	4981                	li	s3,0
 85e:	bd45                	j	70e <vprintf+0x42>
        putc(fd, '%');
 860:	02500593          	li	a1,37
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	d9c080e7          	jalr	-612(ra) # 602 <putc>
        putc(fd, c);
 86e:	85ca                	mv	a1,s2
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	d90080e7          	jalr	-624(ra) # 602 <putc>
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bd49                	j	70e <vprintf+0x42>
        s = va_arg(ap, char*);
 87e:	8bce                	mv	s7,s3
      state = 0;
 880:	4981                	li	s3,0
 882:	b571                	j	70e <vprintf+0x42>
 884:	74e2                	ld	s1,56(sp)
 886:	79a2                	ld	s3,40(sp)
 888:	7a02                	ld	s4,32(sp)
 88a:	6ae2                	ld	s5,24(sp)
 88c:	6b42                	ld	s6,16(sp)
 88e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 890:	60a6                	ld	ra,72(sp)
 892:	6406                	ld	s0,64(sp)
 894:	7942                	ld	s2,48(sp)
 896:	6161                	addi	sp,sp,80
 898:	8082                	ret

000000000000089a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89a:	715d                	addi	sp,sp,-80
 89c:	ec06                	sd	ra,24(sp)
 89e:	e822                	sd	s0,16(sp)
 8a0:	1000                	addi	s0,sp,32
 8a2:	e010                	sd	a2,0(s0)
 8a4:	e414                	sd	a3,8(s0)
 8a6:	e818                	sd	a4,16(s0)
 8a8:	ec1c                	sd	a5,24(s0)
 8aa:	03043023          	sd	a6,32(s0)
 8ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	8622                	mv	a2,s0
 8b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e14080e7          	jalr	-492(ra) # 6cc <vprintf>
}
 8c0:	60e2                	ld	ra,24(sp)
 8c2:	6442                	ld	s0,16(sp)
 8c4:	6161                	addi	sp,sp,80
 8c6:	8082                	ret

00000000000008c8 <printf>:

void
printf(const char *fmt, ...)
{
 8c8:	711d                	addi	sp,sp,-96
 8ca:	ec06                	sd	ra,24(sp)
 8cc:	e822                	sd	s0,16(sp)
 8ce:	1000                	addi	s0,sp,32
 8d0:	e40c                	sd	a1,8(s0)
 8d2:	e810                	sd	a2,16(s0)
 8d4:	ec14                	sd	a3,24(s0)
 8d6:	f018                	sd	a4,32(s0)
 8d8:	f41c                	sd	a5,40(s0)
 8da:	03043823          	sd	a6,48(s0)
 8de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	00840613          	addi	a2,s0,8
 8e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ea:	85aa                	mv	a1,a0
 8ec:	4505                	li	a0,1
 8ee:	00000097          	auipc	ra,0x0
 8f2:	dde080e7          	jalr	-546(ra) # 6cc <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6125                	addi	sp,sp,96
 8fc:	8082                	ret

00000000000008fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fe:	1141                	addi	sp,sp,-16
 900:	e406                	sd	ra,8(sp)
 902:	e022                	sd	s0,0(sp)
 904:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 906:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	00001797          	auipc	a5,0x1
 90e:	cc67b783          	ld	a5,-826(a5) # 15d0 <freep>
 912:	a039                	j	920 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	6398                	ld	a4,0(a5)
 916:	00e7e463          	bltu	a5,a4,91e <free+0x20>
 91a:	00e6ea63          	bltu	a3,a4,92e <free+0x30>
{
 91e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	fed7fae3          	bgeu	a5,a3,914 <free+0x16>
 924:	6398                	ld	a4,0(a5)
 926:	00e6e463          	bltu	a3,a4,92e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	fee7eae3          	bltu	a5,a4,91e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 92e:	ff852583          	lw	a1,-8(a0)
 932:	6390                	ld	a2,0(a5)
 934:	02059813          	slli	a6,a1,0x20
 938:	01c85713          	srli	a4,a6,0x1c
 93c:	9736                	add	a4,a4,a3
 93e:	02e60563          	beq	a2,a4,968 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 946:	4790                	lw	a2,8(a5)
 948:	02061593          	slli	a1,a2,0x20
 94c:	01c5d713          	srli	a4,a1,0x1c
 950:	973e                	add	a4,a4,a5
 952:	02e68263          	beq	a3,a4,976 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 956:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 958:	00001717          	auipc	a4,0x1
 95c:	c6f73c23          	sd	a5,-904(a4) # 15d0 <freep>
}
 960:	60a2                	ld	ra,8(sp)
 962:	6402                	ld	s0,0(sp)
 964:	0141                	addi	sp,sp,16
 966:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 968:	4618                	lw	a4,8(a2)
 96a:	9f2d                	addw	a4,a4,a1
 96c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	6310                	ld	a2,0(a4)
 974:	b7f9                	j	942 <free+0x44>
    p->s.size += bp->s.size;
 976:	ff852703          	lw	a4,-8(a0)
 97a:	9f31                	addw	a4,a4,a2
 97c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 97e:	ff053683          	ld	a3,-16(a0)
 982:	bfd1                	j	956 <free+0x58>

0000000000000984 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 984:	7139                	addi	sp,sp,-64
 986:	fc06                	sd	ra,56(sp)
 988:	f822                	sd	s0,48(sp)
 98a:	f04a                	sd	s2,32(sp)
 98c:	ec4e                	sd	s3,24(sp)
 98e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 990:	02051993          	slli	s3,a0,0x20
 994:	0209d993          	srli	s3,s3,0x20
 998:	09bd                	addi	s3,s3,15
 99a:	0049d993          	srli	s3,s3,0x4
 99e:	2985                	addiw	s3,s3,1
 9a0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9a2:	00001517          	auipc	a0,0x1
 9a6:	c2e53503          	ld	a0,-978(a0) # 15d0 <freep>
 9aa:	c905                	beqz	a0,9da <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ae:	4798                	lw	a4,8(a5)
 9b0:	09377a63          	bgeu	a4,s3,a44 <malloc+0xc0>
 9b4:	f426                	sd	s1,40(sp)
 9b6:	e852                	sd	s4,16(sp)
 9b8:	e456                	sd	s5,8(sp)
 9ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9bc:	8a4e                	mv	s4,s3
 9be:	6705                	lui	a4,0x1
 9c0:	00e9f363          	bgeu	s3,a4,9c6 <malloc+0x42>
 9c4:	6a05                	lui	s4,0x1
 9c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ce:	00001497          	auipc	s1,0x1
 9d2:	c0248493          	addi	s1,s1,-1022 # 15d0 <freep>
  if(p == (char*)-1)
 9d6:	5afd                	li	s5,-1
 9d8:	a089                	j	a1a <malloc+0x96>
 9da:	f426                	sd	s1,40(sp)
 9dc:	e852                	sd	s4,16(sp)
 9de:	e456                	sd	s5,8(sp)
 9e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e2:	00001797          	auipc	a5,0x1
 9e6:	c0e78793          	addi	a5,a5,-1010 # 15f0 <base>
 9ea:	00001717          	auipc	a4,0x1
 9ee:	bef73323          	sd	a5,-1050(a4) # 15d0 <freep>
 9f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f8:	b7d1                	j	9bc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9fa:	6398                	ld	a4,0(a5)
 9fc:	e118                	sd	a4,0(a0)
 9fe:	a8b9                	j	a5c <malloc+0xd8>
  hp->s.size = nu;
 a00:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a04:	0541                	addi	a0,a0,16
 a06:	00000097          	auipc	ra,0x0
 a0a:	ef8080e7          	jalr	-264(ra) # 8fe <free>
  return freep;
 a0e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a10:	c135                	beqz	a0,a74 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	03277363          	bgeu	a4,s2,a3c <malloc+0xb8>
    if(p == freep)
 a1a:	6098                	ld	a4,0(s1)
 a1c:	853e                	mv	a0,a5
 a1e:	fef71ae3          	bne	a4,a5,a12 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a22:	8552                	mv	a0,s4
 a24:	00000097          	auipc	ra,0x0
 a28:	b58080e7          	jalr	-1192(ra) # 57c <sbrk>
  if(p == (char*)-1)
 a2c:	fd551ae3          	bne	a0,s5,a00 <malloc+0x7c>
        return 0;
 a30:	4501                	li	a0,0
 a32:	74a2                	ld	s1,40(sp)
 a34:	6a42                	ld	s4,16(sp)
 a36:	6aa2                	ld	s5,8(sp)
 a38:	6b02                	ld	s6,0(sp)
 a3a:	a03d                	j	a68 <malloc+0xe4>
 a3c:	74a2                	ld	s1,40(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a44:	fae90be3          	beq	s2,a4,9fa <malloc+0x76>
        p->s.size -= nunits;
 a48:	4137073b          	subw	a4,a4,s3
 a4c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4e:	02071693          	slli	a3,a4,0x20
 a52:	01c6d713          	srli	a4,a3,0x1c
 a56:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a58:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5c:	00001717          	auipc	a4,0x1
 a60:	b6a73a23          	sd	a0,-1164(a4) # 15d0 <freep>
      return (void*)(p + 1);
 a64:	01078513          	addi	a0,a5,16
  }
}
 a68:	70e2                	ld	ra,56(sp)
 a6a:	7442                	ld	s0,48(sp)
 a6c:	7902                	ld	s2,32(sp)
 a6e:	69e2                	ld	s3,24(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
 a74:	74a2                	ld	s1,40(sp)
 a76:	6a42                	ld	s4,16(sp)
 a78:	6aa2                	ld	s5,8(sp)
 a7a:	6b02                	ld	s6,0(sp)
 a7c:	b7f5                	j	a68 <malloc+0xe4>

0000000000000a7e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a7e:	1141                	addi	sp,sp,-16
 a80:	e406                	sd	ra,8(sp)
 a82:	e022                	sd	s0,0(sp)
 a84:	0800                	addi	s0,sp,16
  thread_exit(status);
 a86:	2501                	sext.w	a0,a0
 a88:	00000097          	auipc	ra,0x0
 a8c:	b24080e7          	jalr	-1244(ra) # 5ac <thread_exit>
}
 a90:	60a2                	ld	ra,8(sp)
 a92:	6402                	ld	s0,0(sp)
 a94:	0141                	addi	sp,sp,16
 a96:	8082                	ret

0000000000000a98 <free_stacks>:
int free_stacks() {
 a98:	7179                	addi	sp,sp,-48
 a9a:	f406                	sd	ra,40(sp)
 a9c:	f022                	sd	s0,32(sp)
 a9e:	ec26                	sd	s1,24(sp)
 aa0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 aa2:	00001797          	auipc	a5,0x1
 aa6:	b3e7a783          	lw	a5,-1218(a5) # 15e0 <num_threads>
 aaa:	04f05063          	blez	a5,aea <free_stacks+0x52>
 aae:	e84a                	sd	s2,16(sp)
 ab0:	e44e                	sd	s3,8(sp)
 ab2:	4481                	li	s1,0
    free(stacks[i]);
 ab4:	00001997          	auipc	s3,0x1
 ab8:	b2498993          	addi	s3,s3,-1244 # 15d8 <stacks>
  for (int i = 0; i < num_threads; i++) {
 abc:	00001917          	auipc	s2,0x1
 ac0:	b2490913          	addi	s2,s2,-1244 # 15e0 <num_threads>
    free(stacks[i]);
 ac4:	0009b783          	ld	a5,0(s3)
 ac8:	00349713          	slli	a4,s1,0x3
 acc:	97ba                	add	a5,a5,a4
 ace:	6388                	ld	a0,0(a5)
 ad0:	00000097          	auipc	ra,0x0
 ad4:	e2e080e7          	jalr	-466(ra) # 8fe <free>
  for (int i = 0; i < num_threads; i++) {
 ad8:	0485                	addi	s1,s1,1
 ada:	00092703          	lw	a4,0(s2)
 ade:	0004879b          	sext.w	a5,s1
 ae2:	fee7c1e3          	blt	a5,a4,ac4 <free_stacks+0x2c>
 ae6:	6942                	ld	s2,16(sp)
 ae8:	69a2                	ld	s3,8(sp)
  free(stacks);
 aea:	00001497          	auipc	s1,0x1
 aee:	aee48493          	addi	s1,s1,-1298 # 15d8 <stacks>
 af2:	6088                	ld	a0,0(s1)
 af4:	00000097          	auipc	ra,0x0
 af8:	e0a080e7          	jalr	-502(ra) # 8fe <free>
  stacks = 0;
 afc:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b00:	00001797          	auipc	a5,0x1
 b04:	ae07a023          	sw	zero,-1312(a5) # 15e0 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b08:	47a1                	li	a5,8
 b0a:	00001717          	auipc	a4,0x1
 b0e:	aaf72b23          	sw	a5,-1354(a4) # 15c0 <max_stacks>
  threads_done = 0;
 b12:	00001797          	auipc	a5,0x1
 b16:	ac07a923          	sw	zero,-1326(a5) # 15e4 <threads_done>
}
 b1a:	4501                	li	a0,0
 b1c:	70a2                	ld	ra,40(sp)
 b1e:	7402                	ld	s0,32(sp)
 b20:	64e2                	ld	s1,24(sp)
 b22:	6145                	addi	sp,sp,48
 b24:	8082                	ret

0000000000000b26 <expand_num_threads>:
int expand_num_threads() {
 b26:	1101                	addi	sp,sp,-32
 b28:	ec06                	sd	ra,24(sp)
 b2a:	e822                	sd	s0,16(sp)
 b2c:	e426                	sd	s1,8(sp)
 b2e:	e04a                	sd	s2,0(sp)
 b30:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b32:	00001797          	auipc	a5,0x1
 b36:	a8e78793          	addi	a5,a5,-1394 # 15c0 <max_stacks>
 b3a:	4388                	lw	a0,0(a5)
 b3c:	0015151b          	slliw	a0,a0,0x1
 b40:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b42:	0035151b          	slliw	a0,a0,0x3
 b46:	00000097          	auipc	ra,0x0
 b4a:	e3e080e7          	jalr	-450(ra) # 984 <malloc>
 b4e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b50:	00001617          	auipc	a2,0x1
 b54:	a9062603          	lw	a2,-1392(a2) # 15e0 <num_threads>
 b58:	00001497          	auipc	s1,0x1
 b5c:	a8048493          	addi	s1,s1,-1408 # 15d8 <stacks>
 b60:	0036161b          	slliw	a2,a2,0x3
 b64:	608c                	ld	a1,0(s1)
 b66:	00000097          	auipc	ra,0x0
 b6a:	8d8080e7          	jalr	-1832(ra) # 43e <memmove>
  free(stacks);
 b6e:	6088                	ld	a0,0(s1)
 b70:	00000097          	auipc	ra,0x0
 b74:	d8e080e7          	jalr	-626(ra) # 8fe <free>
  stacks = new_stacks;
 b78:	0124b023          	sd	s2,0(s1)
}
 b7c:	4501                	li	a0,0
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	64a2                	ld	s1,8(sp)
 b84:	6902                	ld	s2,0(sp)
 b86:	6105                	addi	sp,sp,32
 b88:	8082                	ret

0000000000000b8a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b8a:	7179                	addi	sp,sp,-48
 b8c:	f406                	sd	ra,40(sp)
 b8e:	f022                	sd	s0,32(sp)
 b90:	e84a                	sd	s2,16(sp)
 b92:	e44e                	sd	s3,8(sp)
 b94:	1800                	addi	s0,sp,48
 b96:	892a                	mv	s2,a0
 b98:	89ae                	mv	s3,a1
  if (stacks == 0) {
 b9a:	00001797          	auipc	a5,0x1
 b9e:	a3e7b783          	ld	a5,-1474(a5) # 15d8 <stacks>
 ba2:	c3d9                	beqz	a5,c28 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ba4:	00001797          	auipc	a5,0x1
 ba8:	a1c7a783          	lw	a5,-1508(a5) # 15c0 <max_stacks>
 bac:	00001717          	auipc	a4,0x1
 bb0:	a3472703          	lw	a4,-1484(a4) # 15e0 <num_threads>
 bb4:	0af71463          	bne	a4,a5,c5c <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 bb8:	04000713          	li	a4,64
 bbc:	08e78563          	beq	a5,a4,c46 <ithread_create+0xbc>
 bc0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 bc2:	00000097          	auipc	ra,0x0
 bc6:	f64080e7          	jalr	-156(ra) # b26 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 bca:	6505                	lui	a0,0x1
 bcc:	00000097          	auipc	ra,0x0
 bd0:	db8080e7          	jalr	-584(ra) # 984 <malloc>
 bd4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 bd6:	00001717          	auipc	a4,0x1
 bda:	a0a72703          	lw	a4,-1526(a4) # 15e0 <num_threads>
 bde:	070e                	slli	a4,a4,0x3
 be0:	00001797          	auipc	a5,0x1
 be4:	9f87b783          	ld	a5,-1544(a5) # 15d8 <stacks>
 be8:	97ba                	add	a5,a5,a4
 bea:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 bec:	00000697          	auipc	a3,0x0
 bf0:	e9268693          	addi	a3,a3,-366 # a7e <ithread_exit>
 bf4:	862a                	mv	a2,a0
 bf6:	85ce                	mv	a1,s3
 bf8:	854a                	mv	a0,s2
 bfa:	00000097          	auipc	ra,0x0
 bfe:	9a2080e7          	jalr	-1630(ra) # 59c <create_thread>
 c02:	892a                	mv	s2,a0
  if (res != -1) {
 c04:	57fd                	li	a5,-1
 c06:	04f50d63          	beq	a0,a5,c60 <ithread_create+0xd6>
    num_threads++;
 c0a:	00001717          	auipc	a4,0x1
 c0e:	9d670713          	addi	a4,a4,-1578 # 15e0 <num_threads>
 c12:	431c                	lw	a5,0(a4)
 c14:	2785                	addiw	a5,a5,1
 c16:	c31c                	sw	a5,0(a4)
 c18:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c1a:	854a                	mv	a0,s2
 c1c:	70a2                	ld	ra,40(sp)
 c1e:	7402                	ld	s0,32(sp)
 c20:	6942                	ld	s2,16(sp)
 c22:	69a2                	ld	s3,8(sp)
 c24:	6145                	addi	sp,sp,48
 c26:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c28:	00001517          	auipc	a0,0x1
 c2c:	99852503          	lw	a0,-1640(a0) # 15c0 <max_stacks>
 c30:	0035151b          	slliw	a0,a0,0x3
 c34:	00000097          	auipc	ra,0x0
 c38:	d50080e7          	jalr	-688(ra) # 984 <malloc>
 c3c:	00001797          	auipc	a5,0x1
 c40:	98a7be23          	sd	a0,-1636(a5) # 15d8 <stacks>
 c44:	b785                	j	ba4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c46:	00000517          	auipc	a0,0x0
 c4a:	19a50513          	addi	a0,a0,410 # de0 <ithread_join+0x15a>
 c4e:	00000097          	auipc	ra,0x0
 c52:	c7a080e7          	jalr	-902(ra) # 8c8 <printf>
      return -1;
 c56:	57fd                	li	a5,-1
 c58:	893e                	mv	s2,a5
 c5a:	b7c1                	j	c1a <ithread_create+0x90>
 c5c:	ec26                	sd	s1,24(sp)
 c5e:	b7b5                	j	bca <ithread_create+0x40>
    free(stack_ptr);
 c60:	8526                	mv	a0,s1
 c62:	00000097          	auipc	ra,0x0
 c66:	c9c080e7          	jalr	-868(ra) # 8fe <free>
    stacks[num_threads] = 0;
 c6a:	00001717          	auipc	a4,0x1
 c6e:	97672703          	lw	a4,-1674(a4) # 15e0 <num_threads>
 c72:	070e                	slli	a4,a4,0x3
 c74:	00001797          	auipc	a5,0x1
 c78:	9647b783          	ld	a5,-1692(a5) # 15d8 <stacks>
 c7c:	97ba                	add	a5,a5,a4
 c7e:	0007b023          	sd	zero,0(a5)
 c82:	64e2                	ld	s1,24(sp)
 c84:	bf59                	j	c1a <ithread_create+0x90>

0000000000000c86 <ithread_join>:

int ithread_join(int thread_id) {
 c86:	1101                	addi	sp,sp,-32
 c88:	ec06                	sd	ra,24(sp)
 c8a:	e822                	sd	s0,16(sp)
 c8c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c8e:	ff040793          	addi	a5,s0,-16
 c92:	ffc7859b          	addiw	a1,a5,-4
 c96:	00000097          	auipc	ra,0x0
 c9a:	90e080e7          	jalr	-1778(ra) # 5a4 <join_thread>
  threads_done++;
 c9e:	00001717          	auipc	a4,0x1
 ca2:	94670713          	addi	a4,a4,-1722 # 15e4 <threads_done>
 ca6:	431c                	lw	a5,0(a4)
 ca8:	2785                	addiw	a5,a5,1
 caa:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 cac:	00001717          	auipc	a4,0x1
 cb0:	93472703          	lw	a4,-1740(a4) # 15e0 <num_threads>
 cb4:	00f70863          	beq	a4,a5,cc4 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 cb8:	fec42503          	lw	a0,-20(s0)
 cbc:	60e2                	ld	ra,24(sp)
 cbe:	6442                	ld	s0,16(sp)
 cc0:	6105                	addi	sp,sp,32
 cc2:	8082                	ret
    free_stacks();
 cc4:	00000097          	auipc	ra,0x0
 cc8:	dd4080e7          	jalr	-556(ra) # a98 <free_stacks>
 ccc:	b7f5                	j	cb8 <ithread_join+0x32>
