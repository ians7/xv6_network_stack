
src/user/_net_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <udp_cli>:
#define CLITEST_SERVER_PORT 20000
#define CLITEST_CLIENT_PORT 78

#define CLITEST_SERVER_ADDR "10.10.0.3"

void udp_cli(void) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	0880                	addi	s0,sp,80
  int sockfd;
  int msglen = strlen("hello over udp");
   e:	00001517          	auipc	a0,0x1
  12:	ea250513          	addi	a0,a0,-350 # eb0 <ithread_join+0x54>
  16:	00000097          	auipc	ra,0x0
  1a:	382080e7          	jalr	898(ra) # 398 <strlen>
  1e:	0005099b          	sext.w	s3,a0
  char *msg = malloc(msglen);
  22:	854e                	mv	a0,s3
  24:	00001097          	auipc	ra,0x1
  28:	b32080e7          	jalr	-1230(ra) # b56 <malloc>
  2c:	892a                	mv	s2,a0
  memmove(msg, "hello over udp", strlen("hello over udp"));
  2e:	00001517          	auipc	a0,0x1
  32:	e8250513          	addi	a0,a0,-382 # eb0 <ithread_join+0x54>
  36:	00000097          	auipc	ra,0x0
  3a:	362080e7          	jalr	866(ra) # 398 <strlen>
  3e:	0005061b          	sext.w	a2,a0
  42:	00001597          	auipc	a1,0x1
  46:	e6e58593          	addi	a1,a1,-402 # eb0 <ithread_join+0x54>
  4a:	854a                	mv	a0,s2
  4c:	00000097          	auipc	ra,0x0
  50:	532080e7          	jalr	1330(ra) # 57e <memmove>
  struct sockaddr_in server_addr, client_addr;
  char buf[64];

  printf("TESTING UDP CLIENT...\n");
  54:	00001517          	auipc	a0,0x1
  58:	e7450513          	addi	a0,a0,-396 # ec8 <ithread_join+0x6c>
  5c:	00001097          	auipc	ra,0x1
  60:	a42080e7          	jalr	-1470(ra) # a9e <printf>

  memset(&server_addr, 0, sizeof(server_addr));
  64:	4641                	li	a2,16
  66:	4581                	li	a1,0
  68:	fc040513          	addi	a0,s0,-64
  6c:	00000097          	auipc	ra,0x0
  70:	356080e7          	jalr	854(ra) # 3c2 <memset>
  server_addr.sin_family = AF_INET;
  74:	4789                	li	a5,2
  76:	fcf41023          	sh	a5,-64(s0)
  server_addr.sin_port = htons(CLITEST_SERVER_PORT);
  7a:	6789                	lui	a5,0x2
  7c:	04e78793          	addi	a5,a5,78 # 204e <base+0x1e>
  80:	fcf41123          	sh	a5,-62(s0)
  server_addr.sin_addr.s_addr = htonl(inet_addr(CLITEST_SERVER_ADDR));
  84:	00001517          	auipc	a0,0x1
  88:	e5c50513          	addi	a0,a0,-420 # ee0 <ithread_join+0x84>
  8c:	00000097          	auipc	ra,0x0
  90:	59c080e7          	jalr	1436(ra) # 628 <inet_addr>
    ((netlong & 0xFF000000U) >> 24);
}

