
src/user/_net_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <udp_cli>:
#define CLITEST_SERVER_PORT 20000
#define CLITEST_CLIENT_PORT 78

#define CLITEST_SERVER_ADDR 0x0a0a0003

void udp_cli(void) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	0880                	addi	s0,sp,80
  int sockfd;
  char *msg = "hello over udp";
   a:	00001797          	auipc	a5,0x1
   e:	d3678793          	addi	a5,a5,-714 # d40 <ithread_join+0x4e>
  12:	fcf43c23          	sd	a5,-40(s0)
  struct sockaddr_in server_addr, client_addr;
  char buf[64];

  printf("TESTING UDP CLIENT...\n");
  16:	00001517          	auipc	a0,0x1
  1a:	d4250513          	addi	a0,a0,-702 # d58 <ithread_join+0x66>
  1e:	00001097          	auipc	ra,0x1
  22:	916080e7          	jalr	-1770(ra) # 934 <printf>

  memset(&server_addr, 0, sizeof(server_addr));
  26:	4641                	li	a2,16
  28:	4581                	li	a1,0
  2a:	fc840513          	addi	a0,s0,-56
  2e:	00000097          	auipc	ra,0x0
  32:	336080e7          	jalr	822(ra) # 364 <memset>
  server_addr.sin_family = AF_INET;
  36:	4789                	li	a5,2
  38:	fcf41423          	sh	a5,-56(s0)
  server_addr.sin_port = htons(CLITEST_SERVER_PORT);
  3c:	6789                	lui	a5,0x2
  3e:	04e78793          	addi	a5,a5,78 # 204e <base+0x101e>
  42:	fcf41523          	sh	a5,-54(s0)
  server_addr.sin_addr.s_addr = htonl(CLITEST_SERVER_ADDR);
  46:	030017b7          	lui	a5,0x3001
  4a:	a0a78793          	addi	a5,a5,-1526 # 3000a0a <base+0x2fff9da>
  4e:	fcf42623          	sw	a5,-52(s0)

  /* --- Create client socket --- */
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  52:	4601                	li	a2,0
  54:	4589                	li	a1,2
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	5c6080e7          	jalr	1478(ra) # 61e <socket>
  if (sockfd < 0) {
  60:	08054763          	bltz	a0,ee <udp_cli+0xee>
  64:	84aa                	mv	s1,a0
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  66:	4641                	li	a2,16
  68:	4581                	li	a1,0
  6a:	fb840513          	addi	a0,s0,-72
  6e:	00000097          	auipc	ra,0x0
  72:	2f6080e7          	jalr	758(ra) # 364 <memset>
  client_addr.sin_family = AF_INET;
  76:	4789                	li	a5,2
  78:	faf41c23          	sh	a5,-72(s0)
  client_addr.sin_port = htons(CLITEST_CLIENT_PORT);
  7c:	6795                	lui	a5,0x5
  7e:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x3dd0>
  82:	faf41d23          	sh	a5,-70(s0)
  client_addr.sin_addr.s_addr = INADDR_ANY;
  86:	4785                	li	a5,1
  88:	faf42e23          	sw	a5,-68(s0)

  if (bind(sockfd, (struct sockaddr *)&client_addr, sizeof(client_addr)) <
  8c:	4641                	li	a2,16
  8e:	fb840593          	addi	a1,s0,-72
  92:	8526                	mv	a0,s1
  94:	00000097          	auipc	ra,0x0
  98:	592080e7          	jalr	1426(ra) # 626 <bind>
  9c:	06054663          	bltz	a0,108 <udp_cli+0x108>
    printf("client bind failed\n");
    exit(1);
  }

  /* --- Client sends message to server --- */
  printf("sending payload\n");
  a0:	00001517          	auipc	a0,0x1
  a4:	d0050513          	addi	a0,a0,-768 # da0 <ithread_join+0xae>
  a8:	00001097          	auipc	ra,0x1
  ac:	88c080e7          	jalr	-1908(ra) # 934 <printf>
  if (sendto(sockfd, &msg, strlen(msg), 0, (struct sockaddr *)&server_addr,
  b0:	fd843503          	ld	a0,-40(s0)
  b4:	00000097          	auipc	ra,0x0
  b8:	286080e7          	jalr	646(ra) # 33a <strlen>
  bc:	47c1                	li	a5,16
  be:	fc840713          	addi	a4,s0,-56
  c2:	4681                	li	a3,0
  c4:	0005061b          	sext.w	a2,a0
  c8:	fd840593          	addi	a1,s0,-40
  cc:	8526                	mv	a0,s1
  ce:	00000097          	auipc	ra,0x0
  d2:	58a080e7          	jalr	1418(ra) # 658 <sendto>
  d6:	04054663          	bltz	a0,122 <udp_cli+0x122>
             sizeof(server_addr)) < 0) {
    printf("sendto failed\n");
    exit(1);
  }

  close(sockfd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	4aa080e7          	jalr	1194(ra) # 586 <close>
}
  e4:	60a6                	ld	ra,72(sp)
  e6:	6406                	ld	s0,64(sp)
  e8:	74e2                	ld	s1,56(sp)
  ea:	6161                	addi	sp,sp,80
  ec:	8082                	ret
    printf("client socket failed\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	c8250513          	addi	a0,a0,-894 # d70 <ithread_join+0x7e>
  f6:	00001097          	auipc	ra,0x1
  fa:	83e080e7          	jalr	-1986(ra) # 934 <printf>
    exit(1);
  fe:	4505                	li	a0,1
 100:	00000097          	auipc	ra,0x0
 104:	45e080e7          	jalr	1118(ra) # 55e <exit>
    printf("client bind failed\n");
 108:	00001517          	auipc	a0,0x1
 10c:	c8050513          	addi	a0,a0,-896 # d88 <ithread_join+0x96>
 110:	00001097          	auipc	ra,0x1
 114:	824080e7          	jalr	-2012(ra) # 934 <printf>
    exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	444080e7          	jalr	1092(ra) # 55e <exit>
    printf("sendto failed\n");
 122:	00001517          	auipc	a0,0x1
 126:	c9650513          	addi	a0,a0,-874 # db8 <ithread_join+0xc6>
 12a:	00001097          	auipc	ra,0x1
 12e:	80a080e7          	jalr	-2038(ra) # 934 <printf>
    exit(1);
 132:	4505                	li	a0,1
 134:	00000097          	auipc	ra,0x0
 138:	42a080e7          	jalr	1066(ra) # 55e <exit>

000000000000013c <udp_srv>:

void udp_srv(void) {
 13c:	7135                	addi	sp,sp,-160
 13e:	ed06                	sd	ra,152(sp)
 140:	e922                	sd	s0,144(sp)
 142:	1100                	addi	s0,sp,160
  int sockfd;
  struct sockaddr_in server_addr, client_addr;
  char buf[64];


  printf("TESTING UDP SERVER...\n");
 144:	00001517          	auipc	a0,0x1
 148:	c8450513          	addi	a0,a0,-892 # dc8 <ithread_join+0xd6>
 14c:	00000097          	auipc	ra,0x0
 150:	7e8080e7          	jalr	2024(ra) # 934 <printf>

  // --- Create server socket
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 154:	4601                	li	a2,0
 156:	4589                	li	a1,2
 158:	4509                	li	a0,2
 15a:	00000097          	auipc	ra,0x0
 15e:	4c4080e7          	jalr	1220(ra) # 61e <socket>
  if (sockfd < 0) {
 162:	0a054c63          	bltz	a0,21a <udp_srv+0xde>
 166:	e526                	sd	s1,136(sp)
 168:	84aa                	mv	s1,a0
    printf("server socket failed\n");
    exit(1);
  }

  memset(&server_addr, 0, sizeof(server_addr));
 16a:	4641                	li	a2,16
 16c:	4581                	li	a1,0
 16e:	fc040513          	addi	a0,s0,-64
 172:	00000097          	auipc	ra,0x0
 176:	1f2080e7          	jalr	498(ra) # 364 <memset>
  server_addr.sin_family = AF_INET;
 17a:	4789                	li	a5,2
 17c:	fcf41023          	sh	a5,-64(s0)
  server_addr.sin_port = htons(SRVTEST_SERVER_PORT);
 180:	6795                	lui	a5,0x5
 182:	e0078793          	addi	a5,a5,-512 # 4e00 <base+0x3dd0>
 186:	fcf41123          	sh	a5,-62(s0)
  server_addr.sin_addr.s_addr = htonl(0xc0a8fe74);
 18a:	74feb7b7          	lui	a5,0x74feb
 18e:	8c078793          	addi	a5,a5,-1856 # 74fea8c0 <base+0x74fe9890>
 192:	fcf42223          	sw	a5,-60(s0)

  if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
 196:	4641                	li	a2,16
 198:	fc040593          	addi	a1,s0,-64
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	488080e7          	jalr	1160(ra) # 626 <bind>
 1a6:	08054b63          	bltz	a0,23c <udp_srv+0x100>
 1aa:	e14a                	sd	s2,128(sp)
 1ac:	fcce                	sd	s3,120(sp)
 1ae:	f8d2                	sd	s4,112(sp)
    printf("server bind failed\n");
    exit(1);
  }

  // --- Server receives message
  int fromlen = sizeof(client_addr);
 1b0:	47c1                	li	a5,16
 1b2:	f6f42623          	sw	a5,-148(s0)
  while (1) {
  printf("waiting for packet...\n");
 1b6:	00001a17          	auipc	s4,0x1
 1ba:	c5aa0a13          	addi	s4,s4,-934 # e10 <ithread_join+0x11e>
    int n = recvfrom(sockfd, buf, sizeof(buf)-1, 0,
        (struct sockaddr *)&client_addr, &fromlen);
    buf[n] = '\0';

    printf("UDP PACKET RECEIVED: \n\t");
 1be:	00001997          	auipc	s3,0x1
 1c2:	c6a98993          	addi	s3,s3,-918 # e28 <ithread_join+0x136>
    printf("%s\n", buf);
 1c6:	00001917          	auipc	s2,0x1
 1ca:	c7a90913          	addi	s2,s2,-902 # e40 <ithread_join+0x14e>
  printf("waiting for packet...\n");
 1ce:	8552                	mv	a0,s4
 1d0:	00000097          	auipc	ra,0x0
 1d4:	764080e7          	jalr	1892(ra) # 934 <printf>
    int n = recvfrom(sockfd, buf, sizeof(buf)-1, 0,
 1d8:	f6c40793          	addi	a5,s0,-148
 1dc:	fb040713          	addi	a4,s0,-80
 1e0:	4681                	li	a3,0
 1e2:	03f00613          	li	a2,63
 1e6:	f7040593          	addi	a1,s0,-144
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	476080e7          	jalr	1142(ra) # 662 <recvfrom>
    buf[n] = '\0';
 1f4:	fd050793          	addi	a5,a0,-48
 1f8:	00878533          	add	a0,a5,s0
 1fc:	fa050023          	sb	zero,-96(a0)
    printf("UDP PACKET RECEIVED: \n\t");
 200:	854e                	mv	a0,s3
 202:	00000097          	auipc	ra,0x0
 206:	732080e7          	jalr	1842(ra) # 934 <printf>
    printf("%s\n", buf);
 20a:	f7040593          	addi	a1,s0,-144
 20e:	854a                	mv	a0,s2
 210:	00000097          	auipc	ra,0x0
 214:	724080e7          	jalr	1828(ra) # 934 <printf>
  while (1) {
 218:	bf5d                	j	1ce <udp_srv+0x92>
 21a:	e526                	sd	s1,136(sp)
 21c:	e14a                	sd	s2,128(sp)
 21e:	fcce                	sd	s3,120(sp)
 220:	f8d2                	sd	s4,112(sp)
    printf("server socket failed\n");
 222:	00001517          	auipc	a0,0x1
 226:	bbe50513          	addi	a0,a0,-1090 # de0 <ithread_join+0xee>
 22a:	00000097          	auipc	ra,0x0
 22e:	70a080e7          	jalr	1802(ra) # 934 <printf>
    exit(1);
 232:	4505                	li	a0,1
 234:	00000097          	auipc	ra,0x0
 238:	32a080e7          	jalr	810(ra) # 55e <exit>
 23c:	e14a                	sd	s2,128(sp)
 23e:	fcce                	sd	s3,120(sp)
 240:	f8d2                	sd	s4,112(sp)
    printf("server bind failed\n");
 242:	00001517          	auipc	a0,0x1
 246:	bb650513          	addi	a0,a0,-1098 # df8 <ithread_join+0x106>
 24a:	00000097          	auipc	ra,0x0
 24e:	6ea080e7          	jalr	1770(ra) # 934 <printf>
    exit(1);
 252:	4505                	li	a0,1
 254:	00000097          	auipc	ra,0x0
 258:	30a080e7          	jalr	778(ra) # 55e <exit>

000000000000025c <main>:
  }

  close(sockfd);
}

int main(int argc, char **argv) {
 25c:	1101                	addi	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e426                	sd	s1,8(sp)
 264:	1000                	addi	s0,sp,32
 266:	84ae                	mv	s1,a1

  if (argc != 2) {
 268:	4789                	li	a5,2
 26a:	04f51063          	bne	a0,a5,2aa <main+0x4e>
    printf("Usage: net_test [ srv | cli | all ]\n");
  }

  if (strcmp(argv[1], "srv") == 0) {
 26e:	00001597          	auipc	a1,0x1
 272:	c0258593          	addi	a1,a1,-1022 # e70 <ithread_join+0x17e>
 276:	6488                	ld	a0,8(s1)
 278:	00000097          	auipc	ra,0x0
 27c:	096080e7          	jalr	150(ra) # 30e <strcmp>
 280:	cd15                	beqz	a0,2bc <main+0x60>
    udp_srv();
  } else if (strcmp(argv[1], "cli") == 0) {
 282:	00001597          	auipc	a1,0x1
 286:	bf658593          	addi	a1,a1,-1034 # e78 <ithread_join+0x186>
 28a:	6488                	ld	a0,8(s1)
 28c:	00000097          	auipc	ra,0x0
 290:	082080e7          	jalr	130(ra) # 30e <strcmp>
 294:	e905                	bnez	a0,2c4 <main+0x68>
    udp_cli();
 296:	00000097          	auipc	ra,0x0
 29a:	d6a080e7          	jalr	-662(ra) # 0 <udp_cli>
  } else if (strcmp(argv[1], "all") == 0) {
    // udp_all();
  }
}
 29e:	4501                	li	a0,0
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	64a2                	ld	s1,8(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    printf("Usage: net_test [ srv | cli | all ]\n");
 2aa:	00001517          	auipc	a0,0x1
 2ae:	b9e50513          	addi	a0,a0,-1122 # e48 <ithread_join+0x156>
 2b2:	00000097          	auipc	ra,0x0
 2b6:	682080e7          	jalr	1666(ra) # 934 <printf>
 2ba:	bf55                	j	26e <main+0x12>
    udp_srv();
 2bc:	00000097          	auipc	ra,0x0
 2c0:	e80080e7          	jalr	-384(ra) # 13c <udp_srv>
  } else if (strcmp(argv[1], "all") == 0) {
 2c4:	00001597          	auipc	a1,0x1
 2c8:	bbc58593          	addi	a1,a1,-1092 # e80 <ithread_join+0x18e>
 2cc:	6488                	ld	a0,8(s1)
 2ce:	00000097          	auipc	ra,0x0
 2d2:	040080e7          	jalr	64(ra) # 30e <strcmp>
 2d6:	b7e1                	j	29e <main+0x42>

00000000000002d8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e0:	00000097          	auipc	ra,0x0
 2e4:	f7c080e7          	jalr	-132(ra) # 25c <main>
  exit(0);
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	274080e7          	jalr	628(ra) # 55e <exit>

00000000000002f2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f8:	87aa                	mv	a5,a0
 2fa:	0585                	addi	a1,a1,1
 2fc:	0785                	addi	a5,a5,1
 2fe:	fff5c703          	lbu	a4,-1(a1)
 302:	fee78fa3          	sb	a4,-1(a5)
 306:	fb75                	bnez	a4,2fa <strcpy+0x8>
    ;
  return os;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb91                	beqz	a5,32c <strcmp+0x1e>
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00f71763          	bne	a4,a5,32c <strcmp+0x1e>
    p++, q++;
 322:	0505                	addi	a0,a0,1
 324:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 326:	00054783          	lbu	a5,0(a0)
 32a:	fbe5                	bnez	a5,31a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 32c:	0005c503          	lbu	a0,0(a1)
}
 330:	40a7853b          	subw	a0,a5,a0
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <strlen>:

uint
strlen(const char *s)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 340:	00054783          	lbu	a5,0(a0)
 344:	cf91                	beqz	a5,360 <strlen+0x26>
 346:	0505                	addi	a0,a0,1
 348:	87aa                	mv	a5,a0
 34a:	86be                	mv	a3,a5
 34c:	0785                	addi	a5,a5,1
 34e:	fff7c703          	lbu	a4,-1(a5)
 352:	ff65                	bnez	a4,34a <strlen+0x10>
 354:	40a6853b          	subw	a0,a3,a0
 358:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  for(n = 0; s[n]; n++)
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <strlen+0x20>

0000000000000364 <memset>:

void*
memset(void *dst, int c, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36a:	ca19                	beqz	a2,380 <memset+0x1c>
 36c:	87aa                	mv	a5,a0
 36e:	1602                	slli	a2,a2,0x20
 370:	9201                	srli	a2,a2,0x20
 372:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 376:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37a:	0785                	addi	a5,a5,1
 37c:	fee79de3          	bne	a5,a4,376 <memset+0x12>
  }
  return dst;
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <strchr>:

char*
strchr(const char *s, char c)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 38c:	00054783          	lbu	a5,0(a0)
 390:	cb99                	beqz	a5,3a6 <strchr+0x20>
    if(*s == c)
 392:	00f58763          	beq	a1,a5,3a0 <strchr+0x1a>
  for(; *s; s++)
 396:	0505                	addi	a0,a0,1
 398:	00054783          	lbu	a5,0(a0)
 39c:	fbfd                	bnez	a5,392 <strchr+0xc>
      return (char*)s;
  return 0;
 39e:	4501                	li	a0,0
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <strchr+0x1a>

00000000000003aa <gets>:

char*
gets(char *buf, int max)
{
 3aa:	711d                	addi	sp,sp,-96
 3ac:	ec86                	sd	ra,88(sp)
 3ae:	e8a2                	sd	s0,80(sp)
 3b0:	e4a6                	sd	s1,72(sp)
 3b2:	e0ca                	sd	s2,64(sp)
 3b4:	fc4e                	sd	s3,56(sp)
 3b6:	f852                	sd	s4,48(sp)
 3b8:	f456                	sd	s5,40(sp)
 3ba:	f05a                	sd	s6,32(sp)
 3bc:	ec5e                	sd	s7,24(sp)
 3be:	1080                	addi	s0,sp,96
 3c0:	8baa                	mv	s7,a0
 3c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c4:	892a                	mv	s2,a0
 3c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c8:	4aa9                	li	s5,10
 3ca:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3cc:	89a6                	mv	s3,s1
 3ce:	2485                	addiw	s1,s1,1
 3d0:	0344d863          	bge	s1,s4,400 <gets+0x56>
    cc = read(0, &c, 1);
 3d4:	4605                	li	a2,1
 3d6:	faf40593          	addi	a1,s0,-81
 3da:	4501                	li	a0,0
 3dc:	00000097          	auipc	ra,0x0
 3e0:	19a080e7          	jalr	410(ra) # 576 <read>
    if(cc < 1)
 3e4:	00a05e63          	blez	a0,400 <gets+0x56>
    buf[i++] = c;
 3e8:	faf44783          	lbu	a5,-81(s0)
 3ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f0:	01578763          	beq	a5,s5,3fe <gets+0x54>
 3f4:	0905                	addi	s2,s2,1
 3f6:	fd679be3          	bne	a5,s6,3cc <gets+0x22>
    buf[i++] = c;
 3fa:	89a6                	mv	s3,s1
 3fc:	a011                	j	400 <gets+0x56>
 3fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 400:	99de                	add	s3,s3,s7
 402:	00098023          	sb	zero,0(s3)
  return buf;
}
 406:	855e                	mv	a0,s7
 408:	60e6                	ld	ra,88(sp)
 40a:	6446                	ld	s0,80(sp)
 40c:	64a6                	ld	s1,72(sp)
 40e:	6906                	ld	s2,64(sp)
 410:	79e2                	ld	s3,56(sp)
 412:	7a42                	ld	s4,48(sp)
 414:	7aa2                	ld	s5,40(sp)
 416:	7b02                	ld	s6,32(sp)
 418:	6be2                	ld	s7,24(sp)
 41a:	6125                	addi	sp,sp,96
 41c:	8082                	ret

000000000000041e <stat>:

int
stat(const char *n, struct stat *st)
{
 41e:	1101                	addi	sp,sp,-32
 420:	ec06                	sd	ra,24(sp)
 422:	e822                	sd	s0,16(sp)
 424:	e04a                	sd	s2,0(sp)
 426:	1000                	addi	s0,sp,32
 428:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42a:	4581                	li	a1,0
 42c:	00000097          	auipc	ra,0x0
 430:	172080e7          	jalr	370(ra) # 59e <open>
  if(fd < 0)
 434:	02054663          	bltz	a0,460 <stat+0x42>
 438:	e426                	sd	s1,8(sp)
 43a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43c:	85ca                	mv	a1,s2
 43e:	00000097          	auipc	ra,0x0
 442:	178080e7          	jalr	376(ra) # 5b6 <fstat>
 446:	892a                	mv	s2,a0
  close(fd);
 448:	8526                	mv	a0,s1
 44a:	00000097          	auipc	ra,0x0
 44e:	13c080e7          	jalr	316(ra) # 586 <close>
  return r;
 452:	64a2                	ld	s1,8(sp)
}
 454:	854a                	mv	a0,s2
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6902                	ld	s2,0(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret
    return -1;
 460:	597d                	li	s2,-1
 462:	bfcd                	j	454 <stat+0x36>

0000000000000464 <atoi>:

int
atoi(const char *s)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46a:	00054683          	lbu	a3,0(a0)
 46e:	fd06879b          	addiw	a5,a3,-48
 472:	0ff7f793          	zext.b	a5,a5
 476:	4625                	li	a2,9
 478:	02f66863          	bltu	a2,a5,4a8 <atoi+0x44>
 47c:	872a                	mv	a4,a0
  n = 0;
 47e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 480:	0705                	addi	a4,a4,1
 482:	0025179b          	slliw	a5,a0,0x2
 486:	9fa9                	addw	a5,a5,a0
 488:	0017979b          	slliw	a5,a5,0x1
 48c:	9fb5                	addw	a5,a5,a3
 48e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 492:	00074683          	lbu	a3,0(a4)
 496:	fd06879b          	addiw	a5,a3,-48
 49a:	0ff7f793          	zext.b	a5,a5
 49e:	fef671e3          	bgeu	a2,a5,480 <atoi+0x1c>
  return n;
}
 4a2:	6422                	ld	s0,8(sp)
 4a4:	0141                	addi	sp,sp,16
 4a6:	8082                	ret
  n = 0;
 4a8:	4501                	li	a0,0
 4aa:	bfe5                	j	4a2 <atoi+0x3e>

00000000000004ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e422                	sd	s0,8(sp)
 4b0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b2:	02b57463          	bgeu	a0,a1,4da <memmove+0x2e>
    while(n-- > 0)
 4b6:	00c05f63          	blez	a2,4d4 <memmove+0x28>
 4ba:	1602                	slli	a2,a2,0x20
 4bc:	9201                	srli	a2,a2,0x20
 4be:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c4:	0585                	addi	a1,a1,1
 4c6:	0705                	addi	a4,a4,1
 4c8:	fff5c683          	lbu	a3,-1(a1)
 4cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d0:	fef71ae3          	bne	a4,a5,4c4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
    dst += n;
 4da:	00c50733          	add	a4,a0,a2
    src += n;
 4de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e0:	fec05ae3          	blez	a2,4d4 <memmove+0x28>
 4e4:	fff6079b          	addiw	a5,a2,-1
 4e8:	1782                	slli	a5,a5,0x20
 4ea:	9381                	srli	a5,a5,0x20
 4ec:	fff7c793          	not	a5,a5
 4f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f2:	15fd                	addi	a1,a1,-1
 4f4:	177d                	addi	a4,a4,-1
 4f6:	0005c683          	lbu	a3,0(a1)
 4fa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4fe:	fee79ae3          	bne	a5,a4,4f2 <memmove+0x46>
 502:	bfc9                	j	4d4 <memmove+0x28>

0000000000000504 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 504:	1141                	addi	sp,sp,-16
 506:	e422                	sd	s0,8(sp)
 508:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50a:	ca05                	beqz	a2,53a <memcmp+0x36>
 50c:	fff6069b          	addiw	a3,a2,-1
 510:	1682                	slli	a3,a3,0x20
 512:	9281                	srli	a3,a3,0x20
 514:	0685                	addi	a3,a3,1
 516:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 518:	00054783          	lbu	a5,0(a0)
 51c:	0005c703          	lbu	a4,0(a1)
 520:	00e79863          	bne	a5,a4,530 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 524:	0505                	addi	a0,a0,1
    p2++;
 526:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 528:	fed518e3          	bne	a0,a3,518 <memcmp+0x14>
  }
  return 0;
 52c:	4501                	li	a0,0
 52e:	a019                	j	534 <memcmp+0x30>
      return *p1 - *p2;
 530:	40e7853b          	subw	a0,a5,a4
}
 534:	6422                	ld	s0,8(sp)
 536:	0141                	addi	sp,sp,16
 538:	8082                	ret
  return 0;
 53a:	4501                	li	a0,0
 53c:	bfe5                	j	534 <memcmp+0x30>

000000000000053e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e406                	sd	ra,8(sp)
 542:	e022                	sd	s0,0(sp)
 544:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 546:	00000097          	auipc	ra,0x0
 54a:	f66080e7          	jalr	-154(ra) # 4ac <memmove>
}
 54e:	60a2                	ld	ra,8(sp)
 550:	6402                	ld	s0,0(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret

0000000000000556 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 556:	4885                	li	a7,1
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exit>:
.global exit
exit:
 li a7, SYS_exit
 55e:	4889                	li	a7,2
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <wait>:
.global wait
wait:
 li a7, SYS_wait
 566:	488d                	li	a7,3
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 56e:	4891                	li	a7,4
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <read>:
.global read
read:
 li a7, SYS_read
 576:	4895                	li	a7,5
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <write>:
.global write
write:
 li a7, SYS_write
 57e:	48c1                	li	a7,16
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <close>:
.global close
close:
 li a7, SYS_close
 586:	48d5                	li	a7,21
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <kill>:
.global kill
kill:
 li a7, SYS_kill
 58e:	4899                	li	a7,6
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <exec>:
.global exec
exec:
 li a7, SYS_exec
 596:	489d                	li	a7,7
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <open>:
.global open
open:
 li a7, SYS_open
 59e:	48bd                	li	a7,15
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5a6:	48c5                	li	a7,17
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ae:	48c9                	li	a7,18
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5b6:	48a1                	li	a7,8
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <link>:
.global link
link:
 li a7, SYS_link
 5be:	48cd                	li	a7,19
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c6:	48d1                	li	a7,20
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ce:	48a5                	li	a7,9
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5d6:	48a9                	li	a7,10
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5de:	48ad                	li	a7,11
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5e6:	48b1                	li	a7,12
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ee:	48b5                	li	a7,13
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5f6:	48b9                	li	a7,14
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 5fe:	48d9                	li	a7,22
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 606:	48dd                	li	a7,23
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 60e:	48e1                	li	a7,24
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 616:	48e5                	li	a7,25
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <socket>:
.global socket
socket:
 li a7, SYS_socket
 61e:	48e9                	li	a7,26
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <bind>:
.global bind
bind:
 li a7, SYS_bind
 626:	48ed                	li	a7,27
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <accept>:
.global accept
accept:
 li a7, SYS_accept
 62e:	48f5                	li	a7,29
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <listen>:
.global listen
listen:
 li a7, SYS_listen
 636:	48f1                	li	a7,28
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <connect>:
.global connect
connect:
 li a7, SYS_connect
 63e:	48f9                	li	a7,30
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <send>:
.global send
send:
 li a7, SYS_send
 646:	48fd                	li	a7,31
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <recv>:
.global recv
recv:
 li a7, SYS_recv
 64e:	02000893          	li	a7,32
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 658:	02100893          	li	a7,33
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 662:	02200893          	li	a7,34
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 66c:	1101                	addi	sp,sp,-32
 66e:	ec06                	sd	ra,24(sp)
 670:	e822                	sd	s0,16(sp)
 672:	1000                	addi	s0,sp,32
 674:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 678:	4605                	li	a2,1
 67a:	fef40593          	addi	a1,s0,-17
 67e:	00000097          	auipc	ra,0x0
 682:	f00080e7          	jalr	-256(ra) # 57e <write>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6105                	addi	sp,sp,32
 68c:	8082                	ret

000000000000068e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 68e:	7139                	addi	sp,sp,-64
 690:	fc06                	sd	ra,56(sp)
 692:	f822                	sd	s0,48(sp)
 694:	f426                	sd	s1,40(sp)
 696:	0080                	addi	s0,sp,64
 698:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 69a:	c299                	beqz	a3,6a0 <printint+0x12>
 69c:	0805cb63          	bltz	a1,732 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6a0:	2581                	sext.w	a1,a1
  neg = 0;
 6a2:	4881                	li	a7,0
 6a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6aa:	2601                	sext.w	a2,a2
 6ac:	00001517          	auipc	a0,0x1
 6b0:	86c50513          	addi	a0,a0,-1940 # f18 <digits>
 6b4:	883a                	mv	a6,a4
 6b6:	2705                	addiw	a4,a4,1
 6b8:	02c5f7bb          	remuw	a5,a1,a2
 6bc:	1782                	slli	a5,a5,0x20
 6be:	9381                	srli	a5,a5,0x20
 6c0:	97aa                	add	a5,a5,a0
 6c2:	0007c783          	lbu	a5,0(a5)
 6c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ca:	0005879b          	sext.w	a5,a1
 6ce:	02c5d5bb          	divuw	a1,a1,a2
 6d2:	0685                	addi	a3,a3,1
 6d4:	fec7f0e3          	bgeu	a5,a2,6b4 <printint+0x26>
  if(neg)
 6d8:	00088c63          	beqz	a7,6f0 <printint+0x62>
    buf[i++] = '-';
 6dc:	fd070793          	addi	a5,a4,-48
 6e0:	00878733          	add	a4,a5,s0
 6e4:	02d00793          	li	a5,45
 6e8:	fef70823          	sb	a5,-16(a4)
 6ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6f0:	02e05c63          	blez	a4,728 <printint+0x9a>
 6f4:	f04a                	sd	s2,32(sp)
 6f6:	ec4e                	sd	s3,24(sp)
 6f8:	fc040793          	addi	a5,s0,-64
 6fc:	00e78933          	add	s2,a5,a4
 700:	fff78993          	addi	s3,a5,-1
 704:	99ba                	add	s3,s3,a4
 706:	377d                	addiw	a4,a4,-1
 708:	1702                	slli	a4,a4,0x20
 70a:	9301                	srli	a4,a4,0x20
 70c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 710:	fff94583          	lbu	a1,-1(s2)
 714:	8526                	mv	a0,s1
 716:	00000097          	auipc	ra,0x0
 71a:	f56080e7          	jalr	-170(ra) # 66c <putc>
  while(--i >= 0)
 71e:	197d                	addi	s2,s2,-1
 720:	ff3918e3          	bne	s2,s3,710 <printint+0x82>
 724:	7902                	ld	s2,32(sp)
 726:	69e2                	ld	s3,24(sp)
}
 728:	70e2                	ld	ra,56(sp)
 72a:	7442                	ld	s0,48(sp)
 72c:	74a2                	ld	s1,40(sp)
 72e:	6121                	addi	sp,sp,64
 730:	8082                	ret
    x = -xx;
 732:	40b005bb          	negw	a1,a1
    neg = 1;
 736:	4885                	li	a7,1
    x = -xx;
 738:	b7b5                	j	6a4 <printint+0x16>