static inline uint32 
htonl(uint32 hostlong) {
    return ((hostlong & 0x000000FFU) << 24) |
  94:	0185171b          	slliw	a4,a0,0x18
           ((hostlong & 0x0000FF00U) << 8)  |
           ((hostlong & 0x00FF0000U) >> 8)  |
           ((hostlong & 0xFF000000U) >> 24);
  98:	0185579b          	srliw	a5,a0,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
  9c:	8f5d                	or	a4,a4,a5
           ((hostlong & 0x0000FF00U) << 8)  |
  9e:	0085179b          	slliw	a5,a0,0x8
  a2:	00ff06b7          	lui	a3,0xff0
  a6:	8ff5                	and	a5,a5,a3
           ((hostlong & 0x00FF0000U) >> 8)  |
  a8:	8f5d                	or	a4,a4,a5
  aa:	0085579b          	srliw	a5,a0,0x8
  ae:	66c1                	lui	a3,0x10
  b0:	f0068693          	addi	a3,a3,-256 # ff00 <base+0xded0>
  b4:	8ff5                	and	a5,a5,a3
  b6:	8f5d                	or	a4,a4,a5
  b8:	fce42223          	sw	a4,-60(s0)

  /* --- Create client socket --- */
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  bc:	4601                	li	a2,0
  be:	4589                	li	a1,2
  c0:	4509                	li	a0,2
  c2:	00000097          	auipc	ra,0x0
  c6:	6c6080e7          	jalr	1734(ra) # 788 <socket>
  if (sockfd < 0) {
  ca:	08054163          	bltz	a0,14c <udp_cli+0x14c>
  ce:	84aa                	mv	s1,a0
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  d0:	4641                	li	a2,16
  d2:	4581                	li	a1,0
  d4:	fb040513          	addi	a0,s0,-80
  d8:	00000097          	auipc	ra,0x0
  dc:	2ea080e7          	jalr	746(ra) # 3c2 <memset>
  client_addr.sin_family = AF_INET;
  e0:	4789                	li	a5,2
  e2:	faf41823          	sh	a5,-80(s0)
  client_addr.sin_port = htons(CLITEST_CLIENT_PORT);
  e6:	6795                	lui	a5,0x5
  e8:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x2dd0>
  ec:	faf41923          	sh	a5,-78(s0)
  client_addr.sin_addr.s_addr = INADDR_ANY;
  f0:	4785                	li	a5,1
  f2:	faf42a23          	sw	a5,-76(s0)

  if (bind(sockfd, (struct sockaddr *)&client_addr, sizeof(client_addr)) <
  f6:	4641                	li	a2,16
  f8:	fb040593          	addi	a1,s0,-80
  fc:	8526                	mv	a0,s1
  fe:	00000097          	auipc	ra,0x0
 102:	692080e7          	jalr	1682(ra) # 790 <bind>
 106:	06054063          	bltz	a0,166 <udp_cli+0x166>
    printf("client bind failed\n");
    exit(1);
  }

  /* --- Client sends message to server --- */
  printf("sending payload\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	e1650513          	addi	a0,a0,-490 # f20 <ithread_join+0xc4>
 112:	00001097          	auipc	ra,0x1
 116:	98c080e7          	jalr	-1652(ra) # a9e <printf>
  if (sendto(sockfd, msg, msglen, 0, (struct sockaddr *)&server_addr,
 11a:	47c1                	li	a5,16
 11c:	fc040713          	addi	a4,s0,-64
 120:	4681                	li	a3,0
 122:	864e                	mv	a2,s3
 124:	85ca                	mv	a1,s2
 126:	8526                	mv	a0,s1
 128:	00000097          	auipc	ra,0x0
 12c:	69a080e7          	jalr	1690(ra) # 7c2 <sendto>
 130:	04054863          	bltz	a0,180 <udp_cli+0x180>
             sizeof(server_addr)) < 0) {
    printf("sendto failed\n");
    exit(1);
  }

  close(sockfd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	5ba080e7          	jalr	1466(ra) # 6f0 <close>
}
 13e:	60a6                	ld	ra,72(sp)
 140:	6406                	ld	s0,64(sp)
 142:	74e2                	ld	s1,56(sp)
 144:	7942                	ld	s2,48(sp)
 146:	79a2                	ld	s3,40(sp)
 148:	6161                	addi	sp,sp,80
 14a:	8082                	ret
    printf("client socket failed\n");
 14c:	00001517          	auipc	a0,0x1
 150:	da450513          	addi	a0,a0,-604 # ef0 <ithread_join+0x94>
 154:	00001097          	auipc	ra,0x1
 158:	94a080e7          	jalr	-1718(ra) # a9e <printf>
    exit(1);
 15c:	4505                	li	a0,1
 15e:	00000097          	auipc	ra,0x0
 162:	56a080e7          	jalr	1386(ra) # 6c8 <exit>
    printf("client bind failed\n");
 166:	00001517          	auipc	a0,0x1
 16a:	da250513          	addi	a0,a0,-606 # f08 <ithread_join+0xac>
 16e:	00001097          	auipc	ra,0x1
 172:	930080e7          	jalr	-1744(ra) # a9e <printf>
    exit(1);
 176:	4505                	li	a0,1
 178:	00000097          	auipc	ra,0x0
 17c:	550080e7          	jalr	1360(ra) # 6c8 <exit>
    printf("sendto failed\n");
 180:	00001517          	auipc	a0,0x1
 184:	db850513          	addi	a0,a0,-584 # f38 <ithread_join+0xdc>
 188:	00001097          	auipc	ra,0x1
 18c:	916080e7          	jalr	-1770(ra) # a9e <printf>
    exit(1);
 190:	4505                	li	a0,1
 192:	00000097          	auipc	ra,0x0
 196:	536080e7          	jalr	1334(ra) # 6c8 <exit>

000000000000019a <udp_srv>:

void udp_srv(void) {
 19a:	7135                	addi	sp,sp,-160
 19c:	ed06                	sd	ra,152(sp)
 19e:	e922                	sd	s0,144(sp)
 1a0:	1100                	addi	s0,sp,160
  int sockfd;
  struct sockaddr_in server_addr, client_addr;
  char buf[64];


  printf("TESTING UDP SERVER...\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	da650513          	addi	a0,a0,-602 # f48 <ithread_join+0xec>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	8f4080e7          	jalr	-1804(ra) # a9e <printf>

  // --- Create server socket
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 1b2:	4601                	li	a2,0
 1b4:	4589                	li	a1,2
 1b6:	4509                	li	a0,2
 1b8:	00000097          	auipc	ra,0x0
 1bc:	5d0080e7          	jalr	1488(ra) # 788 <socket>
  if (sockfd < 0) {
 1c0:	0a054c63          	bltz	a0,278 <udp_srv+0xde>
 1c4:	e526                	sd	s1,136(sp)
 1c6:	84aa                	mv	s1,a0
    printf("server socket failed\n");
    exit(1);
  }

  memset(&server_addr, 0, sizeof(server_addr));
 1c8:	4641                	li	a2,16
 1ca:	4581                	li	a1,0
 1cc:	fc040513          	addi	a0,s0,-64
 1d0:	00000097          	auipc	ra,0x0
 1d4:	1f2080e7          	jalr	498(ra) # 3c2 <memset>
  server_addr.sin_family = AF_INET;
 1d8:	4789                	li	a5,2
 1da:	fcf41023          	sh	a5,-64(s0)
  server_addr.sin_port = htons(SRVTEST_SERVER_PORT);
 1de:	6795                	lui	a5,0x5
 1e0:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x2dd0>
 1e4:	fcf41123          	sh	a5,-62(s0)
  server_addr.sin_addr.s_addr = htonl(0xc0a8fe74);
 1e8:	74feb7b7          	lui	a5,0x74feb
 1ec:	8c078793          	addi	a5,a5,-1856 # 74fea8c0 <base+0x74fe8890>
 1f0:	fcf42223          	sw	a5,-60(s0)

  if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
 1f4:	4641                	li	a2,16
 1f6:	fc040593          	addi	a1,s0,-64
 1fa:	8526                	mv	a0,s1
 1fc:	00000097          	auipc	ra,0x0
 200:	594080e7          	jalr	1428(ra) # 790 <bind>
 204:	08054b63          	bltz	a0,29a <udp_srv+0x100>
 208:	e14a                	sd	s2,128(sp)
 20a:	fcce                	sd	s3,120(sp)
 20c:	f8d2                	sd	s4,112(sp)
    printf("server bind failed\n");
    exit(1);
  }

  // --- Server receives message
  int fromlen = sizeof(client_addr);
 20e:	47c1                	li	a5,16
 210:	f6f42623          	sw	a5,-148(s0)
  while (1) {
  printf("waiting for packet...\n");
 214:	00001a17          	auipc	s4,0x1
 218:	d7ca0a13          	addi	s4,s4,-644 # f90 <ithread_join+0x134>
    int n = recvfrom(sockfd, buf, sizeof(buf)-1, 0,
        (struct sockaddr *)&client_addr, &fromlen);
    buf[n] = '\0';

    printf("UDP PACKET RECEIVED: \n\t");
 21c:	00001997          	auipc	s3,0x1
 220:	d8c98993          	addi	s3,s3,-628 # fa8 <ithread_join+0x14c>
    printf("%s\n", buf);
 224:	00001917          	auipc	s2,0x1
 228:	d9c90913          	addi	s2,s2,-612 # fc0 <ithread_join+0x164>
  printf("waiting for packet...\n");
 22c:	8552                	mv	a0,s4
 22e:	00001097          	auipc	ra,0x1
 232:	870080e7          	jalr	-1936(ra) # a9e <printf>
    int n = recvfrom(sockfd, buf, sizeof(buf)-1, 0,
 236:	f6c40793          	addi	a5,s0,-148
 23a:	fb040713          	addi	a4,s0,-80
 23e:	4681                	li	a3,0
 240:	03f00613          	li	a2,63
 244:	f7040593          	addi	a1,s0,-144
 248:	8526                	mv	a0,s1
 24a:	00000097          	auipc	ra,0x0
 24e:	582080e7          	jalr	1410(ra) # 7cc <recvfrom>
    buf[n] = '\0';
 252:	fd050793          	addi	a5,a0,-48
 256:	00878533          	add	a0,a5,s0
 25a:	fa050023          	sb	zero,-96(a0)
    printf("UDP PACKET RECEIVED: \n\t");
 25e:	854e                	mv	a0,s3
 260:	00001097          	auipc	ra,0x1
 264:	83e080e7          	jalr	-1986(ra) # a9e <printf>
    printf("%s\n", buf);
 268:	f7040593          	addi	a1,s0,-144
 26c:	854a                	mv	a0,s2
 26e:	00001097          	auipc	ra,0x1
 272:	830080e7          	jalr	-2000(ra) # a9e <printf>
  while (1) {
 276:	bf5d                	j	22c <udp_srv+0x92>
 278:	e526                	sd	s1,136(sp)
 27a:	e14a                	sd	s2,128(sp)
 27c:	fcce                	sd	s3,120(sp)
 27e:	f8d2                	sd	s4,112(sp)
    printf("server socket failed\n");
 280:	00001517          	auipc	a0,0x1
 284:	ce050513          	addi	a0,a0,-800 # f60 <ithread_join+0x104>
 288:	00001097          	auipc	ra,0x1
 28c:	816080e7          	jalr	-2026(ra) # a9e <printf>
    exit(1);
 290:	4505                	li	a0,1
 292:	00000097          	auipc	ra,0x0
 296:	436080e7          	jalr	1078(ra) # 6c8 <exit>
 29a:	e14a                	sd	s2,128(sp)
 29c:	fcce                	sd	s3,120(sp)
 29e:	f8d2                	sd	s4,112(sp)
    printf("server bind failed\n");
 2a0:	00001517          	auipc	a0,0x1
 2a4:	cd850513          	addi	a0,a0,-808 # f78 <ithread_join+0x11c>
 2a8:	00000097          	auipc	ra,0x0
 2ac:	7f6080e7          	jalr	2038(ra) # a9e <printf>
    exit(1);
 2b0:	4505                	li	a0,1
 2b2:	00000097          	auipc	ra,0x0
 2b6:	416080e7          	jalr	1046(ra) # 6c8 <exit>

00000000000002ba <main>:
  }

  close(sockfd);
}

int main(int argc, char **argv) {
 2ba:	1101                	addi	sp,sp,-32
 2bc:	ec06                	sd	ra,24(sp)
 2be:	e822                	sd	s0,16(sp)
 2c0:	e426                	sd	s1,8(sp)
 2c2:	1000                	addi	s0,sp,32
 2c4:	84ae                	mv	s1,a1

  if (argc != 2) {
 2c6:	4789                	li	a5,2
 2c8:	04f51063          	bne	a0,a5,308 <main+0x4e>
    printf("Usage: net_test [ srv | cli | all ]\n");
  }

  if (strcmp(argv[1], "srv") == 0) {
 2cc:	00001597          	auipc	a1,0x1
 2d0:	d2458593          	addi	a1,a1,-732 # ff0 <ithread_join+0x194>
 2d4:	6488                	ld	a0,8(s1)
 2d6:	00000097          	auipc	ra,0x0
 2da:	096080e7          	jalr	150(ra) # 36c <strcmp>
 2de:	cd15                	beqz	a0,31a <main+0x60>
    udp_srv();
  } else if (strcmp(argv[1], "cli") == 0) {
 2e0:	00001597          	auipc	a1,0x1
 2e4:	d1858593          	addi	a1,a1,-744 # ff8 <ithread_join+0x19c>
 2e8:	6488                	ld	a0,8(s1)
 2ea:	00000097          	auipc	ra,0x0
 2ee:	082080e7          	jalr	130(ra) # 36c <strcmp>
 2f2:	e905                	bnez	a0,322 <main+0x68>
    udp_cli();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	d0c080e7          	jalr	-756(ra) # 0 <udp_cli>
  } else if (strcmp(argv[1], "all") == 0) {
    // udp_all();
  }
}
 2fc:	4501                	li	a0,0
 2fe:	60e2                	ld	ra,24(sp)
 300:	6442                	ld	s0,16(sp)
 302:	64a2                	ld	s1,8(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    printf("Usage: net_test [ srv | cli | all ]\n");
 308:	00001517          	auipc	a0,0x1
 30c:	cc050513          	addi	a0,a0,-832 # fc8 <ithread_join+0x16c>
 310:	00000097          	auipc	ra,0x0
 314:	78e080e7          	jalr	1934(ra) # a9e <printf>
 318:	bf55                	j	2cc <main+0x12>
    udp_srv();
 31a:	00000097          	auipc	ra,0x0
 31e:	e80080e7          	jalr	-384(ra) # 19a <udp_srv>
  } else if (strcmp(argv[1], "all") == 0) {
 322:	00001597          	auipc	a1,0x1
 326:	cde58593          	addi	a1,a1,-802 # 1000 <ithread_join+0x1a4>
 32a:	6488                	ld	a0,8(s1)
 32c:	00000097          	auipc	ra,0x0
 330:	040080e7          	jalr	64(ra) # 36c <strcmp>
 334:	b7e1                	j	2fc <main+0x42>

0000000000000336 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 33e:	00000097          	auipc	ra,0x0
 342:	f7c080e7          	jalr	-132(ra) # 2ba <main>
  exit(0);
 346:	4501                	li	a0,0
 348:	00000097          	auipc	ra,0x0
 34c:	380080e7          	jalr	896(ra) # 6c8 <exit>

0000000000000350 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 356:	87aa                	mv	a5,a0
 358:	0585                	addi	a1,a1,1
 35a:	0785                	addi	a5,a5,1
 35c:	fff5c703          	lbu	a4,-1(a1)
 360:	fee78fa3          	sb	a4,-1(a5)
 364:	fb75                	bnez	a4,358 <strcpy+0x8>
    ;
  return os;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 372:	00054783          	lbu	a5,0(a0)
 376:	cb91                	beqz	a5,38a <strcmp+0x1e>
 378:	0005c703          	lbu	a4,0(a1)
 37c:	00f71763          	bne	a4,a5,38a <strcmp+0x1e>
    p++, q++;
 380:	0505                	addi	a0,a0,1
 382:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 384:	00054783          	lbu	a5,0(a0)
 388:	fbe5                	bnez	a5,378 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 38a:	0005c503          	lbu	a0,0(a1)
}
 38e:	40a7853b          	subw	a0,a5,a0
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <strlen>:

uint
strlen(const char *s)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 39e:	00054783          	lbu	a5,0(a0)
 3a2:	cf91                	beqz	a5,3be <strlen+0x26>
 3a4:	0505                	addi	a0,a0,1
 3a6:	87aa                	mv	a5,a0
 3a8:	86be                	mv	a3,a5
 3aa:	0785                	addi	a5,a5,1
 3ac:	fff7c703          	lbu	a4,-1(a5)
 3b0:	ff65                	bnez	a4,3a8 <strlen+0x10>
 3b2:	40a6853b          	subw	a0,a3,a0
 3b6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
  for(n = 0; s[n]; n++)
 3be:	4501                	li	a0,0
 3c0:	bfe5                	j	3b8 <strlen+0x20>

00000000000003c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3c8:	ca19                	beqz	a2,3de <memset+0x1c>
 3ca:	87aa                	mv	a5,a0
 3cc:	1602                	slli	a2,a2,0x20
 3ce:	9201                	srli	a2,a2,0x20
 3d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3d8:	0785                	addi	a5,a5,1
 3da:	fee79de3          	bne	a5,a4,3d4 <memset+0x12>
  }
  return dst;
}
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <strchr>:

char*
strchr(const char *s, char c)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ea:	00054783          	lbu	a5,0(a0)
 3ee:	cb99                	beqz	a5,404 <strchr+0x20>
    if(*s == c)
 3f0:	00f58763          	beq	a1,a5,3fe <strchr+0x1a>
  for(; *s; s++)
 3f4:	0505                	addi	a0,a0,1
 3f6:	00054783          	lbu	a5,0(a0)
 3fa:	fbfd                	bnez	a5,3f0 <strchr+0xc>
      return (char*)s;
  return 0;
 3fc:	4501                	li	a0,0
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret
  return 0;
 404:	4501                	li	a0,0
 406:	bfe5                	j	3fe <strchr+0x1a>

0000000000000408 <gets>:

char*
gets(char *buf, int max)
{
 408:	711d                	addi	sp,sp,-96
 40a:	ec86                	sd	ra,88(sp)
 40c:	e8a2                	sd	s0,80(sp)
 40e:	e4a6                	sd	s1,72(sp)
 410:	e0ca                	sd	s2,64(sp)
 412:	fc4e                	sd	s3,56(sp)
 414:	f852                	sd	s4,48(sp)
 416:	f456                	sd	s5,40(sp)
 418:	f05a                	sd	s6,32(sp)
 41a:	ec5e                	sd	s7,24(sp)
 41c:	1080                	addi	s0,sp,96
 41e:	8baa                	mv	s7,a0
 420:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 422:	892a                	mv	s2,a0
 424:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 426:	4aa9                	li	s5,10
 428:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 42a:	89a6                	mv	s3,s1
 42c:	2485                	addiw	s1,s1,1
 42e:	0344d863          	bge	s1,s4,45e <gets+0x56>
    cc = read(0, &c, 1);
 432:	4605                	li	a2,1
 434:	faf40593          	addi	a1,s0,-81
 438:	4501                	li	a0,0
 43a:	00000097          	auipc	ra,0x0
 43e:	2a6080e7          	jalr	678(ra) # 6e0 <read>
    if(cc < 1)
 442:	00a05e63          	blez	a0,45e <gets+0x56>
    buf[i++] = c;
 446:	faf44783          	lbu	a5,-81(s0)
 44a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 44e:	01578763          	beq	a5,s5,45c <gets+0x54>
 452:	0905                	addi	s2,s2,1
 454:	fd679be3          	bne	a5,s6,42a <gets+0x22>
    buf[i++] = c;
 458:	89a6                	mv	s3,s1
 45a:	a011                	j	45e <gets+0x56>
 45c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 45e:	99de                	add	s3,s3,s7
 460:	00098023          	sb	zero,0(s3)
  return buf;
}
 464:	855e                	mv	a0,s7
 466:	60e6                	ld	ra,88(sp)
 468:	6446                	ld	s0,80(sp)
 46a:	64a6                	ld	s1,72(sp)
 46c:	6906                	ld	s2,64(sp)
 46e:	79e2                	ld	s3,56(sp)
 470:	7a42                	ld	s4,48(sp)
 472:	7aa2                	ld	s5,40(sp)
 474:	7b02                	ld	s6,32(sp)
 476:	6be2                	ld	s7,24(sp)
 478:	6125                	addi	sp,sp,96
 47a:	8082                	ret

000000000000047c <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 47c:	711d                	addi	sp,sp,-96
 47e:	ec86                	sd	ra,88(sp)
 480:	e8a2                	sd	s0,80(sp)
 482:	e4a6                	sd	s1,72(sp)
 484:	e0ca                	sd	s2,64(sp)
 486:	fc4e                	sd	s3,56(sp)
 488:	f852                	sd	s4,48(sp)
 48a:	f456                	sd	s5,40(sp)
 48c:	f05a                	sd	s6,32(sp)
 48e:	ec5e                	sd	s7,24(sp)
 490:	1080                	addi	s0,sp,96
 492:	8baa                	mv	s7,a0
 494:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 496:	892a                	mv	s2,a0
 498:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 49a:	4aa9                	li	s5,10
 49c:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 49e:	8a26                	mv	s4,s1
 4a0:	2485                	addiw	s1,s1,1
 4a2:	0334d863          	bge	s1,s3,4d2 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 4a6:	4605                	li	a2,1
 4a8:	faf40593          	addi	a1,s0,-81
 4ac:	4501                	li	a0,0
 4ae:	00000097          	auipc	ra,0x0
 4b2:	232080e7          	jalr	562(ra) # 6e0 <read>
    if(cc < 1)
 4b6:	00a05e63          	blez	a0,4d2 <fgetstdin+0x56>
    buf[i++] = c;
 4ba:	faf44783          	lbu	a5,-81(s0)
 4be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c2:	01578763          	beq	a5,s5,4d0 <fgetstdin+0x54>
 4c6:	0905                	addi	s2,s2,1
 4c8:	fd679be3          	bne	a5,s6,49e <fgetstdin+0x22>
    buf[i++] = c;
 4cc:	8a26                	mv	s4,s1
 4ce:	a011                	j	4d2 <fgetstdin+0x56>
 4d0:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 4d2:	9bd2                	add	s7,s7,s4
 4d4:	000b8023          	sb	zero,0(s7)
  return i;
}
 4d8:	8552                	mv	a0,s4
 4da:	60e6                	ld	ra,88(sp)
 4dc:	6446                	ld	s0,80(sp)
 4de:	64a6                	ld	s1,72(sp)
 4e0:	6906                	ld	s2,64(sp)
 4e2:	79e2                	ld	s3,56(sp)
 4e4:	7a42                	ld	s4,48(sp)
 4e6:	7aa2                	ld	s5,40(sp)
 4e8:	7b02                	ld	s6,32(sp)
 4ea:	6be2                	ld	s7,24(sp)
 4ec:	6125                	addi	sp,sp,96
 4ee:	8082                	ret

00000000000004f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	e04a                	sd	s2,0(sp)
 4f8:	1000                	addi	s0,sp,32
 4fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4fc:	4581                	li	a1,0
 4fe:	00000097          	auipc	ra,0x0
 502:	20a080e7          	jalr	522(ra) # 708 <open>
  if(fd < 0)
 506:	02054663          	bltz	a0,532 <stat+0x42>
 50a:	e426                	sd	s1,8(sp)
 50c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 50e:	85ca                	mv	a1,s2
 510:	00000097          	auipc	ra,0x0
 514:	210080e7          	jalr	528(ra) # 720 <fstat>
 518:	892a                	mv	s2,a0
  close(fd);
 51a:	8526                	mv	a0,s1
 51c:	00000097          	auipc	ra,0x0
 520:	1d4080e7          	jalr	468(ra) # 6f0 <close>
  return r;
 524:	64a2                	ld	s1,8(sp)
}
 526:	854a                	mv	a0,s2
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	6902                	ld	s2,0(sp)
 52e:	6105                	addi	sp,sp,32
 530:	8082                	ret
    return -1;
 532:	597d                	li	s2,-1
 534:	bfcd                	j	526 <stat+0x36>

0000000000000536 <atoi>:

int
atoi(const char *s)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53c:	00054683          	lbu	a3,0(a0)
 540:	fd06879b          	addiw	a5,a3,-48
 544:	0ff7f793          	zext.b	a5,a5
 548:	4625                	li	a2,9
 54a:	02f66863          	bltu	a2,a5,57a <atoi+0x44>
 54e:	872a                	mv	a4,a0
  n = 0;
 550:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 552:	0705                	addi	a4,a4,1
 554:	0025179b          	slliw	a5,a0,0x2
 558:	9fa9                	addw	a5,a5,a0
 55a:	0017979b          	slliw	a5,a5,0x1
 55e:	9fb5                	addw	a5,a5,a3
 560:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 564:	00074683          	lbu	a3,0(a4)
 568:	fd06879b          	addiw	a5,a3,-48
 56c:	0ff7f793          	zext.b	a5,a5
 570:	fef671e3          	bgeu	a2,a5,552 <atoi+0x1c>
  return n;
}
 574:	6422                	ld	s0,8(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret
  n = 0;
 57a:	4501                	li	a0,0
 57c:	bfe5                	j	574 <atoi+0x3e>

000000000000057e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 57e:	1141                	addi	sp,sp,-16
 580:	e422                	sd	s0,8(sp)
 582:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 584:	02b57463          	bgeu	a0,a1,5ac <memmove+0x2e>
    while(n-- > 0)
 588:	00c05f63          	blez	a2,5a6 <memmove+0x28>
 58c:	1602                	slli	a2,a2,0x20
 58e:	9201                	srli	a2,a2,0x20
 590:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 594:	872a                	mv	a4,a0
      *dst++ = *src++;
 596:	0585                	addi	a1,a1,1
 598:	0705                	addi	a4,a4,1
 59a:	fff5c683          	lbu	a3,-1(a1)
 59e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a2:	fef71ae3          	bne	a4,a5,596 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a6:	6422                	ld	s0,8(sp)
 5a8:	0141                	addi	sp,sp,16
 5aa:	8082                	ret
    dst += n;
 5ac:	00c50733          	add	a4,a0,a2
    src += n;
 5b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b2:	fec05ae3          	blez	a2,5a6 <memmove+0x28>
 5b6:	fff6079b          	addiw	a5,a2,-1
 5ba:	1782                	slli	a5,a5,0x20
 5bc:	9381                	srli	a5,a5,0x20
 5be:	fff7c793          	not	a5,a5
 5c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c4:	15fd                	addi	a1,a1,-1
 5c6:	177d                	addi	a4,a4,-1
 5c8:	0005c683          	lbu	a3,0(a1)
 5cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d0:	fee79ae3          	bne	a5,a4,5c4 <memmove+0x46>
 5d4:	bfc9                	j	5a6 <memmove+0x28>

00000000000005d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d6:	1141                	addi	sp,sp,-16
 5d8:	e422                	sd	s0,8(sp)
 5da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5dc:	ca05                	beqz	a2,60c <memcmp+0x36>
 5de:	fff6069b          	addiw	a3,a2,-1
 5e2:	1682                	slli	a3,a3,0x20
 5e4:	9281                	srli	a3,a3,0x20
 5e6:	0685                	addi	a3,a3,1
 5e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ea:	00054783          	lbu	a5,0(a0)
 5ee:	0005c703          	lbu	a4,0(a1)
 5f2:	00e79863          	bne	a5,a4,602 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f6:	0505                	addi	a0,a0,1
    p2++;
 5f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5fa:	fed518e3          	bne	a0,a3,5ea <memcmp+0x14>
  }
  return 0;
 5fe:	4501                	li	a0,0
 600:	a019                	j	606 <memcmp+0x30>
      return *p1 - *p2;
 602:	40e7853b          	subw	a0,a5,a4
}
 606:	6422                	ld	s0,8(sp)
 608:	0141                	addi	sp,sp,16
 60a:	8082                	ret
  return 0;
 60c:	4501                	li	a0,0
 60e:	bfe5                	j	606 <memcmp+0x30>

0000000000000610 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 610:	1141                	addi	sp,sp,-16
 612:	e406                	sd	ra,8(sp)
 614:	e022                	sd	s0,0(sp)
 616:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 618:	00000097          	auipc	ra,0x0
 61c:	f66080e7          	jalr	-154(ra) # 57e <memmove>
}
 620:	60a2                	ld	ra,8(sp)
 622:	6402                	ld	s0,0(sp)
 624:	0141                	addi	sp,sp,16
 626:	8082                	ret

0000000000000628 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 628:	1141                	addi	sp,sp,-16
 62a:	e422                	sd	s0,8(sp)
 62c:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 62e:	00054783          	lbu	a5,0(a0)
 632:	cfbd                	beqz	a5,6b0 <inet_addr+0x88>
  int dots = 0;
 634:	4801                	li	a6,0
  int digits = 0;
 636:	4601                	li	a2,0
  int octet = 0;
 638:	4681                	li	a3,0
  uint result = 0;
 63a:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 63c:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 63e:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 642:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 644:	4301                	li	t1,0
      if (octet > 255)
 646:	0ff00e13          	li	t3,255
 64a:	a015                	j	66e <inet_addr+0x46>
    } else if (*s == '.') {
 64c:	07d79463          	bne	a5,t4,6b4 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 650:	c625                	beqz	a2,6b8 <inet_addr+0x90>
 652:	07e80563          	beq	a6,t5,6bc <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 656:	0085959b          	slliw	a1,a1,0x8
 65a:	8ecd                	or	a3,a3,a1
 65c:	0006859b          	sext.w	a1,a3
      dots++;
 660:	2805                	addiw	a6,a6,1
      digits = 0;
 662:	861a                	mv	a2,t1
      octet = 0;
 664:	869a                	mv	a3,t1
  for (; *s; s++) {
 666:	0505                	addi	a0,a0,1
 668:	00054783          	lbu	a5,0(a0)
 66c:	c79d                	beqz	a5,69a <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 66e:	fd07871b          	addiw	a4,a5,-48
 672:	0ff77713          	zext.b	a4,a4
 676:	fce8ebe3          	bltu	a7,a4,64c <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 67a:	0026971b          	slliw	a4,a3,0x2
 67e:	9f35                	addw	a4,a4,a3
 680:	0017171b          	slliw	a4,a4,0x1
 684:	fd07879b          	addiw	a5,a5,-48
 688:	00e786bb          	addw	a3,a5,a4
      digits++;
 68c:	2605                	addiw	a2,a2,1
      if (octet > 255)
 68e:	fcde5ce3          	bge	t3,a3,666 <inet_addr+0x3e>
        return 0;
 692:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 694:	6422                	ld	s0,8(sp)
 696:	0141                	addi	sp,sp,16
 698:	8082                	ret
    return 0;
 69a:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 69c:	de65                	beqz	a2,694 <inet_addr+0x6c>
 69e:	478d                	li	a5,3
 6a0:	fef81ae3          	bne	a6,a5,694 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 6a4:	0085959b          	slliw	a1,a1,0x8
 6a8:	8ecd                	or	a3,a3,a1
 6aa:	0006851b          	sext.w	a0,a3
  return result;
 6ae:	b7dd                	j	694 <inet_addr+0x6c>
    return 0;
 6b0:	4501                	li	a0,0
 6b2:	b7cd                	j	694 <inet_addr+0x6c>
      return 0;
 6b4:	4501                	li	a0,0
 6b6:	bff9                	j	694 <inet_addr+0x6c>
        return 0;
 6b8:	4501                	li	a0,0
 6ba:	bfe9                	j	694 <inet_addr+0x6c>
 6bc:	4501                	li	a0,0
 6be:	bfd9                	j	694 <inet_addr+0x6c>

00000000000006c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6c0:	4885                	li	a7,1
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6c8:	4889                	li	a7,2
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6d0:	488d                	li	a7,3
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6d8:	4891                	li	a7,4
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <read>:
.global read
read:
 li a7, SYS_read
 6e0:	4895                	li	a7,5
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <write>:
.global write
write:
 li a7, SYS_write
 6e8:	48c1                	li	a7,16
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <close>:
.global close
close:
 li a7, SYS_close
 6f0:	48d5                	li	a7,21
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6f8:	4899                	li	a7,6
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <exec>:
.global exec
exec:
 li a7, SYS_exec
 700:	489d                	li	a7,7
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <open>:
.global open
open:
 li a7, SYS_open
 708:	48bd                	li	a7,15
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 710:	48c5                	li	a7,17
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 718:	48c9                	li	a7,18
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 720:	48a1                	li	a7,8
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <link>:
.global link
link:
 li a7, SYS_link
 728:	48cd                	li	a7,19
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 730:	48d1                	li	a7,20
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 738:	48a5                	li	a7,9
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <dup>:
.global dup
dup:
 li a7, SYS_dup
 740:	48a9                	li	a7,10
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 748:	48ad                	li	a7,11
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 750:	48b1                	li	a7,12
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 758:	48b5                	li	a7,13
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 760:	48b9                	li	a7,14
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 768:	48d9                	li	a7,22
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 770:	48dd                	li	a7,23
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 778:	48e1                	li	a7,24
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 780:	48e5                	li	a7,25
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <socket>:
.global socket
socket:
 li a7, SYS_socket
 788:	48e9                	li	a7,26
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <bind>:
.global bind
bind:
 li a7, SYS_bind
 790:	48ed                	li	a7,27
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <accept>:
.global accept
accept:
 li a7, SYS_accept
 798:	48f5                	li	a7,29
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <listen>:
.global listen
listen:
 li a7, SYS_listen
 7a0:	48f1                	li	a7,28
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 7a8:	48f9                	li	a7,30
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <send>:
.global send
send:
 li a7, SYS_send
 7b0:	48fd                	li	a7,31
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 7b8:	02000893          	li	a7,32
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 7c2:	02100893          	li	a7,33
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 7cc:	02200893          	li	a7,34
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7d6:	1101                	addi	sp,sp,-32
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e2:	4605                	li	a2,1
 7e4:	fef40593          	addi	a1,s0,-17
 7e8:	00000097          	auipc	ra,0x0
 7ec:	f00080e7          	jalr	-256(ra) # 6e8 <write>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6105                	addi	sp,sp,32
 7f6:	8082                	ret

00000000000007f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f426                	sd	s1,40(sp)
 800:	0080                	addi	s0,sp,64
 802:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 804:	c299                	beqz	a3,80a <printint+0x12>
 806:	0805cb63          	bltz	a1,89c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 80a:	2581                	sext.w	a1,a1
  neg = 0;
 80c:	4881                	li	a7,0
 80e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 812:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 814:	2601                	sext.w	a2,a2
 816:	00001517          	auipc	a0,0x1
 81a:	88250513          	addi	a0,a0,-1918 # 1098 <digits>
 81e:	883a                	mv	a6,a4
 820:	2705                	addiw	a4,a4,1
 822:	02c5f7bb          	remuw	a5,a1,a2
 826:	1782                	slli	a5,a5,0x20
 828:	9381                	srli	a5,a5,0x20
 82a:	97aa                	add	a5,a5,a0
 82c:	0007c783          	lbu	a5,0(a5)
 830:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 834:	0005879b          	sext.w	a5,a1
 838:	02c5d5bb          	divuw	a1,a1,a2
 83c:	0685                	addi	a3,a3,1
 83e:	fec7f0e3          	bgeu	a5,a2,81e <printint+0x26>
  if(neg)
 842:	00088c63          	beqz	a7,85a <printint+0x62>
    buf[i++] = '-';
 846:	fd070793          	addi	a5,a4,-48
 84a:	00878733          	add	a4,a5,s0
 84e:	02d00793          	li	a5,45
 852:	fef70823          	sb	a5,-16(a4)
 856:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 85a:	02e05c63          	blez	a4,892 <printint+0x9a>
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	fc040793          	addi	a5,s0,-64
 866:	00e78933          	add	s2,a5,a4
 86a:	fff78993          	addi	s3,a5,-1
 86e:	99ba                	add	s3,s3,a4
 870:	377d                	addiw	a4,a4,-1
 872:	1702                	slli	a4,a4,0x20
 874:	9301                	srli	a4,a4,0x20
 876:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 87a:	fff94583          	lbu	a1,-1(s2)
 87e:	8526                	mv	a0,s1
 880:	00000097          	auipc	ra,0x0
 884:	f56080e7          	jalr	-170(ra) # 7d6 <putc>
  while(--i >= 0)
 888:	197d                	addi	s2,s2,-1
 88a:	ff3918e3          	bne	s2,s3,87a <printint+0x82>
 88e:	7902                	ld	s2,32(sp)
 890:	69e2                	ld	s3,24(sp)
}
 892:	70e2                	ld	ra,56(sp)
 894:	7442                	ld	s0,48(sp)
 896:	74a2                	ld	s1,40(sp)
 898:	6121                	addi	sp,sp,64
 89a:	8082                	ret
    x = -xx;
 89c:	40b005bb          	negw	a1,a1
    neg = 1;
 8a0:	4885                	li	a7,1
    x = -xx;
 8a2:	b7b5                	j	80e <printint+0x16>

00000000000008a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	e486                	sd	ra,72(sp)
 8a8:	e0a2                	sd	s0,64(sp)
 8aa:	f84a                	sd	s2,48(sp)
 8ac:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8ae:	0005c903          	lbu	s2,0(a1)
 8b2:	1a090a63          	beqz	s2,a66 <vprintf+0x1c2>
 8b6:	fc26                	sd	s1,56(sp)
 8b8:	f44e                	sd	s3,40(sp)
 8ba:	f052                	sd	s4,32(sp)
 8bc:	ec56                	sd	s5,24(sp)
 8be:	e85a                	sd	s6,16(sp)
 8c0:	e45e                	sd	s7,8(sp)
 8c2:	8aaa                	mv	s5,a0
 8c4:	8bb2                	mv	s7,a2
 8c6:	00158493          	addi	s1,a1,1
  state = 0;
 8ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8cc:	02500a13          	li	s4,37
 8d0:	4b55                	li	s6,21
 8d2:	a839                	j	8f0 <vprintf+0x4c>
        putc(fd, c);
 8d4:	85ca                	mv	a1,s2
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	efe080e7          	jalr	-258(ra) # 7d6 <putc>
 8e0:	a019                	j	8e6 <vprintf+0x42>
    } else if(state == '%'){
 8e2:	01498d63          	beq	s3,s4,8fc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 8e6:	0485                	addi	s1,s1,1
 8e8:	fff4c903          	lbu	s2,-1(s1)
 8ec:	16090763          	beqz	s2,a5a <vprintf+0x1b6>
    if(state == 0){
 8f0:	fe0999e3          	bnez	s3,8e2 <vprintf+0x3e>
      if(c == '%'){
 8f4:	ff4910e3          	bne	s2,s4,8d4 <vprintf+0x30>
        state = '%';
 8f8:	89d2                	mv	s3,s4
 8fa:	b7f5                	j	8e6 <vprintf+0x42>
      if(c == 'd'){
 8fc:	13490463          	beq	s2,s4,a24 <vprintf+0x180>
 900:	f9d9079b          	addiw	a5,s2,-99
 904:	0ff7f793          	zext.b	a5,a5
 908:	12fb6763          	bltu	s6,a5,a36 <vprintf+0x192>
 90c:	f9d9079b          	addiw	a5,s2,-99
 910:	0ff7f713          	zext.b	a4,a5
 914:	12eb6163          	bltu	s6,a4,a36 <vprintf+0x192>
 918:	00271793          	slli	a5,a4,0x2
 91c:	00000717          	auipc	a4,0x0
 920:	72470713          	addi	a4,a4,1828 # 1040 <ithread_join+0x1e4>
 924:	97ba                	add	a5,a5,a4
 926:	439c                	lw	a5,0(a5)
 928:	97ba                	add	a5,a5,a4
 92a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 92c:	008b8913          	addi	s2,s7,8
 930:	4685                	li	a3,1
 932:	4629                	li	a2,10
 934:	000ba583          	lw	a1,0(s7)
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	ebe080e7          	jalr	-322(ra) # 7f8 <printint>
 942:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 944:	4981                	li	s3,0
 946:	b745                	j	8e6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 948:	008b8913          	addi	s2,s7,8
 94c:	4681                	li	a3,0
 94e:	4629                	li	a2,10
 950:	000ba583          	lw	a1,0(s7)
 954:	8556                	mv	a0,s5
 956:	00000097          	auipc	ra,0x0
 95a:	ea2080e7          	jalr	-350(ra) # 7f8 <printint>
 95e:	8bca                	mv	s7,s2
      state = 0;
 960:	4981                	li	s3,0
 962:	b751                	j	8e6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 964:	008b8913          	addi	s2,s7,8
 968:	4681                	li	a3,0
 96a:	4641                	li	a2,16
 96c:	000ba583          	lw	a1,0(s7)
 970:	8556                	mv	a0,s5
 972:	00000097          	auipc	ra,0x0
 976:	e86080e7          	jalr	-378(ra) # 7f8 <printint>
 97a:	8bca                	mv	s7,s2
      state = 0;
 97c:	4981                	li	s3,0
 97e:	b7a5                	j	8e6 <vprintf+0x42>
 980:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 982:	008b8c13          	addi	s8,s7,8
 986:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 98a:	03000593          	li	a1,48
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	e46080e7          	jalr	-442(ra) # 7d6 <putc>
  putc(fd, 'x');
 998:	07800593          	li	a1,120
 99c:	8556                	mv	a0,s5
 99e:	00000097          	auipc	ra,0x0
 9a2:	e38080e7          	jalr	-456(ra) # 7d6 <putc>
 9a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a8:	00000b97          	auipc	s7,0x0
 9ac:	6f0b8b93          	addi	s7,s7,1776 # 1098 <digits>
 9b0:	03c9d793          	srli	a5,s3,0x3c
 9b4:	97de                	add	a5,a5,s7
 9b6:	0007c583          	lbu	a1,0(a5)
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e1a080e7          	jalr	-486(ra) # 7d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9c4:	0992                	slli	s3,s3,0x4
 9c6:	397d                	addiw	s2,s2,-1
 9c8:	fe0914e3          	bnez	s2,9b0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 9cc:	8be2                	mv	s7,s8
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	6c02                	ld	s8,0(sp)
 9d2:	bf11                	j	8e6 <vprintf+0x42>
        s = va_arg(ap, char*);
 9d4:	008b8993          	addi	s3,s7,8
 9d8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 9dc:	02090163          	beqz	s2,9fe <vprintf+0x15a>
        while(*s != 0){
 9e0:	00094583          	lbu	a1,0(s2)
 9e4:	c9a5                	beqz	a1,a54 <vprintf+0x1b0>
          putc(fd, *s);
 9e6:	8556                	mv	a0,s5
 9e8:	00000097          	auipc	ra,0x0
 9ec:	dee080e7          	jalr	-530(ra) # 7d6 <putc>
          s++;
 9f0:	0905                	addi	s2,s2,1
        while(*s != 0){
 9f2:	00094583          	lbu	a1,0(s2)
 9f6:	f9e5                	bnez	a1,9e6 <vprintf+0x142>
        s = va_arg(ap, char*);
 9f8:	8bce                	mv	s7,s3
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b5ed                	j	8e6 <vprintf+0x42>
          s = "(null)";
 9fe:	00000917          	auipc	s2,0x0
 a02:	60a90913          	addi	s2,s2,1546 # 1008 <ithread_join+0x1ac>
        while(*s != 0){
 a06:	02800593          	li	a1,40
 a0a:	bff1                	j	9e6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 a0c:	008b8913          	addi	s2,s7,8
 a10:	000bc583          	lbu	a1,0(s7)
 a14:	8556                	mv	a0,s5
 a16:	00000097          	auipc	ra,0x0
 a1a:	dc0080e7          	jalr	-576(ra) # 7d6 <putc>
 a1e:	8bca                	mv	s7,s2
      state = 0;
 a20:	4981                	li	s3,0
 a22:	b5d1                	j	8e6 <vprintf+0x42>
        putc(fd, c);
 a24:	02500593          	li	a1,37
 a28:	8556                	mv	a0,s5
 a2a:	00000097          	auipc	ra,0x0
 a2e:	dac080e7          	jalr	-596(ra) # 7d6 <putc>
      state = 0;
 a32:	4981                	li	s3,0
 a34:	bd4d                	j	8e6 <vprintf+0x42>
        putc(fd, '%');
 a36:	02500593          	li	a1,37
 a3a:	8556                	mv	a0,s5
 a3c:	00000097          	auipc	ra,0x0
 a40:	d9a080e7          	jalr	-614(ra) # 7d6 <putc>
        putc(fd, c);
 a44:	85ca                	mv	a1,s2
 a46:	8556                	mv	a0,s5
 a48:	00000097          	auipc	ra,0x0
 a4c:	d8e080e7          	jalr	-626(ra) # 7d6 <putc>
      state = 0;
 a50:	4981                	li	s3,0
 a52:	bd51                	j	8e6 <vprintf+0x42>
        s = va_arg(ap, char*);
 a54:	8bce                	mv	s7,s3
      state = 0;
 a56:	4981                	li	s3,0
 a58:	b579                	j	8e6 <vprintf+0x42>
 a5a:	74e2                	ld	s1,56(sp)
 a5c:	79a2                	ld	s3,40(sp)
 a5e:	7a02                	ld	s4,32(sp)
 a60:	6ae2                	ld	s5,24(sp)
 a62:	6b42                	ld	s6,16(sp)
 a64:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a66:	60a6                	ld	ra,72(sp)
 a68:	6406                	ld	s0,64(sp)
 a6a:	7942                	ld	s2,48(sp)
 a6c:	6161                	addi	sp,sp,80
 a6e:	8082                	ret

0000000000000a70 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a70:	715d                	addi	sp,sp,-80
 a72:	ec06                	sd	ra,24(sp)
 a74:	e822                	sd	s0,16(sp)
 a76:	1000                	addi	s0,sp,32
 a78:	e010                	sd	a2,0(s0)
 a7a:	e414                	sd	a3,8(s0)
 a7c:	e818                	sd	a4,16(s0)
 a7e:	ec1c                	sd	a5,24(s0)
 a80:	03043023          	sd	a6,32(s0)
 a84:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a88:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a8c:	8622                	mv	a2,s0
 a8e:	00000097          	auipc	ra,0x0
 a92:	e16080e7          	jalr	-490(ra) # 8a4 <vprintf>
}
 a96:	60e2                	ld	ra,24(sp)
 a98:	6442                	ld	s0,16(sp)
 a9a:	6161                	addi	sp,sp,80
 a9c:	8082                	ret

0000000000000a9e <printf>:

void
printf(const char *fmt, ...)
{
 a9e:	711d                	addi	sp,sp,-96
 aa0:	ec06                	sd	ra,24(sp)
 aa2:	e822                	sd	s0,16(sp)
 aa4:	1000                	addi	s0,sp,32
 aa6:	e40c                	sd	a1,8(s0)
 aa8:	e810                	sd	a2,16(s0)
 aaa:	ec14                	sd	a3,24(s0)
 aac:	f018                	sd	a4,32(s0)
 aae:	f41c                	sd	a5,40(s0)
 ab0:	03043823          	sd	a6,48(s0)
 ab4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ab8:	00840613          	addi	a2,s0,8
 abc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ac0:	85aa                	mv	a1,a0
 ac2:	4505                	li	a0,1
 ac4:	00000097          	auipc	ra,0x0
 ac8:	de0080e7          	jalr	-544(ra) # 8a4 <vprintf>
}
 acc:	60e2                	ld	ra,24(sp)
 ace:	6442                	ld	s0,16(sp)
 ad0:	6125                	addi	sp,sp,96
 ad2:	8082                	ret

0000000000000ad4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad4:	1141                	addi	sp,sp,-16
 ad6:	e422                	sd	s0,8(sp)
 ad8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ada:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ade:	00001797          	auipc	a5,0x1
 ae2:	5327b783          	ld	a5,1330(a5) # 2010 <freep>
 ae6:	a02d                	j	b10 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ae8:	4618                	lw	a4,8(a2)
 aea:	9f2d                	addw	a4,a4,a1
 aec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 af0:	6398                	ld	a4,0(a5)
 af2:	6310                	ld	a2,0(a4)
 af4:	a83d                	j	b32 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 af6:	ff852703          	lw	a4,-8(a0)
 afa:	9f31                	addw	a4,a4,a2
 afc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 afe:	ff053683          	ld	a3,-16(a0)
 b02:	a091                	j	b46 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b04:	6398                	ld	a4,0(a5)
 b06:	00e7e463          	bltu	a5,a4,b0e <free+0x3a>
 b0a:	00e6ea63          	bltu	a3,a4,b1e <free+0x4a>
{
 b0e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b10:	fed7fae3          	bgeu	a5,a3,b04 <free+0x30>
 b14:	6398                	ld	a4,0(a5)
 b16:	00e6e463          	bltu	a3,a4,b1e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b1a:	fee7eae3          	bltu	a5,a4,b0e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b1e:	ff852583          	lw	a1,-8(a0)
 b22:	6390                	ld	a2,0(a5)
 b24:	02059813          	slli	a6,a1,0x20
 b28:	01c85713          	srli	a4,a6,0x1c
 b2c:	9736                	add	a4,a4,a3
 b2e:	fae60de3          	beq	a2,a4,ae8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b32:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b36:	4790                	lw	a2,8(a5)
 b38:	02061593          	slli	a1,a2,0x20
 b3c:	01c5d713          	srli	a4,a1,0x1c
 b40:	973e                	add	a4,a4,a5
 b42:	fae68ae3          	beq	a3,a4,af6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b46:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b48:	00001717          	auipc	a4,0x1
 b4c:	4cf73423          	sd	a5,1224(a4) # 2010 <freep>
}
 b50:	6422                	ld	s0,8(sp)
 b52:	0141                	addi	sp,sp,16
 b54:	8082                	ret

0000000000000b56 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b56:	7139                	addi	sp,sp,-64
 b58:	fc06                	sd	ra,56(sp)
 b5a:	f822                	sd	s0,48(sp)
 b5c:	f426                	sd	s1,40(sp)
 b5e:	ec4e                	sd	s3,24(sp)
 b60:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b62:	02051493          	slli	s1,a0,0x20
 b66:	9081                	srli	s1,s1,0x20
 b68:	04bd                	addi	s1,s1,15
 b6a:	8091                	srli	s1,s1,0x4
 b6c:	0014899b          	addiw	s3,s1,1
 b70:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b72:	00001517          	auipc	a0,0x1
 b76:	49e53503          	ld	a0,1182(a0) # 2010 <freep>
 b7a:	c915                	beqz	a0,bae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b7c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b7e:	4798                	lw	a4,8(a5)
 b80:	08977e63          	bgeu	a4,s1,c1c <malloc+0xc6>
 b84:	f04a                	sd	s2,32(sp)
 b86:	e852                	sd	s4,16(sp)
 b88:	e456                	sd	s5,8(sp)
 b8a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b8c:	8a4e                	mv	s4,s3
 b8e:	0009871b          	sext.w	a4,s3
 b92:	6685                	lui	a3,0x1
 b94:	00d77363          	bgeu	a4,a3,b9a <malloc+0x44>
 b98:	6a05                	lui	s4,0x1
 b9a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b9e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ba2:	00001917          	auipc	s2,0x1
 ba6:	46e90913          	addi	s2,s2,1134 # 2010 <freep>
  if(p == (char*)-1)
 baa:	5afd                	li	s5,-1
 bac:	a091                	j	bf0 <malloc+0x9a>
 bae:	f04a                	sd	s2,32(sp)
 bb0:	e852                	sd	s4,16(sp)
 bb2:	e456                	sd	s5,8(sp)
 bb4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bb6:	00001797          	auipc	a5,0x1
 bba:	47a78793          	addi	a5,a5,1146 # 2030 <base>
 bbe:	00001717          	auipc	a4,0x1
 bc2:	44f73923          	sd	a5,1106(a4) # 2010 <freep>
 bc6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bc8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bcc:	b7c1                	j	b8c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 bce:	6398                	ld	a4,0(a5)
 bd0:	e118                	sd	a4,0(a0)
 bd2:	a08d                	j	c34 <malloc+0xde>
  hp->s.size = nu;
 bd4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bd8:	0541                	addi	a0,a0,16
 bda:	00000097          	auipc	ra,0x0
 bde:	efa080e7          	jalr	-262(ra) # ad4 <free>
  return freep;
 be2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 be6:	c13d                	beqz	a0,c4c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bea:	4798                	lw	a4,8(a5)
 bec:	02977463          	bgeu	a4,s1,c14 <malloc+0xbe>
    if(p == freep)
 bf0:	00093703          	ld	a4,0(s2)
 bf4:	853e                	mv	a0,a5
 bf6:	fef719e3          	bne	a4,a5,be8 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 bfa:	8552                	mv	a0,s4
 bfc:	00000097          	auipc	ra,0x0
 c00:	b54080e7          	jalr	-1196(ra) # 750 <sbrk>
  if(p == (char*)-1)
 c04:	fd5518e3          	bne	a0,s5,bd4 <malloc+0x7e>
        return 0;
 c08:	4501                	li	a0,0
 c0a:	7902                	ld	s2,32(sp)
 c0c:	6a42                	ld	s4,16(sp)
 c0e:	6aa2                	ld	s5,8(sp)
 c10:	6b02                	ld	s6,0(sp)
 c12:	a03d                	j	c40 <malloc+0xea>
 c14:	7902                	ld	s2,32(sp)
 c16:	6a42                	ld	s4,16(sp)
 c18:	6aa2                	ld	s5,8(sp)
 c1a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c1c:	fae489e3          	beq	s1,a4,bce <malloc+0x78>
        p->s.size -= nunits;
 c20:	4137073b          	subw	a4,a4,s3
 c24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c26:	02071693          	slli	a3,a4,0x20
 c2a:	01c6d713          	srli	a4,a3,0x1c
 c2e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c30:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c34:	00001717          	auipc	a4,0x1
 c38:	3ca73e23          	sd	a0,988(a4) # 2010 <freep>
      return (void*)(p + 1);
 c3c:	01078513          	addi	a0,a5,16
  }
}
 c40:	70e2                	ld	ra,56(sp)
 c42:	7442                	ld	s0,48(sp)
 c44:	74a2                	ld	s1,40(sp)
 c46:	69e2                	ld	s3,24(sp)
 c48:	6121                	addi	sp,sp,64
 c4a:	8082                	ret
 c4c:	7902                	ld	s2,32(sp)
 c4e:	6a42                	ld	s4,16(sp)
 c50:	6aa2                	ld	s5,8(sp)
 c52:	6b02                	ld	s6,0(sp)
 c54:	b7f5                	j	c40 <malloc+0xea>

0000000000000c56 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 c56:	1141                	addi	sp,sp,-16
 c58:	e406                	sd	ra,8(sp)
 c5a:	e022                	sd	s0,0(sp)
 c5c:	0800                	addi	s0,sp,16
  thread_exit(status);
 c5e:	2501                	sext.w	a0,a0
 c60:	00000097          	auipc	ra,0x0
 c64:	b20080e7          	jalr	-1248(ra) # 780 <thread_exit>
}
 c68:	60a2                	ld	ra,8(sp)
 c6a:	6402                	ld	s0,0(sp)
 c6c:	0141                	addi	sp,sp,16
 c6e:	8082                	ret

0000000000000c70 <free_stacks>:
int free_stacks() {
 c70:	7179                	addi	sp,sp,-48
 c72:	f406                	sd	ra,40(sp)
 c74:	f022                	sd	s0,32(sp)
 c76:	ec26                	sd	s1,24(sp)
 c78:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 c7a:	00001797          	auipc	a5,0x1
 c7e:	3a67a783          	lw	a5,934(a5) # 2020 <num_threads>
 c82:	04f05063          	blez	a5,cc2 <free_stacks+0x52>
 c86:	e84a                	sd	s2,16(sp)
 c88:	e44e                	sd	s3,8(sp)
 c8a:	4481                	li	s1,0
    free(stacks[i]);
 c8c:	00001997          	auipc	s3,0x1
 c90:	38c98993          	addi	s3,s3,908 # 2018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 c94:	00001917          	auipc	s2,0x1
 c98:	38c90913          	addi	s2,s2,908 # 2020 <num_threads>
    free(stacks[i]);
 c9c:	0009b783          	ld	a5,0(s3)
 ca0:	00349713          	slli	a4,s1,0x3
 ca4:	97ba                	add	a5,a5,a4
 ca6:	6388                	ld	a0,0(a5)
 ca8:	00000097          	auipc	ra,0x0
 cac:	e2c080e7          	jalr	-468(ra) # ad4 <free>
  for (int i = 0; i < num_threads; i++) {
 cb0:	0485                	addi	s1,s1,1
 cb2:	00092703          	lw	a4,0(s2)
 cb6:	0004879b          	sext.w	a5,s1
 cba:	fee7c1e3          	blt	a5,a4,c9c <free_stacks+0x2c>
 cbe:	6942                	ld	s2,16(sp)
 cc0:	69a2                	ld	s3,8(sp)
  free(stacks);
 cc2:	00001497          	auipc	s1,0x1
 cc6:	35648493          	addi	s1,s1,854 # 2018 <stacks>
 cca:	6088                	ld	a0,0(s1)
 ccc:	00000097          	auipc	ra,0x0
 cd0:	e08080e7          	jalr	-504(ra) # ad4 <free>
  stacks = 0;
 cd4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 cd8:	00001797          	auipc	a5,0x1
 cdc:	3407a423          	sw	zero,840(a5) # 2020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 ce0:	47a1                	li	a5,8
 ce2:	00001717          	auipc	a4,0x1
 ce6:	30f72f23          	sw	a5,798(a4) # 2000 <max_stacks>
  threads_done = 0;
 cea:	00001797          	auipc	a5,0x1
 cee:	3207ad23          	sw	zero,826(a5) # 2024 <threads_done>
}
 cf2:	4501                	li	a0,0
 cf4:	70a2                	ld	ra,40(sp)
 cf6:	7402                	ld	s0,32(sp)
 cf8:	64e2                	ld	s1,24(sp)
 cfa:	6145                	addi	sp,sp,48
 cfc:	8082                	ret

0000000000000cfe <expand_num_threads>:
int expand_num_threads() {
 cfe:	1101                	addi	sp,sp,-32
 d00:	ec06                	sd	ra,24(sp)
 d02:	e822                	sd	s0,16(sp)
 d04:	e426                	sd	s1,8(sp)
 d06:	e04a                	sd	s2,0(sp)
 d08:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 d0a:	00001797          	auipc	a5,0x1
 d0e:	2f678793          	addi	a5,a5,758 # 2000 <max_stacks>
 d12:	4388                	lw	a0,0(a5)
 d14:	0015151b          	slliw	a0,a0,0x1
 d18:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 d1a:	0035151b          	slliw	a0,a0,0x3
 d1e:	00000097          	auipc	ra,0x0
 d22:	e38080e7          	jalr	-456(ra) # b56 <malloc>
 d26:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 d28:	00001617          	auipc	a2,0x1
 d2c:	2f862603          	lw	a2,760(a2) # 2020 <num_threads>
 d30:	00001497          	auipc	s1,0x1
 d34:	2e848493          	addi	s1,s1,744 # 2018 <stacks>
 d38:	0036161b          	slliw	a2,a2,0x3
 d3c:	608c                	ld	a1,0(s1)
 d3e:	00000097          	auipc	ra,0x0
 d42:	840080e7          	jalr	-1984(ra) # 57e <memmove>
  free(stacks);
 d46:	6088                	ld	a0,0(s1)
 d48:	00000097          	auipc	ra,0x0
 d4c:	d8c080e7          	jalr	-628(ra) # ad4 <free>
  stacks = new_stacks;
 d50:	0124b023          	sd	s2,0(s1)
}
 d54:	4501                	li	a0,0
 d56:	60e2                	ld	ra,24(sp)
 d58:	6442                	ld	s0,16(sp)
 d5a:	64a2                	ld	s1,8(sp)
 d5c:	6902                	ld	s2,0(sp)
 d5e:	6105                	addi	sp,sp,32
 d60:	8082                	ret

0000000000000d62 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 d62:	7179                	addi	sp,sp,-48
 d64:	f406                	sd	ra,40(sp)
 d66:	f022                	sd	s0,32(sp)
 d68:	e84a                	sd	s2,16(sp)
 d6a:	e44e                	sd	s3,8(sp)
 d6c:	1800                	addi	s0,sp,48
 d6e:	892a                	mv	s2,a0
 d70:	89ae                	mv	s3,a1
  if (stacks == 0) {
 d72:	00001797          	auipc	a5,0x1
 d76:	2a67b783          	ld	a5,678(a5) # 2018 <stacks>
 d7a:	c3d9                	beqz	a5,e00 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 d7c:	00001797          	auipc	a5,0x1
 d80:	2847a783          	lw	a5,644(a5) # 2000 <max_stacks>
 d84:	00001717          	auipc	a4,0x1
 d88:	29c72703          	lw	a4,668(a4) # 2020 <num_threads>
 d8c:	0af71363          	bne	a4,a5,e32 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 d90:	04000713          	li	a4,64
 d94:	08e78563          	beq	a5,a4,e1e <ithread_create+0xbc>
 d98:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 d9a:	00000097          	auipc	ra,0x0
 d9e:	f64080e7          	jalr	-156(ra) # cfe <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 da2:	6505                	lui	a0,0x1
 da4:	00000097          	auipc	ra,0x0
 da8:	db2080e7          	jalr	-590(ra) # b56 <malloc>
 dac:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 dae:	00001717          	auipc	a4,0x1
 db2:	27272703          	lw	a4,626(a4) # 2020 <num_threads>
 db6:	070e                	slli	a4,a4,0x3
 db8:	00001797          	auipc	a5,0x1
 dbc:	2607b783          	ld	a5,608(a5) # 2018 <stacks>
 dc0:	97ba                	add	a5,a5,a4
 dc2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 dc4:	00000697          	auipc	a3,0x0
 dc8:	e9268693          	addi	a3,a3,-366 # c56 <ithread_exit>
 dcc:	862a                	mv	a2,a0
 dce:	85ce                	mv	a1,s3
 dd0:	854a                	mv	a0,s2
 dd2:	00000097          	auipc	ra,0x0
 dd6:	99e080e7          	jalr	-1634(ra) # 770 <create_thread>
 dda:	892a                	mv	s2,a0
  if (res != -1) {
 ddc:	57fd                	li	a5,-1
 dde:	04f50c63          	beq	a0,a5,e36 <ithread_create+0xd4>
    num_threads++;
 de2:	00001717          	auipc	a4,0x1
 de6:	23e70713          	addi	a4,a4,574 # 2020 <num_threads>
 dea:	431c                	lw	a5,0(a4)
 dec:	2785                	addiw	a5,a5,1
 dee:	c31c                	sw	a5,0(a4)
 df0:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 df2:	854a                	mv	a0,s2
 df4:	70a2                	ld	ra,40(sp)
 df6:	7402                	ld	s0,32(sp)
 df8:	6942                	ld	s2,16(sp)
 dfa:	69a2                	ld	s3,8(sp)
 dfc:	6145                	addi	sp,sp,48
 dfe:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 e00:	00001517          	auipc	a0,0x1
 e04:	20052503          	lw	a0,512(a0) # 2000 <max_stacks>
 e08:	0035151b          	slliw	a0,a0,0x3
 e0c:	00000097          	auipc	ra,0x0
 e10:	d4a080e7          	jalr	-694(ra) # b56 <malloc>
 e14:	00001797          	auipc	a5,0x1
 e18:	20a7b223          	sd	a0,516(a5) # 2018 <stacks>
 e1c:	b785                	j	d7c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 e1e:	00000517          	auipc	a0,0x0
 e22:	1f250513          	addi	a0,a0,498 # 1010 <ithread_join+0x1b4>
 e26:	00000097          	auipc	ra,0x0
 e2a:	c78080e7          	jalr	-904(ra) # a9e <printf>
      return -1;
 e2e:	597d                	li	s2,-1
 e30:	b7c9                	j	df2 <ithread_create+0x90>
 e32:	ec26                	sd	s1,24(sp)
 e34:	b7bd                	j	da2 <ithread_create+0x40>
    free(stack_ptr);
 e36:	8526                	mv	a0,s1
 e38:	00000097          	auipc	ra,0x0
 e3c:	c9c080e7          	jalr	-868(ra) # ad4 <free>
    stacks[num_threads] = 0;
 e40:	00001717          	auipc	a4,0x1
 e44:	1e072703          	lw	a4,480(a4) # 2020 <num_threads>
 e48:	070e                	slli	a4,a4,0x3
 e4a:	00001797          	auipc	a5,0x1
 e4e:	1ce7b783          	ld	a5,462(a5) # 2018 <stacks>
 e52:	97ba                	add	a5,a5,a4
 e54:	0007b023          	sd	zero,0(a5)
 e58:	64e2                	ld	s1,24(sp)
 e5a:	bf61                	j	df2 <ithread_create+0x90>

0000000000000e5c <ithread_join>:

int ithread_join(int thread_id) {
 e5c:	1101                	addi	sp,sp,-32
 e5e:	ec06                	sd	ra,24(sp)
 e60:	e822                	sd	s0,16(sp)
 e62:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 e64:	ff040793          	addi	a5,s0,-16
 e68:	ffc7859b          	addiw	a1,a5,-4
 e6c:	00000097          	auipc	ra,0x0
 e70:	90c080e7          	jalr	-1780(ra) # 778 <join_thread>
  threads_done++;
 e74:	00001717          	auipc	a4,0x1
 e78:	1b070713          	addi	a4,a4,432 # 2024 <threads_done>
 e7c:	431c                	lw	a5,0(a4)
 e7e:	2785                	addiw	a5,a5,1
 e80:	0007869b          	sext.w	a3,a5
 e84:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 e86:	00001797          	auipc	a5,0x1
 e8a:	19a7a783          	lw	a5,410(a5) # 2020 <num_threads>
 e8e:	00d78863          	beq	a5,a3,e9e <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 e92:	fec42503          	lw	a0,-20(s0)
 e96:	60e2                	ld	ra,24(sp)
 e98:	6442                	ld	s0,16(sp)
 e9a:	6105                	addi	sp,sp,32
 e9c:	8082                	ret
    free_stacks();
 e9e:	00000097          	auipc	ra,0x0
 ea2:	dd2080e7          	jalr	-558(ra) # c70 <free_stacks>
 ea6:	b7f5                	j	e92 <ithread_join+0x36>