000000000000073a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	e486                	sd	ra,72(sp)
 73e:	e0a2                	sd	s0,64(sp)
 740:	f84a                	sd	s2,48(sp)
 742:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 744:	0005c903          	lbu	s2,0(a1)
 748:	1a090a63          	beqz	s2,8fc <vprintf+0x1c2>
 74c:	fc26                	sd	s1,56(sp)
 74e:	f44e                	sd	s3,40(sp)
 750:	f052                	sd	s4,32(sp)
 752:	ec56                	sd	s5,24(sp)
 754:	e85a                	sd	s6,16(sp)
 756:	e45e                	sd	s7,8(sp)
 758:	8aaa                	mv	s5,a0
 75a:	8bb2                	mv	s7,a2
 75c:	00158493          	addi	s1,a1,1
  state = 0;
 760:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 762:	02500a13          	li	s4,37
 766:	4b55                	li	s6,21
 768:	a839                	j	786 <vprintf+0x4c>
        putc(fd, c);
 76a:	85ca                	mv	a1,s2
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	efe080e7          	jalr	-258(ra) # 66c <putc>
 776:	a019                	j	77c <vprintf+0x42>
    } else if(state == '%'){
 778:	01498d63          	beq	s3,s4,792 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 77c:	0485                	addi	s1,s1,1
 77e:	fff4c903          	lbu	s2,-1(s1)
 782:	16090763          	beqz	s2,8f0 <vprintf+0x1b6>
    if(state == 0){
 786:	fe0999e3          	bnez	s3,778 <vprintf+0x3e>
      if(c == '%'){
 78a:	ff4910e3          	bne	s2,s4,76a <vprintf+0x30>
        state = '%';
 78e:	89d2                	mv	s3,s4
 790:	b7f5                	j	77c <vprintf+0x42>
      if(c == 'd'){
 792:	13490463          	beq	s2,s4,8ba <vprintf+0x180>
 796:	f9d9079b          	addiw	a5,s2,-99
 79a:	0ff7f793          	zext.b	a5,a5
 79e:	12fb6763          	bltu	s6,a5,8cc <vprintf+0x192>
 7a2:	f9d9079b          	addiw	a5,s2,-99
 7a6:	0ff7f713          	zext.b	a4,a5
 7aa:	12eb6163          	bltu	s6,a4,8cc <vprintf+0x192>
 7ae:	00271793          	slli	a5,a4,0x2
 7b2:	00000717          	auipc	a4,0x0
 7b6:	70e70713          	addi	a4,a4,1806 # ec0 <ithread_join+0x1ce>
 7ba:	97ba                	add	a5,a5,a4
 7bc:	439c                	lw	a5,0(a5)
 7be:	97ba                	add	a5,a5,a4
 7c0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7c2:	008b8913          	addi	s2,s7,8
 7c6:	4685                	li	a3,1
 7c8:	4629                	li	a2,10
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	ebe080e7          	jalr	-322(ra) # 68e <printint>
 7d8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b745                	j	77c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	ea2080e7          	jalr	-350(ra) # 68e <printint>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b751                	j	77c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7fa:	008b8913          	addi	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4641                	li	a2,16
 802:	000ba583          	lw	a1,0(s7)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e86080e7          	jalr	-378(ra) # 68e <printint>
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	b7a5                	j	77c <vprintf+0x42>
 816:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 818:	008b8c13          	addi	s8,s7,8
 81c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 820:	03000593          	li	a1,48
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e46080e7          	jalr	-442(ra) # 66c <putc>
  putc(fd, 'x');
 82e:	07800593          	li	a1,120
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e38080e7          	jalr	-456(ra) # 66c <putc>
 83c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83e:	00000b97          	auipc	s7,0x0
 842:	6dab8b93          	addi	s7,s7,1754 # f18 <digits>
 846:	03c9d793          	srli	a5,s3,0x3c
 84a:	97de                	add	a5,a5,s7
 84c:	0007c583          	lbu	a1,0(a5)
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e1a080e7          	jalr	-486(ra) # 66c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85a:	0992                	slli	s3,s3,0x4
 85c:	397d                	addiw	s2,s2,-1
 85e:	fe0914e3          	bnez	s2,846 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 862:	8be2                	mv	s7,s8
      state = 0;
 864:	4981                	li	s3,0
 866:	6c02                	ld	s8,0(sp)
 868:	bf11                	j	77c <vprintf+0x42>
        s = va_arg(ap, char*);
 86a:	008b8993          	addi	s3,s7,8
 86e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 872:	02090163          	beqz	s2,894 <vprintf+0x15a>
        while(*s != 0){
 876:	00094583          	lbu	a1,0(s2)
 87a:	c9a5                	beqz	a1,8ea <vprintf+0x1b0>
          putc(fd, *s);
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	dee080e7          	jalr	-530(ra) # 66c <putc>
          s++;
 886:	0905                	addi	s2,s2,1
        while(*s != 0){
 888:	00094583          	lbu	a1,0(s2)
 88c:	f9e5                	bnez	a1,87c <vprintf+0x142>
        s = va_arg(ap, char*);
 88e:	8bce                	mv	s7,s3
      state = 0;
 890:	4981                	li	s3,0
 892:	b5ed                	j	77c <vprintf+0x42>
          s = "(null)";
 894:	00000917          	auipc	s2,0x0
 898:	5f490913          	addi	s2,s2,1524 # e88 <ithread_join+0x196>
        while(*s != 0){
 89c:	02800593          	li	a1,40
 8a0:	bff1                	j	87c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8a2:	008b8913          	addi	s2,s7,8
 8a6:	000bc583          	lbu	a1,0(s7)
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dc0080e7          	jalr	-576(ra) # 66c <putc>
 8b4:	8bca                	mv	s7,s2
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b5d1                	j	77c <vprintf+0x42>
        putc(fd, c);
 8ba:	02500593          	li	a1,37
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	dac080e7          	jalr	-596(ra) # 66c <putc>
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	bd4d                	j	77c <vprintf+0x42>
        putc(fd, '%');
 8cc:	02500593          	li	a1,37
 8d0:	8556                	mv	a0,s5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	d9a080e7          	jalr	-614(ra) # 66c <putc>
        putc(fd, c);
 8da:	85ca                	mv	a1,s2
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	d8e080e7          	jalr	-626(ra) # 66c <putc>
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bd51                	j	77c <vprintf+0x42>
        s = va_arg(ap, char*);
 8ea:	8bce                	mv	s7,s3
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	b579                	j	77c <vprintf+0x42>
 8f0:	74e2                	ld	s1,56(sp)
 8f2:	79a2                	ld	s3,40(sp)
 8f4:	7a02                	ld	s4,32(sp)
 8f6:	6ae2                	ld	s5,24(sp)
 8f8:	6b42                	ld	s6,16(sp)
 8fa:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8fc:	60a6                	ld	ra,72(sp)
 8fe:	6406                	ld	s0,64(sp)
 900:	7942                	ld	s2,48(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 906:	715d                	addi	sp,sp,-80
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e010                	sd	a2,0(s0)
 910:	e414                	sd	a3,8(s0)
 912:	e818                	sd	a4,16(s0)
 914:	ec1c                	sd	a5,24(s0)
 916:	03043023          	sd	a6,32(s0)
 91a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 922:	8622                	mv	a2,s0
 924:	00000097          	auipc	ra,0x0
 928:	e16080e7          	jalr	-490(ra) # 73a <vprintf>
}
 92c:	60e2                	ld	ra,24(sp)
 92e:	6442                	ld	s0,16(sp)
 930:	6161                	addi	sp,sp,80
 932:	8082                	ret

0000000000000934 <printf>:

void
printf(const char *fmt, ...)
{
 934:	711d                	addi	sp,sp,-96
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	1000                	addi	s0,sp,32
 93c:	e40c                	sd	a1,8(s0)
 93e:	e810                	sd	a2,16(s0)
 940:	ec14                	sd	a3,24(s0)
 942:	f018                	sd	a4,32(s0)
 944:	f41c                	sd	a5,40(s0)
 946:	03043823          	sd	a6,48(s0)
 94a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	00840613          	addi	a2,s0,8
 952:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 956:	85aa                	mv	a1,a0
 958:	4505                	li	a0,1
 95a:	00000097          	auipc	ra,0x0
 95e:	de0080e7          	jalr	-544(ra) # 73a <vprintf>
}
 962:	60e2                	ld	ra,24(sp)
 964:	6442                	ld	s0,16(sp)
 966:	6125                	addi	sp,sp,96
 968:	8082                	ret

000000000000096a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96a:	1141                	addi	sp,sp,-16
 96c:	e422                	sd	s0,8(sp)
 96e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 970:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 974:	00000797          	auipc	a5,0x0
 978:	69c7b783          	ld	a5,1692(a5) # 1010 <freep>
 97c:	a02d                	j	9a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97e:	4618                	lw	a4,8(a2)
 980:	9f2d                	addw	a4,a4,a1
 982:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	6398                	ld	a4,0(a5)
 988:	6310                	ld	a2,0(a4)
 98a:	a83d                	j	9c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98c:	ff852703          	lw	a4,-8(a0)
 990:	9f31                	addw	a4,a4,a2
 992:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 994:	ff053683          	ld	a3,-16(a0)
 998:	a091                	j	9dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	6398                	ld	a4,0(a5)
 99c:	00e7e463          	bltu	a5,a4,9a4 <free+0x3a>
 9a0:	00e6ea63          	bltu	a3,a4,9b4 <free+0x4a>
{
 9a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a6:	fed7fae3          	bgeu	a5,a3,99a <free+0x30>
 9aa:	6398                	ld	a4,0(a5)
 9ac:	00e6e463          	bltu	a3,a4,9b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	fee7eae3          	bltu	a5,a4,9a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9b4:	ff852583          	lw	a1,-8(a0)
 9b8:	6390                	ld	a2,0(a5)
 9ba:	02059813          	slli	a6,a1,0x20
 9be:	01c85713          	srli	a4,a6,0x1c
 9c2:	9736                	add	a4,a4,a3
 9c4:	fae60de3          	beq	a2,a4,97e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9cc:	4790                	lw	a2,8(a5)
 9ce:	02061593          	slli	a1,a2,0x20
 9d2:	01c5d713          	srli	a4,a1,0x1c
 9d6:	973e                	add	a4,a4,a5
 9d8:	fae68ae3          	beq	a3,a4,98c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73923          	sd	a5,1586(a4) # 1010 <freep>
}
 9e6:	6422                	ld	s0,8(sp)
 9e8:	0141                	addi	sp,sp,16
 9ea:	8082                	ret

00000000000009ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ec:	7139                	addi	sp,sp,-64
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	f426                	sd	s1,40(sp)
 9f4:	ec4e                	sd	s3,24(sp)
 9f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f8:	02051493          	slli	s1,a0,0x20
 9fc:	9081                	srli	s1,s1,0x20
 9fe:	04bd                	addi	s1,s1,15
 a00:	8091                	srli	s1,s1,0x4
 a02:	0014899b          	addiw	s3,s1,1
 a06:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a08:	00000517          	auipc	a0,0x0
 a0c:	60853503          	ld	a0,1544(a0) # 1010 <freep>
 a10:	c915                	beqz	a0,a44 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	08977e63          	bgeu	a4,s1,ab2 <malloc+0xc6>
 a1a:	f04a                	sd	s2,32(sp)
 a1c:	e852                	sd	s4,16(sp)
 a1e:	e456                	sd	s5,8(sp)
 a20:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a22:	8a4e                	mv	s4,s3
 a24:	0009871b          	sext.w	a4,s3
 a28:	6685                	lui	a3,0x1
 a2a:	00d77363          	bgeu	a4,a3,a30 <malloc+0x44>
 a2e:	6a05                	lui	s4,0x1
 a30:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a34:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a38:	00000917          	auipc	s2,0x0
 a3c:	5d890913          	addi	s2,s2,1496 # 1010 <freep>
  if(p == (char*)-1)
 a40:	5afd                	li	s5,-1
 a42:	a091                	j	a86 <malloc+0x9a>
 a44:	f04a                	sd	s2,32(sp)
 a46:	e852                	sd	s4,16(sp)
 a48:	e456                	sd	s5,8(sp)
 a4a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4c:	00000797          	auipc	a5,0x0
 a50:	5e478793          	addi	a5,a5,1508 # 1030 <base>
 a54:	00000717          	auipc	a4,0x0
 a58:	5af73e23          	sd	a5,1468(a4) # 1010 <freep>
 a5c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a62:	b7c1                	j	a22 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a64:	6398                	ld	a4,0(a5)
 a66:	e118                	sd	a4,0(a0)
 a68:	a08d                	j	aca <malloc+0xde>
  hp->s.size = nu;
 a6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6e:	0541                	addi	a0,a0,16
 a70:	00000097          	auipc	ra,0x0
 a74:	efa080e7          	jalr	-262(ra) # 96a <free>
  return freep;
 a78:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a7c:	c13d                	beqz	a0,ae2 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a80:	4798                	lw	a4,8(a5)
 a82:	02977463          	bgeu	a4,s1,aaa <malloc+0xbe>
    if(p == freep)
 a86:	00093703          	ld	a4,0(s2)
 a8a:	853e                	mv	a0,a5
 a8c:	fef719e3          	bne	a4,a5,a7e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a90:	8552                	mv	a0,s4
 a92:	00000097          	auipc	ra,0x0
 a96:	b54080e7          	jalr	-1196(ra) # 5e6 <sbrk>
  if(p == (char*)-1)
 a9a:	fd5518e3          	bne	a0,s5,a6a <malloc+0x7e>
        return 0;
 a9e:	4501                	li	a0,0
 aa0:	7902                	ld	s2,32(sp)
 aa2:	6a42                	ld	s4,16(sp)
 aa4:	6aa2                	ld	s5,8(sp)
 aa6:	6b02                	ld	s6,0(sp)
 aa8:	a03d                	j	ad6 <malloc+0xea>
 aaa:	7902                	ld	s2,32(sp)
 aac:	6a42                	ld	s4,16(sp)
 aae:	6aa2                	ld	s5,8(sp)
 ab0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab2:	fae489e3          	beq	s1,a4,a64 <malloc+0x78>
        p->s.size -= nunits;
 ab6:	4137073b          	subw	a4,a4,s3
 aba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 abc:	02071693          	slli	a3,a4,0x20
 ac0:	01c6d713          	srli	a4,a3,0x1c
 ac4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aca:	00000717          	auipc	a4,0x0
 ace:	54a73323          	sd	a0,1350(a4) # 1010 <freep>
      return (void*)(p + 1);
 ad2:	01078513          	addi	a0,a5,16
  }
}
 ad6:	70e2                	ld	ra,56(sp)
 ad8:	7442                	ld	s0,48(sp)
 ada:	74a2                	ld	s1,40(sp)
 adc:	69e2                	ld	s3,24(sp)
 ade:	6121                	addi	sp,sp,64
 ae0:	8082                	ret
 ae2:	7902                	ld	s2,32(sp)
 ae4:	6a42                	ld	s4,16(sp)
 ae6:	6aa2                	ld	s5,8(sp)
 ae8:	6b02                	ld	s6,0(sp)
 aea:	b7f5                	j	ad6 <malloc+0xea>

0000000000000aec <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 aec:	1141                	addi	sp,sp,-16
 aee:	e406                	sd	ra,8(sp)
 af0:	e022                	sd	s0,0(sp)
 af2:	0800                	addi	s0,sp,16
  thread_exit(status);
 af4:	2501                	sext.w	a0,a0
 af6:	00000097          	auipc	ra,0x0
 afa:	b20080e7          	jalr	-1248(ra) # 616 <thread_exit>
}
 afe:	60a2                	ld	ra,8(sp)
 b00:	6402                	ld	s0,0(sp)
 b02:	0141                	addi	sp,sp,16
 b04:	8082                	ret

0000000000000b06 <free_stacks>:
int free_stacks() {
 b06:	7179                	addi	sp,sp,-48
 b08:	f406                	sd	ra,40(sp)
 b0a:	f022                	sd	s0,32(sp)
 b0c:	ec26                	sd	s1,24(sp)
 b0e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 b10:	00000797          	auipc	a5,0x0
 b14:	5107a783          	lw	a5,1296(a5) # 1020 <num_threads>
 b18:	04f05063          	blez	a5,b58 <free_stacks+0x52>
 b1c:	e84a                	sd	s2,16(sp)
 b1e:	e44e                	sd	s3,8(sp)
 b20:	4481                	li	s1,0
    free(stacks[i]);
 b22:	00000997          	auipc	s3,0x0
 b26:	4f698993          	addi	s3,s3,1270 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 b2a:	00000917          	auipc	s2,0x0
 b2e:	4f690913          	addi	s2,s2,1270 # 1020 <num_threads>
    free(stacks[i]);
 b32:	0009b783          	ld	a5,0(s3)
 b36:	00349713          	slli	a4,s1,0x3
 b3a:	97ba                	add	a5,a5,a4
 b3c:	6388                	ld	a0,0(a5)
 b3e:	00000097          	auipc	ra,0x0
 b42:	e2c080e7          	jalr	-468(ra) # 96a <free>
  for (int i = 0; i < num_threads; i++) {
 b46:	0485                	addi	s1,s1,1
 b48:	00092703          	lw	a4,0(s2)
 b4c:	0004879b          	sext.w	a5,s1
 b50:	fee7c1e3          	blt	a5,a4,b32 <free_stacks+0x2c>
 b54:	6942                	ld	s2,16(sp)
 b56:	69a2                	ld	s3,8(sp)
  free(stacks);
 b58:	00000497          	auipc	s1,0x0
 b5c:	4c048493          	addi	s1,s1,1216 # 1018 <stacks>
 b60:	6088                	ld	a0,0(s1)
 b62:	00000097          	auipc	ra,0x0
 b66:	e08080e7          	jalr	-504(ra) # 96a <free>
  stacks = 0;
 b6a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b6e:	00000797          	auipc	a5,0x0
 b72:	4a07a923          	sw	zero,1202(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b76:	47a1                	li	a5,8
 b78:	00000717          	auipc	a4,0x0
 b7c:	48f72423          	sw	a5,1160(a4) # 1000 <max_stacks>
  threads_done = 0;
 b80:	00000797          	auipc	a5,0x0
 b84:	4a07a223          	sw	zero,1188(a5) # 1024 <threads_done>
}
 b88:	4501                	li	a0,0
 b8a:	70a2                	ld	ra,40(sp)
 b8c:	7402                	ld	s0,32(sp)
 b8e:	64e2                	ld	s1,24(sp)
 b90:	6145                	addi	sp,sp,48
 b92:	8082                	ret

0000000000000b94 <expand_num_threads>:
int expand_num_threads() {
 b94:	1101                	addi	sp,sp,-32
 b96:	ec06                	sd	ra,24(sp)
 b98:	e822                	sd	s0,16(sp)
 b9a:	e426                	sd	s1,8(sp)
 b9c:	e04a                	sd	s2,0(sp)
 b9e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 ba0:	00000797          	auipc	a5,0x0
 ba4:	46078793          	addi	a5,a5,1120 # 1000 <max_stacks>
 ba8:	4388                	lw	a0,0(a5)
 baa:	0015151b          	slliw	a0,a0,0x1
 bae:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 bb0:	0035151b          	slliw	a0,a0,0x3
 bb4:	00000097          	auipc	ra,0x0
 bb8:	e38080e7          	jalr	-456(ra) # 9ec <malloc>
 bbc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 bbe:	00000617          	auipc	a2,0x0
 bc2:	46262603          	lw	a2,1122(a2) # 1020 <num_threads>
 bc6:	00000497          	auipc	s1,0x0
 bca:	45248493          	addi	s1,s1,1106 # 1018 <stacks>
 bce:	0036161b          	slliw	a2,a2,0x3
 bd2:	608c                	ld	a1,0(s1)
 bd4:	00000097          	auipc	ra,0x0
 bd8:	8d8080e7          	jalr	-1832(ra) # 4ac <memmove>
  free(stacks);
 bdc:	6088                	ld	a0,0(s1)
 bde:	00000097          	auipc	ra,0x0
 be2:	d8c080e7          	jalr	-628(ra) # 96a <free>
  stacks = new_stacks;
 be6:	0124b023          	sd	s2,0(s1)
}
 bea:	4501                	li	a0,0
 bec:	60e2                	ld	ra,24(sp)
 bee:	6442                	ld	s0,16(sp)
 bf0:	64a2                	ld	s1,8(sp)
 bf2:	6902                	ld	s2,0(sp)
 bf4:	6105                	addi	sp,sp,32
 bf6:	8082                	ret

0000000000000bf8 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 bf8:	7179                	addi	sp,sp,-48
 bfa:	f406                	sd	ra,40(sp)
 bfc:	f022                	sd	s0,32(sp)
 bfe:	e84a                	sd	s2,16(sp)
 c00:	e44e                	sd	s3,8(sp)
 c02:	1800                	addi	s0,sp,48
 c04:	892a                	mv	s2,a0
 c06:	89ae                	mv	s3,a1
  if (stacks == 0) {
 c08:	00000797          	auipc	a5,0x0
 c0c:	4107b783          	ld	a5,1040(a5) # 1018 <stacks>
 c10:	c3d9                	beqz	a5,c96 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 c12:	00000797          	auipc	a5,0x0
 c16:	3ee7a783          	lw	a5,1006(a5) # 1000 <max_stacks>
 c1a:	00000717          	auipc	a4,0x0
 c1e:	40672703          	lw	a4,1030(a4) # 1020 <num_threads>
 c22:	0af71363          	bne	a4,a5,cc8 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 c26:	04000713          	li	a4,64
 c2a:	08e78563          	beq	a5,a4,cb4 <ithread_create+0xbc>
 c2e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c30:	00000097          	auipc	ra,0x0
 c34:	f64080e7          	jalr	-156(ra) # b94 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c38:	6505                	lui	a0,0x1
 c3a:	00000097          	auipc	ra,0x0
 c3e:	db2080e7          	jalr	-590(ra) # 9ec <malloc>
 c42:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c44:	00000717          	auipc	a4,0x0
 c48:	3dc72703          	lw	a4,988(a4) # 1020 <num_threads>
 c4c:	070e                	slli	a4,a4,0x3
 c4e:	00000797          	auipc	a5,0x0
 c52:	3ca7b783          	ld	a5,970(a5) # 1018 <stacks>
 c56:	97ba                	add	a5,a5,a4
 c58:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c5a:	00000697          	auipc	a3,0x0
 c5e:	e9268693          	addi	a3,a3,-366 # aec <ithread_exit>
 c62:	862a                	mv	a2,a0
 c64:	85ce                	mv	a1,s3
 c66:	854a                	mv	a0,s2
 c68:	00000097          	auipc	ra,0x0
 c6c:	99e080e7          	jalr	-1634(ra) # 606 <create_thread>
 c70:	892a                	mv	s2,a0
  if (res != -1) {
 c72:	57fd                	li	a5,-1
 c74:	04f50c63          	beq	a0,a5,ccc <ithread_create+0xd4>
    num_threads++;
 c78:	00000717          	auipc	a4,0x0
 c7c:	3a870713          	addi	a4,a4,936 # 1020 <num_threads>
 c80:	431c                	lw	a5,0(a4)
 c82:	2785                	addiw	a5,a5,1
 c84:	c31c                	sw	a5,0(a4)
 c86:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c88:	854a                	mv	a0,s2
 c8a:	70a2                	ld	ra,40(sp)
 c8c:	7402                	ld	s0,32(sp)
 c8e:	6942                	ld	s2,16(sp)
 c90:	69a2                	ld	s3,8(sp)
 c92:	6145                	addi	sp,sp,48
 c94:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c96:	00000517          	auipc	a0,0x0
 c9a:	36a52503          	lw	a0,874(a0) # 1000 <max_stacks>
 c9e:	0035151b          	slliw	a0,a0,0x3
 ca2:	00000097          	auipc	ra,0x0
 ca6:	d4a080e7          	jalr	-694(ra) # 9ec <malloc>
 caa:	00000797          	auipc	a5,0x0
 cae:	36a7b723          	sd	a0,878(a5) # 1018 <stacks>
 cb2:	b785                	j	c12 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 cb4:	00000517          	auipc	a0,0x0
 cb8:	1dc50513          	addi	a0,a0,476 # e90 <ithread_join+0x19e>
 cbc:	00000097          	auipc	ra,0x0
 cc0:	c78080e7          	jalr	-904(ra) # 934 <printf>
      return -1;
 cc4:	597d                	li	s2,-1
 cc6:	b7c9                	j	c88 <ithread_create+0x90>
 cc8:	ec26                	sd	s1,24(sp)
 cca:	b7bd                	j	c38 <ithread_create+0x40>
    free(stack_ptr);
 ccc:	8526                	mv	a0,s1
 cce:	00000097          	auipc	ra,0x0
 cd2:	c9c080e7          	jalr	-868(ra) # 96a <free>
    stacks[num_threads] = 0;
 cd6:	00000717          	auipc	a4,0x0
 cda:	34a72703          	lw	a4,842(a4) # 1020 <num_threads>
 cde:	070e                	slli	a4,a4,0x3
 ce0:	00000797          	auipc	a5,0x0
 ce4:	3387b783          	ld	a5,824(a5) # 1018 <stacks>
 ce8:	97ba                	add	a5,a5,a4
 cea:	0007b023          	sd	zero,0(a5)
 cee:	64e2                	ld	s1,24(sp)
 cf0:	bf61                	j	c88 <ithread_create+0x90>

0000000000000cf2 <ithread_join>:

int ithread_join(int thread_id) {
 cf2:	1101                	addi	sp,sp,-32
 cf4:	ec06                	sd	ra,24(sp)
 cf6:	e822                	sd	s0,16(sp)
 cf8:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 cfa:	ff040793          	addi	a5,s0,-16
 cfe:	ffc7859b          	addiw	a1,a5,-4
 d02:	00000097          	auipc	ra,0x0
 d06:	90c080e7          	jalr	-1780(ra) # 60e <join_thread>
  threads_done++;
 d0a:	00000717          	auipc	a4,0x0
 d0e:	31a70713          	addi	a4,a4,794 # 1024 <threads_done>
 d12:	431c                	lw	a5,0(a4)
 d14:	2785                	addiw	a5,a5,1
 d16:	0007869b          	sext.w	a3,a5
 d1a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 d1c:	00000797          	auipc	a5,0x0
 d20:	3047a783          	lw	a5,772(a5) # 1020 <num_threads>
 d24:	00d78863          	beq	a5,a3,d34 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 d28:	fec42503          	lw	a0,-20(s0)
 d2c:	60e2                	ld	ra,24(sp)
 d2e:	6442                	ld	s0,16(sp)
 d30:	6105                	addi	sp,sp,32
 d32:	8082                	ret
    free_stacks();
 d34:	00000097          	auipc	ra,0x0
 d38:	dd2080e7          	jalr	-558(ra) # b06 <free_stacks>
 d3c:	b7f5                	j	d28 <ithread_join+0x36>
