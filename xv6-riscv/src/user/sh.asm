
src/user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	6ce58593          	addi	a1,a1,1742 # 16e0 <ithread_join+0x50>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	f00080e7          	jalr	-256(ra) # f1c <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bcc080e7          	jalr	-1076(ra) # bf6 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c06080e7          	jalr	-1018(ra) # c3c <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	68858593          	addi	a1,a1,1672 # 16e8 <ithread_join+0x58>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	23a080e7          	jalr	570(ra) # 12a4 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	e88080e7          	jalr	-376(ra) # efc <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	e70080e7          	jalr	-400(ra) # ef4 <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	65650513          	addi	a0,a0,1622 # 16f0 <ithread_join+0x60>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	75670713          	addi	a4,a4,1878 # 181c <ithread_join+0x18c>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
    exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	e22080e7          	jalr	-478(ra) # efc <exit>
    panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	61650513          	addi	a0,a0,1558 # 16f8 <ithread_join+0x68>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	e3a080e7          	jalr	-454(ra) # f34 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	5fc58593          	addi	a1,a1,1532 # 1700 <ithread_join+0x70>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	196080e7          	jalr	406(ra) # 12a4 <fprintf>
  exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	de4080e7          	jalr	-540(ra) # efc <exit>
      exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	dda080e7          	jalr	-550(ra) # efc <exit>
    close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	df8080e7          	jalr	-520(ra) # f24 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	e04080e7          	jalr	-508(ra) # f3c <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
    runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	5c058593          	addi	a1,a1,1472 # 1710 <ithread_join+0x80>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	14a080e7          	jalr	330(ra) # 12a4 <fprintf>
      exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	d98080e7          	jalr	-616(ra) # efc <exit>
    if(fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
      runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
    wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	d82080e7          	jalr	-638(ra) # f04 <wait>
    runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
    if(pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	d74080e7          	jalr	-652(ra) # f0c <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
    if(fork1() == 0){
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
      close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	d74080e7          	jalr	-652(ra) # f24 <close>
      dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	db8080e7          	jalr	-584(ra) # f74 <dup>
      close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	d5c080e7          	jalr	-676(ra) # f24 <close>
      close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	d50080e7          	jalr	-688(ra) # f24 <close>
      runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
      panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	53a50513          	addi	a0,a0,1338 # 1720 <ithread_join+0x90>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
    if(fork1() == 0){
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
      close(0);
     200:	00001097          	auipc	ra,0x1
     204:	d24080e7          	jalr	-732(ra) # f24 <close>
      dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	d68080e7          	jalr	-664(ra) # f74 <dup>
      close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	d0c080e7          	jalr	-756(ra) # f24 <close>
      close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	d00080e7          	jalr	-768(ra) # f24 <close>
      runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
    close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	cea080e7          	jalr	-790(ra) # f24 <close>
    close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	cde080e7          	jalr	-802(ra) # f24 <close>
    wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	cb4080e7          	jalr	-844(ra) # f04 <wait>
    wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	caa080e7          	jalr	-854(ra) # f04 <wait>
    break;
     262:	bd55                	j	116 <runcmd+0x6c>
    if(fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	102080e7          	jalr	258(ra) # 138a <malloc>
     290:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	95e080e7          	jalr	-1698(ra) # bf6 <memset>
  cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	0b8080e7          	jalr	184(ra) # 138a <malloc>
     2da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	914080e7          	jalr	-1772(ra) # bf6 <memset>
  cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	05e080e7          	jalr	94(ra) # 138a <malloc>
     334:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	8bc080e7          	jalr	-1860(ra) # bf6 <memset>
  cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	018080e7          	jalr	24(ra) # 138a <malloc>
     37a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	876080e7          	jalr	-1930(ra) # bf6 <memset>
  cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	fd6080e7          	jalr	-42(ra) # 138a <malloc>
     3bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	834080e7          	jalr	-1996(ra) # bf6 <memset>
  cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fc:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	c0a98993          	addi	s3,s3,-1014 # 2008 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	808080e7          	jalr	-2040(ra) # c18 <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
    s++;
     41a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
  if(q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
    *q = s;
     426:	009ab023          	sd	s1,0(s5)
  ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
  switch(*s){
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     45a:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
    *eq = s;
     460:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	addi	s3,s3,-1116 # 2008 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00000097          	auipc	ra,0x0
     47a:	7a2080e7          	jalr	1954(ra) # c18 <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
    s++;
     480:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
  *ps = s;
     488:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
  switch(*s){
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
    s++;
     4aa:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
      s++;
     4b6:	0489                	addi	s1,s1,2
      ret = '+';
     4b8:	02b00a93          	li	s5,43
    if(*s == '>'){
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
    s++;
     4c0:	84b6                	mv	s1,a3
  ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
  switch(*s){
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00002997          	auipc	s3,0x2
     4d4:	b3898993          	addi	s3,s3,-1224 # 2008 <whitespace>
     4d8:	00002a97          	auipc	s5,0x2
     4dc:	b28a8a93          	addi	s5,s5,-1240 # 2000 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00000097          	auipc	ra,0x0
     4ee:	72e080e7          	jalr	1838(ra) # c18 <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00000097          	auipc	ra,0x0
     4fe:	71e080e7          	jalr	1822(ra) # c18 <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
      s++;
     504:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
  if(eq)
     50a:	84ca                	mv	s1,s2
    ret = 'a';
     50c:	06100a93          	li	s5,97
  if(eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
    ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
  if(eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52c:	7139                	addi	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     544:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     546:	00002997          	auipc	s3,0x2
     54a:	ac298993          	addi	s3,s3,-1342 # 2008 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	6c0080e7          	jalr	1728(ra) # c18 <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
    s++;
     562:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
  *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	addi	sp,sp,64
     586:	8082                	ret
  return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	68e080e7          	jalr	1678(ra) # c18 <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	711d                	addi	sp,sp,-96
     59a:	ec86                	sd	ra,88(sp)
     59c:	e8a2                	sd	s0,80(sp)
     59e:	e4a6                	sd	s1,72(sp)
     5a0:	e0ca                	sd	s2,64(sp)
     5a2:	fc4e                	sd	s3,56(sp)
     5a4:	f852                	sd	s4,48(sp)
     5a6:	f456                	sd	s5,40(sp)
     5a8:	f05a                	sd	s6,32(sp)
     5aa:	ec5e                	sd	s7,24(sp)
     5ac:	1080                	addi	s0,sp,96
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b4:	00001a97          	auipc	s5,0x1
     5b8:	194a8a93          	addi	s5,s5,404 # 1748 <ithread_join+0xb8>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5bc:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     5c0:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     5c4:	a02d                	j	5ee <parseredirs+0x56>
      panic("missing file for redirection");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	16250513          	addi	a0,a0,354 # 1728 <ithread_join+0x98>
     5ce:	00000097          	auipc	ra,0x0
     5d2:	a88080e7          	jalr	-1400(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d6:	4701                	li	a4,0
     5d8:	4681                	li	a3,0
     5da:	fa043603          	ld	a2,-96(s0)
     5de:	fa843583          	ld	a1,-88(s0)
     5e2:	8552                	mv	a0,s4
     5e4:	00000097          	auipc	ra,0x0
     5e8:	ccc080e7          	jalr	-820(ra) # 2b0 <redircmd>
     5ec:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     5ee:	8656                	mv	a2,s5
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f38080e7          	jalr	-200(ra) # 52c <peek>
     5fc:	cd25                	beqz	a0,674 <parseredirs+0xdc>
    tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dda080e7          	jalr	-550(ra) # 3e0 <gettoken>
     60e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     610:	fa040693          	addi	a3,s0,-96
     614:	fa840613          	addi	a2,s0,-88
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc4080e7          	jalr	-572(ra) # 3e0 <gettoken>
     624:	fb6511e3          	bne	a0,s6,5c6 <parseredirs+0x2e>
    switch(tok){
     628:	fb7487e3          	beq	s1,s7,5d6 <parseredirs+0x3e>
     62c:	03e00793          	li	a5,62
     630:	02f48463          	beq	s1,a5,658 <parseredirs+0xc0>
     634:	02b00793          	li	a5,43
     638:	faf49be3          	bne	s1,a5,5ee <parseredirs+0x56>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63c:	4705                	li	a4,1
     63e:	20100693          	li	a3,513
     642:	fa043603          	ld	a2,-96(s0)
     646:	fa843583          	ld	a1,-88(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	c64080e7          	jalr	-924(ra) # 2b0 <redircmd>
     654:	8a2a                	mv	s4,a0
      break;
     656:	bf61                	j	5ee <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     658:	4705                	li	a4,1
     65a:	60100693          	li	a3,1537
     65e:	fa043603          	ld	a2,-96(s0)
     662:	fa843583          	ld	a1,-88(s0)
     666:	8552                	mv	a0,s4
     668:	00000097          	auipc	ra,0x0
     66c:	c48080e7          	jalr	-952(ra) # 2b0 <redircmd>
     670:	8a2a                	mv	s4,a0
      break;
     672:	bfb5                	j	5ee <parseredirs+0x56>
    }
  }
  return cmd;
}
     674:	8552                	mv	a0,s4
     676:	60e6                	ld	ra,88(sp)
     678:	6446                	ld	s0,80(sp)
     67a:	64a6                	ld	s1,72(sp)
     67c:	6906                	ld	s2,64(sp)
     67e:	79e2                	ld	s3,56(sp)
     680:	7a42                	ld	s4,48(sp)
     682:	7aa2                	ld	s5,40(sp)
     684:	7b02                	ld	s6,32(sp)
     686:	6be2                	ld	s7,24(sp)
     688:	6125                	addi	sp,sp,96
     68a:	8082                	ret

000000000000068c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     68c:	7159                	addi	sp,sp,-112
     68e:	f486                	sd	ra,104(sp)
     690:	f0a2                	sd	s0,96(sp)
     692:	eca6                	sd	s1,88(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	1880                	addi	s0,sp,112
     69a:	8a2a                	mv	s4,a0
     69c:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69e:	00001617          	auipc	a2,0x1
     6a2:	0b260613          	addi	a2,a2,178 # 1750 <ithread_join+0xc0>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	e86080e7          	jalr	-378(ra) # 52c <peek>
     6ae:	ed15                	bnez	a0,6ea <parseexec+0x5e>
     6b0:	e8ca                	sd	s2,80(sp)
     6b2:	e4ce                	sd	s3,72(sp)
     6b4:	f85a                	sd	s6,48(sp)
     6b6:	f45e                	sd	s7,40(sp)
     6b8:	f062                	sd	s8,32(sp)
     6ba:	ec66                	sd	s9,24(sp)
     6bc:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6be:	00000097          	auipc	ra,0x0
     6c2:	bbc080e7          	jalr	-1092(ra) # 27a <execcmd>
     6c6:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c8:	8656                	mv	a2,s5
     6ca:	85d2                	mv	a1,s4
     6cc:	00000097          	auipc	ra,0x0
     6d0:	ecc080e7          	jalr	-308(ra) # 598 <parseredirs>
     6d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d6:	008c0913          	addi	s2,s8,8
     6da:	00001b17          	auipc	s6,0x1
     6de:	096b0b13          	addi	s6,s6,150 # 1770 <ithread_join+0xe0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e2:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e6:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e8:	a081                	j	728 <parseexec+0x9c>
    return parseblock(ps, es);
     6ea:	85d6                	mv	a1,s5
     6ec:	8552                	mv	a0,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	1bc080e7          	jalr	444(ra) # 8aa <parseblock>
     6f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f8:	8526                	mv	a0,s1
     6fa:	70a6                	ld	ra,104(sp)
     6fc:	7406                	ld	s0,96(sp)
     6fe:	64e6                	ld	s1,88(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	6165                	addi	sp,sp,112
     706:	8082                	ret
      panic("syntax");
     708:	00001517          	auipc	a0,0x1
     70c:	05050513          	addi	a0,a0,80 # 1758 <ithread_join+0xc8>
     710:	00000097          	auipc	ra,0x0
     714:	946080e7          	jalr	-1722(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     718:	8656                	mv	a2,s5
     71a:	85d2                	mv	a1,s4
     71c:	8526                	mv	a0,s1
     71e:	00000097          	auipc	ra,0x0
     722:	e7a080e7          	jalr	-390(ra) # 598 <parseredirs>
     726:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     728:	865a                	mv	a2,s6
     72a:	85d6                	mv	a1,s5
     72c:	8552                	mv	a0,s4
     72e:	00000097          	auipc	ra,0x0
     732:	dfe080e7          	jalr	-514(ra) # 52c <peek>
     736:	e131                	bnez	a0,77a <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     738:	f9040693          	addi	a3,s0,-112
     73c:	f9840613          	addi	a2,s0,-104
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	c9c080e7          	jalr	-868(ra) # 3e0 <gettoken>
     74c:	c51d                	beqz	a0,77a <parseexec+0xee>
    if(tok != 'a')
     74e:	fb951de3          	bne	a0,s9,708 <parseexec+0x7c>
    cmd->argv[argc] = q;
     752:	f9843783          	ld	a5,-104(s0)
     756:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     75a:	f9043783          	ld	a5,-112(s0)
     75e:	04f93823          	sd	a5,80(s2)
    argc++;
     762:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     764:	0921                	addi	s2,s2,8
     766:	fb7999e3          	bne	s3,s7,718 <parseexec+0x8c>
      panic("too many args");
     76a:	00001517          	auipc	a0,0x1
     76e:	ff650513          	addi	a0,a0,-10 # 1760 <ithread_join+0xd0>
     772:	00000097          	auipc	ra,0x0
     776:	8e4080e7          	jalr	-1820(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     77a:	098e                	slli	s3,s3,0x3
     77c:	9c4e                	add	s8,s8,s3
     77e:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     782:	040c3c23          	sd	zero,88(s8)
     786:	6946                	ld	s2,80(sp)
     788:	69a6                	ld	s3,72(sp)
     78a:	7b42                	ld	s6,48(sp)
     78c:	7ba2                	ld	s7,40(sp)
     78e:	7c02                	ld	s8,32(sp)
     790:	6ce2                	ld	s9,24(sp)
  return ret;
     792:	b79d                	j	6f8 <parseexec+0x6c>

0000000000000794 <parsepipe>:
{
     794:	7179                	addi	sp,sp,-48
     796:	f406                	sd	ra,40(sp)
     798:	f022                	sd	s0,32(sp)
     79a:	ec26                	sd	s1,24(sp)
     79c:	e84a                	sd	s2,16(sp)
     79e:	e44e                	sd	s3,8(sp)
     7a0:	1800                	addi	s0,sp,48
     7a2:	892a                	mv	s2,a0
     7a4:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a6:	00000097          	auipc	ra,0x0
     7aa:	ee6080e7          	jalr	-282(ra) # 68c <parseexec>
     7ae:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b0:	00001617          	auipc	a2,0x1
     7b4:	fc860613          	addi	a2,a2,-56 # 1778 <ithread_join+0xe8>
     7b8:	85ce                	mv	a1,s3
     7ba:	854a                	mv	a0,s2
     7bc:	00000097          	auipc	ra,0x0
     7c0:	d70080e7          	jalr	-656(ra) # 52c <peek>
     7c4:	e909                	bnez	a0,7d6 <parsepipe+0x42>
}
     7c6:	8526                	mv	a0,s1
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d6:	4681                	li	a3,0
     7d8:	4601                	li	a2,0
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	c02080e7          	jalr	-1022(ra) # 3e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e6:	85ce                	mv	a1,s3
     7e8:	854a                	mv	a0,s2
     7ea:	00000097          	auipc	ra,0x0
     7ee:	faa080e7          	jalr	-86(ra) # 794 <parsepipe>
     7f2:	85aa                	mv	a1,a0
     7f4:	8526                	mv	a0,s1
     7f6:	00000097          	auipc	ra,0x0
     7fa:	b22080e7          	jalr	-1246(ra) # 318 <pipecmd>
     7fe:	84aa                	mv	s1,a0
  return cmd;
     800:	b7d9                	j	7c6 <parsepipe+0x32>

0000000000000802 <parseline>:
{
     802:	7179                	addi	sp,sp,-48
     804:	f406                	sd	ra,40(sp)
     806:	f022                	sd	s0,32(sp)
     808:	ec26                	sd	s1,24(sp)
     80a:	e84a                	sd	s2,16(sp)
     80c:	e44e                	sd	s3,8(sp)
     80e:	e052                	sd	s4,0(sp)
     810:	1800                	addi	s0,sp,48
     812:	892a                	mv	s2,a0
     814:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     816:	00000097          	auipc	ra,0x0
     81a:	f7e080e7          	jalr	-130(ra) # 794 <parsepipe>
     81e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     820:	00001a17          	auipc	s4,0x1
     824:	f60a0a13          	addi	s4,s4,-160 # 1780 <ithread_join+0xf0>
     828:	a839                	j	846 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     82a:	4681                	li	a3,0
     82c:	4601                	li	a2,0
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	00000097          	auipc	ra,0x0
     836:	bae080e7          	jalr	-1106(ra) # 3e0 <gettoken>
    cmd = backcmd(cmd);
     83a:	8526                	mv	a0,s1
     83c:	00000097          	auipc	ra,0x0
     840:	b68080e7          	jalr	-1176(ra) # 3a4 <backcmd>
     844:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     846:	8652                	mv	a2,s4
     848:	85ce                	mv	a1,s3
     84a:	854a                	mv	a0,s2
     84c:	00000097          	auipc	ra,0x0
     850:	ce0080e7          	jalr	-800(ra) # 52c <peek>
     854:	f979                	bnez	a0,82a <parseline+0x28>
  if(peek(ps, es, ";")){
     856:	00001617          	auipc	a2,0x1
     85a:	f3260613          	addi	a2,a2,-206 # 1788 <ithread_join+0xf8>
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	cca080e7          	jalr	-822(ra) # 52c <peek>
     86a:	e911                	bnez	a0,87e <parseline+0x7c>
}
     86c:	8526                	mv	a0,s1
     86e:	70a2                	ld	ra,40(sp)
     870:	7402                	ld	s0,32(sp)
     872:	64e2                	ld	s1,24(sp)
     874:	6942                	ld	s2,16(sp)
     876:	69a2                	ld	s3,8(sp)
     878:	6a02                	ld	s4,0(sp)
     87a:	6145                	addi	sp,sp,48
     87c:	8082                	ret
    gettoken(ps, es, 0, 0);
     87e:	4681                	li	a3,0
     880:	4601                	li	a2,0
     882:	85ce                	mv	a1,s3
     884:	854a                	mv	a0,s2
     886:	00000097          	auipc	ra,0x0
     88a:	b5a080e7          	jalr	-1190(ra) # 3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     88e:	85ce                	mv	a1,s3
     890:	854a                	mv	a0,s2
     892:	00000097          	auipc	ra,0x0
     896:	f70080e7          	jalr	-144(ra) # 802 <parseline>
     89a:	85aa                	mv	a1,a0
     89c:	8526                	mv	a0,s1
     89e:	00000097          	auipc	ra,0x0
     8a2:	ac0080e7          	jalr	-1344(ra) # 35e <listcmd>
     8a6:	84aa                	mv	s1,a0
  return cmd;
     8a8:	b7d1                	j	86c <parseline+0x6a>

00000000000008aa <parseblock>:
{
     8aa:	7179                	addi	sp,sp,-48
     8ac:	f406                	sd	ra,40(sp)
     8ae:	f022                	sd	s0,32(sp)
     8b0:	ec26                	sd	s1,24(sp)
     8b2:	e84a                	sd	s2,16(sp)
     8b4:	e44e                	sd	s3,8(sp)
     8b6:	1800                	addi	s0,sp,48
     8b8:	84aa                	mv	s1,a0
     8ba:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8bc:	00001617          	auipc	a2,0x1
     8c0:	e9460613          	addi	a2,a2,-364 # 1750 <ithread_join+0xc0>
     8c4:	00000097          	auipc	ra,0x0
     8c8:	c68080e7          	jalr	-920(ra) # 52c <peek>
     8cc:	c12d                	beqz	a0,92e <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8ce:	4681                	li	a3,0
     8d0:	4601                	li	a2,0
     8d2:	85ca                	mv	a1,s2
     8d4:	8526                	mv	a0,s1
     8d6:	00000097          	auipc	ra,0x0
     8da:	b0a080e7          	jalr	-1270(ra) # 3e0 <gettoken>
  cmd = parseline(ps, es);
     8de:	85ca                	mv	a1,s2
     8e0:	8526                	mv	a0,s1
     8e2:	00000097          	auipc	ra,0x0
     8e6:	f20080e7          	jalr	-224(ra) # 802 <parseline>
     8ea:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8ec:	00001617          	auipc	a2,0x1
     8f0:	eb460613          	addi	a2,a2,-332 # 17a0 <ithread_join+0x110>
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	c34080e7          	jalr	-972(ra) # 52c <peek>
     900:	cd1d                	beqz	a0,93e <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     902:	4681                	li	a3,0
     904:	4601                	li	a2,0
     906:	85ca                	mv	a1,s2
     908:	8526                	mv	a0,s1
     90a:	00000097          	auipc	ra,0x0
     90e:	ad6080e7          	jalr	-1322(ra) # 3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     912:	864a                	mv	a2,s2
     914:	85a6                	mv	a1,s1
     916:	854e                	mv	a0,s3
     918:	00000097          	auipc	ra,0x0
     91c:	c80080e7          	jalr	-896(ra) # 598 <parseredirs>
}
     920:	70a2                	ld	ra,40(sp)
     922:	7402                	ld	s0,32(sp)
     924:	64e2                	ld	s1,24(sp)
     926:	6942                	ld	s2,16(sp)
     928:	69a2                	ld	s3,8(sp)
     92a:	6145                	addi	sp,sp,48
     92c:	8082                	ret
    panic("parseblock");
     92e:	00001517          	auipc	a0,0x1
     932:	e6250513          	addi	a0,a0,-414 # 1790 <ithread_join+0x100>
     936:	fffff097          	auipc	ra,0xfffff
     93a:	720080e7          	jalr	1824(ra) # 56 <panic>
    panic("syntax - missing )");
     93e:	00001517          	auipc	a0,0x1
     942:	e6a50513          	addi	a0,a0,-406 # 17a8 <ithread_join+0x118>
     946:	fffff097          	auipc	ra,0xfffff
     94a:	710080e7          	jalr	1808(ra) # 56 <panic>

000000000000094e <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     94e:	1101                	addi	sp,sp,-32
     950:	ec06                	sd	ra,24(sp)
     952:	e822                	sd	s0,16(sp)
     954:	e426                	sd	s1,8(sp)
     956:	1000                	addi	s0,sp,32
     958:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     95a:	c521                	beqz	a0,9a2 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     95c:	4118                	lw	a4,0(a0)
     95e:	4795                	li	a5,5
     960:	04e7e163          	bltu	a5,a4,9a2 <nulterminate+0x54>
     964:	00056783          	lwu	a5,0(a0)
     968:	078a                	slli	a5,a5,0x2
     96a:	00001717          	auipc	a4,0x1
     96e:	eca70713          	addi	a4,a4,-310 # 1834 <ithread_join+0x1a4>
     972:	97ba                	add	a5,a5,a4
     974:	439c                	lw	a5,0(a5)
     976:	97ba                	add	a5,a5,a4
     978:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     97a:	651c                	ld	a5,8(a0)
     97c:	c39d                	beqz	a5,9a2 <nulterminate+0x54>
     97e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     982:	67b8                	ld	a4,72(a5)
     984:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     988:	07a1                	addi	a5,a5,8
     98a:	ff87b703          	ld	a4,-8(a5)
     98e:	fb75                	bnez	a4,982 <nulterminate+0x34>
     990:	a809                	j	9a2 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     992:	6508                	ld	a0,8(a0)
     994:	00000097          	auipc	ra,0x0
     998:	fba080e7          	jalr	-70(ra) # 94e <nulterminate>
    *rcmd->efile = 0;
     99c:	6c9c                	ld	a5,24(s1)
     99e:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a2:	8526                	mv	a0,s1
     9a4:	60e2                	ld	ra,24(sp)
     9a6:	6442                	ld	s0,16(sp)
     9a8:	64a2                	ld	s1,8(sp)
     9aa:	6105                	addi	sp,sp,32
     9ac:	8082                	ret
    nulterminate(pcmd->left);
     9ae:	6508                	ld	a0,8(a0)
     9b0:	00000097          	auipc	ra,0x0
     9b4:	f9e080e7          	jalr	-98(ra) # 94e <nulterminate>
    nulterminate(pcmd->right);
     9b8:	6888                	ld	a0,16(s1)
     9ba:	00000097          	auipc	ra,0x0
     9be:	f94080e7          	jalr	-108(ra) # 94e <nulterminate>
    break;
     9c2:	b7c5                	j	9a2 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c4:	6508                	ld	a0,8(a0)
     9c6:	00000097          	auipc	ra,0x0
     9ca:	f88080e7          	jalr	-120(ra) # 94e <nulterminate>
    nulterminate(lcmd->right);
     9ce:	6888                	ld	a0,16(s1)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f7e080e7          	jalr	-130(ra) # 94e <nulterminate>
    break;
     9d8:	b7e9                	j	9a2 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9da:	6508                	ld	a0,8(a0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f72080e7          	jalr	-142(ra) # 94e <nulterminate>
    break;
     9e4:	bf7d                	j	9a2 <nulterminate+0x54>

00000000000009e6 <parsecmd>:
{
     9e6:	7179                	addi	sp,sp,-48
     9e8:	f406                	sd	ra,40(sp)
     9ea:	f022                	sd	s0,32(sp)
     9ec:	ec26                	sd	s1,24(sp)
     9ee:	e84a                	sd	s2,16(sp)
     9f0:	1800                	addi	s0,sp,48
     9f2:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f6:	84aa                	mv	s1,a0
     9f8:	00000097          	auipc	ra,0x0
     9fc:	1d4080e7          	jalr	468(ra) # bcc <strlen>
     a00:	1502                	slli	a0,a0,0x20
     a02:	9101                	srli	a0,a0,0x20
     a04:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a06:	85a6                	mv	a1,s1
     a08:	fd840513          	addi	a0,s0,-40
     a0c:	00000097          	auipc	ra,0x0
     a10:	df6080e7          	jalr	-522(ra) # 802 <parseline>
     a14:	892a                	mv	s2,a0
  peek(&s, es, "");
     a16:	00001617          	auipc	a2,0x1
     a1a:	e0260613          	addi	a2,a2,-510 # 1818 <ithread_join+0x188>
     a1e:	85a6                	mv	a1,s1
     a20:	fd840513          	addi	a0,s0,-40
     a24:	00000097          	auipc	ra,0x0
     a28:	b08080e7          	jalr	-1272(ra) # 52c <peek>
  if(s != es){
     a2c:	fd843603          	ld	a2,-40(s0)
     a30:	00961e63          	bne	a2,s1,a4c <parsecmd+0x66>
  nulterminate(cmd);
     a34:	854a                	mv	a0,s2
     a36:	00000097          	auipc	ra,0x0
     a3a:	f18080e7          	jalr	-232(ra) # 94e <nulterminate>
}
     a3e:	854a                	mv	a0,s2
     a40:	70a2                	ld	ra,40(sp)
     a42:	7402                	ld	s0,32(sp)
     a44:	64e2                	ld	s1,24(sp)
     a46:	6942                	ld	s2,16(sp)
     a48:	6145                	addi	sp,sp,48
     a4a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a4c:	00001597          	auipc	a1,0x1
     a50:	d7458593          	addi	a1,a1,-652 # 17c0 <ithread_join+0x130>
     a54:	4509                	li	a0,2
     a56:	00001097          	auipc	ra,0x1
     a5a:	84e080e7          	jalr	-1970(ra) # 12a4 <fprintf>
    panic("syntax");
     a5e:	00001517          	auipc	a0,0x1
     a62:	cfa50513          	addi	a0,a0,-774 # 1758 <ithread_join+0xc8>
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	5f0080e7          	jalr	1520(ra) # 56 <panic>

0000000000000a6e <main>:
{
     a6e:	7179                	addi	sp,sp,-48
     a70:	f406                	sd	ra,40(sp)
     a72:	f022                	sd	s0,32(sp)
     a74:	ec26                	sd	s1,24(sp)
     a76:	e84a                	sd	s2,16(sp)
     a78:	e44e                	sd	s3,8(sp)
     a7a:	e052                	sd	s4,0(sp)
     a7c:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a7e:	00001497          	auipc	s1,0x1
     a82:	d5248493          	addi	s1,s1,-686 # 17d0 <ithread_join+0x140>
     a86:	4589                	li	a1,2
     a88:	8526                	mv	a0,s1
     a8a:	00000097          	auipc	ra,0x0
     a8e:	4b2080e7          	jalr	1202(ra) # f3c <open>
     a92:	00054963          	bltz	a0,aa4 <main+0x36>
    if(fd >= 3){
     a96:	4789                	li	a5,2
     a98:	fea7d7e3          	bge	a5,a0,a86 <main+0x18>
      close(fd);
     a9c:	00000097          	auipc	ra,0x0
     aa0:	488080e7          	jalr	1160(ra) # f24 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa4:	00001497          	auipc	s1,0x1
     aa8:	59c48493          	addi	s1,s1,1436 # 2040 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aac:	06300913          	li	s2,99
     ab0:	02000993          	li	s3,32
     ab4:	a819                	j	aca <main+0x5c>
    if(fork1() == 0)
     ab6:	fffff097          	auipc	ra,0xfffff
     aba:	5c6080e7          	jalr	1478(ra) # 7c <fork1>
     abe:	c549                	beqz	a0,b48 <main+0xda>
    wait(0);
     ac0:	4501                	li	a0,0
     ac2:	00000097          	auipc	ra,0x0
     ac6:	442080e7          	jalr	1090(ra) # f04 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aca:	06400593          	li	a1,100
     ace:	8526                	mv	a0,s1
     ad0:	fffff097          	auipc	ra,0xfffff
     ad4:	530080e7          	jalr	1328(ra) # 0 <getcmd>
     ad8:	08054463          	bltz	a0,b60 <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     adc:	0004c783          	lbu	a5,0(s1)
     ae0:	fd279be3          	bne	a5,s2,ab6 <main+0x48>
     ae4:	0014c703          	lbu	a4,1(s1)
     ae8:	06400793          	li	a5,100
     aec:	fcf715e3          	bne	a4,a5,ab6 <main+0x48>
     af0:	0024c783          	lbu	a5,2(s1)
     af4:	fd3791e3          	bne	a5,s3,ab6 <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     af8:	00001a17          	auipc	s4,0x1
     afc:	548a0a13          	addi	s4,s4,1352 # 2040 <buf.0>
     b00:	8552                	mv	a0,s4
     b02:	00000097          	auipc	ra,0x0
     b06:	0ca080e7          	jalr	202(ra) # bcc <strlen>
     b0a:	fff5079b          	addiw	a5,a0,-1
     b0e:	1782                	slli	a5,a5,0x20
     b10:	9381                	srli	a5,a5,0x20
     b12:	9a3e                	add	s4,s4,a5
     b14:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b18:	00001517          	auipc	a0,0x1
     b1c:	52b50513          	addi	a0,a0,1323 # 2043 <buf.0+0x3>
     b20:	00000097          	auipc	ra,0x0
     b24:	44c080e7          	jalr	1100(ra) # f6c <chdir>
     b28:	fa0551e3          	bgez	a0,aca <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2c:	00001617          	auipc	a2,0x1
     b30:	51760613          	addi	a2,a2,1303 # 2043 <buf.0+0x3>
     b34:	00001597          	auipc	a1,0x1
     b38:	ca458593          	addi	a1,a1,-860 # 17d8 <ithread_join+0x148>
     b3c:	4509                	li	a0,2
     b3e:	00000097          	auipc	ra,0x0
     b42:	766080e7          	jalr	1894(ra) # 12a4 <fprintf>
     b46:	b751                	j	aca <main+0x5c>
      runcmd(parsecmd(buf));
     b48:	00001517          	auipc	a0,0x1
     b4c:	4f850513          	addi	a0,a0,1272 # 2040 <buf.0>
     b50:	00000097          	auipc	ra,0x0
     b54:	e96080e7          	jalr	-362(ra) # 9e6 <parsecmd>
     b58:	fffff097          	auipc	ra,0xfffff
     b5c:	552080e7          	jalr	1362(ra) # aa <runcmd>
  exit(0);
     b60:	4501                	li	a0,0
     b62:	00000097          	auipc	ra,0x0
     b66:	39a080e7          	jalr	922(ra) # efc <exit>

0000000000000b6a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     b6a:	1141                	addi	sp,sp,-16
     b6c:	e406                	sd	ra,8(sp)
     b6e:	e022                	sd	s0,0(sp)
     b70:	0800                	addi	s0,sp,16
  extern int main();
  main();
     b72:	00000097          	auipc	ra,0x0
     b76:	efc080e7          	jalr	-260(ra) # a6e <main>
  exit(0);
     b7a:	4501                	li	a0,0
     b7c:	00000097          	auipc	ra,0x0
     b80:	380080e7          	jalr	896(ra) # efc <exit>

0000000000000b84 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b84:	1141                	addi	sp,sp,-16
     b86:	e422                	sd	s0,8(sp)
     b88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b8a:	87aa                	mv	a5,a0
     b8c:	0585                	addi	a1,a1,1
     b8e:	0785                	addi	a5,a5,1
     b90:	fff5c703          	lbu	a4,-1(a1)
     b94:	fee78fa3          	sb	a4,-1(a5)
     b98:	fb75                	bnez	a4,b8c <strcpy+0x8>
    ;
  return os;
}
     b9a:	6422                	ld	s0,8(sp)
     b9c:	0141                	addi	sp,sp,16
     b9e:	8082                	ret

0000000000000ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba0:	1141                	addi	sp,sp,-16
     ba2:	e422                	sd	s0,8(sp)
     ba4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     ba6:	00054783          	lbu	a5,0(a0)
     baa:	cb91                	beqz	a5,bbe <strcmp+0x1e>
     bac:	0005c703          	lbu	a4,0(a1)
     bb0:	00f71763          	bne	a4,a5,bbe <strcmp+0x1e>
    p++, q++;
     bb4:	0505                	addi	a0,a0,1
     bb6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bb8:	00054783          	lbu	a5,0(a0)
     bbc:	fbe5                	bnez	a5,bac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bbe:	0005c503          	lbu	a0,0(a1)
}
     bc2:	40a7853b          	subw	a0,a5,a0
     bc6:	6422                	ld	s0,8(sp)
     bc8:	0141                	addi	sp,sp,16
     bca:	8082                	ret

0000000000000bcc <strlen>:

uint
strlen(const char *s)
{
     bcc:	1141                	addi	sp,sp,-16
     bce:	e422                	sd	s0,8(sp)
     bd0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bd2:	00054783          	lbu	a5,0(a0)
     bd6:	cf91                	beqz	a5,bf2 <strlen+0x26>
     bd8:	0505                	addi	a0,a0,1
     bda:	87aa                	mv	a5,a0
     bdc:	86be                	mv	a3,a5
     bde:	0785                	addi	a5,a5,1
     be0:	fff7c703          	lbu	a4,-1(a5)
     be4:	ff65                	bnez	a4,bdc <strlen+0x10>
     be6:	40a6853b          	subw	a0,a3,a0
     bea:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bec:	6422                	ld	s0,8(sp)
     bee:	0141                	addi	sp,sp,16
     bf0:	8082                	ret
  for(n = 0; s[n]; n++)
     bf2:	4501                	li	a0,0
     bf4:	bfe5                	j	bec <strlen+0x20>

0000000000000bf6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bf6:	1141                	addi	sp,sp,-16
     bf8:	e422                	sd	s0,8(sp)
     bfa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bfc:	ca19                	beqz	a2,c12 <memset+0x1c>
     bfe:	87aa                	mv	a5,a0
     c00:	1602                	slli	a2,a2,0x20
     c02:	9201                	srli	a2,a2,0x20
     c04:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c08:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c0c:	0785                	addi	a5,a5,1
     c0e:	fee79de3          	bne	a5,a4,c08 <memset+0x12>
  }
  return dst;
}
     c12:	6422                	ld	s0,8(sp)
     c14:	0141                	addi	sp,sp,16
     c16:	8082                	ret

0000000000000c18 <strchr>:

char*
strchr(const char *s, char c)
{
     c18:	1141                	addi	sp,sp,-16
     c1a:	e422                	sd	s0,8(sp)
     c1c:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c1e:	00054783          	lbu	a5,0(a0)
     c22:	cb99                	beqz	a5,c38 <strchr+0x20>
    if(*s == c)
     c24:	00f58763          	beq	a1,a5,c32 <strchr+0x1a>
  for(; *s; s++)
     c28:	0505                	addi	a0,a0,1
     c2a:	00054783          	lbu	a5,0(a0)
     c2e:	fbfd                	bnez	a5,c24 <strchr+0xc>
      return (char*)s;
  return 0;
     c30:	4501                	li	a0,0
}
     c32:	6422                	ld	s0,8(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret
  return 0;
     c38:	4501                	li	a0,0
     c3a:	bfe5                	j	c32 <strchr+0x1a>

0000000000000c3c <gets>:

char*
gets(char *buf, int max)
{
     c3c:	711d                	addi	sp,sp,-96
     c3e:	ec86                	sd	ra,88(sp)
     c40:	e8a2                	sd	s0,80(sp)
     c42:	e4a6                	sd	s1,72(sp)
     c44:	e0ca                	sd	s2,64(sp)
     c46:	fc4e                	sd	s3,56(sp)
     c48:	f852                	sd	s4,48(sp)
     c4a:	f456                	sd	s5,40(sp)
     c4c:	f05a                	sd	s6,32(sp)
     c4e:	ec5e                	sd	s7,24(sp)
     c50:	1080                	addi	s0,sp,96
     c52:	8baa                	mv	s7,a0
     c54:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c56:	892a                	mv	s2,a0
     c58:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c5a:	4aa9                	li	s5,10
     c5c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c5e:	89a6                	mv	s3,s1
     c60:	2485                	addiw	s1,s1,1
     c62:	0344d863          	bge	s1,s4,c92 <gets+0x56>
    cc = read(0, &c, 1);
     c66:	4605                	li	a2,1
     c68:	faf40593          	addi	a1,s0,-81
     c6c:	4501                	li	a0,0
     c6e:	00000097          	auipc	ra,0x0
     c72:	2a6080e7          	jalr	678(ra) # f14 <read>
    if(cc < 1)
     c76:	00a05e63          	blez	a0,c92 <gets+0x56>
    buf[i++] = c;
     c7a:	faf44783          	lbu	a5,-81(s0)
     c7e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c82:	01578763          	beq	a5,s5,c90 <gets+0x54>
     c86:	0905                	addi	s2,s2,1
     c88:	fd679be3          	bne	a5,s6,c5e <gets+0x22>
    buf[i++] = c;
     c8c:	89a6                	mv	s3,s1
     c8e:	a011                	j	c92 <gets+0x56>
     c90:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c92:	99de                	add	s3,s3,s7
     c94:	00098023          	sb	zero,0(s3)
  return buf;
}
     c98:	855e                	mv	a0,s7
     c9a:	60e6                	ld	ra,88(sp)
     c9c:	6446                	ld	s0,80(sp)
     c9e:	64a6                	ld	s1,72(sp)
     ca0:	6906                	ld	s2,64(sp)
     ca2:	79e2                	ld	s3,56(sp)
     ca4:	7a42                	ld	s4,48(sp)
     ca6:	7aa2                	ld	s5,40(sp)
     ca8:	7b02                	ld	s6,32(sp)
     caa:	6be2                	ld	s7,24(sp)
     cac:	6125                	addi	sp,sp,96
     cae:	8082                	ret

0000000000000cb0 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
     cb0:	711d                	addi	sp,sp,-96
     cb2:	ec86                	sd	ra,88(sp)
     cb4:	e8a2                	sd	s0,80(sp)
     cb6:	e4a6                	sd	s1,72(sp)
     cb8:	e0ca                	sd	s2,64(sp)
     cba:	fc4e                	sd	s3,56(sp)
     cbc:	f852                	sd	s4,48(sp)
     cbe:	f456                	sd	s5,40(sp)
     cc0:	f05a                	sd	s6,32(sp)
     cc2:	ec5e                	sd	s7,24(sp)
     cc4:	1080                	addi	s0,sp,96
     cc6:	8baa                	mv	s7,a0
     cc8:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
     cca:	892a                	mv	s2,a0
     ccc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cce:	4aa9                	li	s5,10
     cd0:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
     cd2:	8a26                	mv	s4,s1
     cd4:	2485                	addiw	s1,s1,1
     cd6:	0334d863          	bge	s1,s3,d06 <fgetstdin+0x56>
    cc = read(0, &c, 1);
     cda:	4605                	li	a2,1
     cdc:	faf40593          	addi	a1,s0,-81
     ce0:	4501                	li	a0,0
     ce2:	00000097          	auipc	ra,0x0
     ce6:	232080e7          	jalr	562(ra) # f14 <read>
    if(cc < 1)
     cea:	00a05e63          	blez	a0,d06 <fgetstdin+0x56>
    buf[i++] = c;
     cee:	faf44783          	lbu	a5,-81(s0)
     cf2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cf6:	01578763          	beq	a5,s5,d04 <fgetstdin+0x54>
     cfa:	0905                	addi	s2,s2,1
     cfc:	fd679be3          	bne	a5,s6,cd2 <fgetstdin+0x22>
    buf[i++] = c;
     d00:	8a26                	mv	s4,s1
     d02:	a011                	j	d06 <fgetstdin+0x56>
     d04:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
     d06:	9bd2                	add	s7,s7,s4
     d08:	000b8023          	sb	zero,0(s7)
  return i;
}
     d0c:	8552                	mv	a0,s4
     d0e:	60e6                	ld	ra,88(sp)
     d10:	6446                	ld	s0,80(sp)
     d12:	64a6                	ld	s1,72(sp)
     d14:	6906                	ld	s2,64(sp)
     d16:	79e2                	ld	s3,56(sp)
     d18:	7a42                	ld	s4,48(sp)
     d1a:	7aa2                	ld	s5,40(sp)
     d1c:	7b02                	ld	s6,32(sp)
     d1e:	6be2                	ld	s7,24(sp)
     d20:	6125                	addi	sp,sp,96
     d22:	8082                	ret

0000000000000d24 <stat>:

int
stat(const char *n, struct stat *st)
{
     d24:	1101                	addi	sp,sp,-32
     d26:	ec06                	sd	ra,24(sp)
     d28:	e822                	sd	s0,16(sp)
     d2a:	e04a                	sd	s2,0(sp)
     d2c:	1000                	addi	s0,sp,32
     d2e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d30:	4581                	li	a1,0
     d32:	00000097          	auipc	ra,0x0
     d36:	20a080e7          	jalr	522(ra) # f3c <open>
  if(fd < 0)
     d3a:	02054663          	bltz	a0,d66 <stat+0x42>
     d3e:	e426                	sd	s1,8(sp)
     d40:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d42:	85ca                	mv	a1,s2
     d44:	00000097          	auipc	ra,0x0
     d48:	210080e7          	jalr	528(ra) # f54 <fstat>
     d4c:	892a                	mv	s2,a0
  close(fd);
     d4e:	8526                	mv	a0,s1
     d50:	00000097          	auipc	ra,0x0
     d54:	1d4080e7          	jalr	468(ra) # f24 <close>
  return r;
     d58:	64a2                	ld	s1,8(sp)
}
     d5a:	854a                	mv	a0,s2
     d5c:	60e2                	ld	ra,24(sp)
     d5e:	6442                	ld	s0,16(sp)
     d60:	6902                	ld	s2,0(sp)
     d62:	6105                	addi	sp,sp,32
     d64:	8082                	ret
    return -1;
     d66:	597d                	li	s2,-1
     d68:	bfcd                	j	d5a <stat+0x36>

0000000000000d6a <atoi>:

int
atoi(const char *s)
{
     d6a:	1141                	addi	sp,sp,-16
     d6c:	e422                	sd	s0,8(sp)
     d6e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d70:	00054683          	lbu	a3,0(a0)
     d74:	fd06879b          	addiw	a5,a3,-48
     d78:	0ff7f793          	zext.b	a5,a5
     d7c:	4625                	li	a2,9
     d7e:	02f66863          	bltu	a2,a5,dae <atoi+0x44>
     d82:	872a                	mv	a4,a0
  n = 0;
     d84:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d86:	0705                	addi	a4,a4,1
     d88:	0025179b          	slliw	a5,a0,0x2
     d8c:	9fa9                	addw	a5,a5,a0
     d8e:	0017979b          	slliw	a5,a5,0x1
     d92:	9fb5                	addw	a5,a5,a3
     d94:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d98:	00074683          	lbu	a3,0(a4)
     d9c:	fd06879b          	addiw	a5,a3,-48
     da0:	0ff7f793          	zext.b	a5,a5
     da4:	fef671e3          	bgeu	a2,a5,d86 <atoi+0x1c>
  return n;
}
     da8:	6422                	ld	s0,8(sp)
     daa:	0141                	addi	sp,sp,16
     dac:	8082                	ret
  n = 0;
     dae:	4501                	li	a0,0
     db0:	bfe5                	j	da8 <atoi+0x3e>

0000000000000db2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     db2:	1141                	addi	sp,sp,-16
     db4:	e422                	sd	s0,8(sp)
     db6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     db8:	02b57463          	bgeu	a0,a1,de0 <memmove+0x2e>
    while(n-- > 0)
     dbc:	00c05f63          	blez	a2,dda <memmove+0x28>
     dc0:	1602                	slli	a2,a2,0x20
     dc2:	9201                	srli	a2,a2,0x20
     dc4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dc8:	872a                	mv	a4,a0
      *dst++ = *src++;
     dca:	0585                	addi	a1,a1,1
     dcc:	0705                	addi	a4,a4,1
     dce:	fff5c683          	lbu	a3,-1(a1)
     dd2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dd6:	fef71ae3          	bne	a4,a5,dca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     dda:	6422                	ld	s0,8(sp)
     ddc:	0141                	addi	sp,sp,16
     dde:	8082                	ret
    dst += n;
     de0:	00c50733          	add	a4,a0,a2
    src += n;
     de4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     de6:	fec05ae3          	blez	a2,dda <memmove+0x28>
     dea:	fff6079b          	addiw	a5,a2,-1
     dee:	1782                	slli	a5,a5,0x20
     df0:	9381                	srli	a5,a5,0x20
     df2:	fff7c793          	not	a5,a5
     df6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     df8:	15fd                	addi	a1,a1,-1
     dfa:	177d                	addi	a4,a4,-1
     dfc:	0005c683          	lbu	a3,0(a1)
     e00:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e04:	fee79ae3          	bne	a5,a4,df8 <memmove+0x46>
     e08:	bfc9                	j	dda <memmove+0x28>

0000000000000e0a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e0a:	1141                	addi	sp,sp,-16
     e0c:	e422                	sd	s0,8(sp)
     e0e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e10:	ca05                	beqz	a2,e40 <memcmp+0x36>
     e12:	fff6069b          	addiw	a3,a2,-1
     e16:	1682                	slli	a3,a3,0x20
     e18:	9281                	srli	a3,a3,0x20
     e1a:	0685                	addi	a3,a3,1
     e1c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e1e:	00054783          	lbu	a5,0(a0)
     e22:	0005c703          	lbu	a4,0(a1)
     e26:	00e79863          	bne	a5,a4,e36 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e2a:	0505                	addi	a0,a0,1
    p2++;
     e2c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e2e:	fed518e3          	bne	a0,a3,e1e <memcmp+0x14>
  }
  return 0;
     e32:	4501                	li	a0,0
     e34:	a019                	j	e3a <memcmp+0x30>
      return *p1 - *p2;
     e36:	40e7853b          	subw	a0,a5,a4
}
     e3a:	6422                	ld	s0,8(sp)
     e3c:	0141                	addi	sp,sp,16
     e3e:	8082                	ret
  return 0;
     e40:	4501                	li	a0,0
     e42:	bfe5                	j	e3a <memcmp+0x30>

0000000000000e44 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e44:	1141                	addi	sp,sp,-16
     e46:	e406                	sd	ra,8(sp)
     e48:	e022                	sd	s0,0(sp)
     e4a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e4c:	00000097          	auipc	ra,0x0
     e50:	f66080e7          	jalr	-154(ra) # db2 <memmove>
}
     e54:	60a2                	ld	ra,8(sp)
     e56:	6402                	ld	s0,0(sp)
     e58:	0141                	addi	sp,sp,16
     e5a:	8082                	ret

0000000000000e5c <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
     e5c:	1141                	addi	sp,sp,-16
     e5e:	e422                	sd	s0,8(sp)
     e60:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
     e62:	00054783          	lbu	a5,0(a0)
     e66:	cfbd                	beqz	a5,ee4 <inet_addr+0x88>
  int dots = 0;
     e68:	4801                	li	a6,0
  int digits = 0;
     e6a:	4601                	li	a2,0
  int octet = 0;
     e6c:	4681                	li	a3,0
  uint result = 0;
     e6e:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
     e70:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
     e72:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
     e76:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
     e78:	4301                	li	t1,0
      if (octet > 255)
     e7a:	0ff00e13          	li	t3,255
     e7e:	a015                	j	ea2 <inet_addr+0x46>
    } else if (*s == '.') {
     e80:	07d79463          	bne	a5,t4,ee8 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
     e84:	c625                	beqz	a2,eec <inet_addr+0x90>
     e86:	07e80563          	beq	a6,t5,ef0 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
     e8a:	0085959b          	slliw	a1,a1,0x8
     e8e:	8ecd                	or	a3,a3,a1
     e90:	0006859b          	sext.w	a1,a3
      dots++;
     e94:	2805                	addiw	a6,a6,1
      digits = 0;
     e96:	861a                	mv	a2,t1
      octet = 0;
     e98:	869a                	mv	a3,t1
  for (; *s; s++) {
     e9a:	0505                	addi	a0,a0,1
     e9c:	00054783          	lbu	a5,0(a0)
     ea0:	c79d                	beqz	a5,ece <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
     ea2:	fd07871b          	addiw	a4,a5,-48
     ea6:	0ff77713          	zext.b	a4,a4
     eaa:	fce8ebe3          	bltu	a7,a4,e80 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
     eae:	0026971b          	slliw	a4,a3,0x2
     eb2:	9f35                	addw	a4,a4,a3
     eb4:	0017171b          	slliw	a4,a4,0x1
     eb8:	fd07879b          	addiw	a5,a5,-48
     ebc:	00e786bb          	addw	a3,a5,a4
      digits++;
     ec0:	2605                	addiw	a2,a2,1
      if (octet > 255)
     ec2:	fcde5ce3          	bge	t3,a3,e9a <inet_addr+0x3e>
        return 0;
     ec6:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
     ec8:	6422                	ld	s0,8(sp)
     eca:	0141                	addi	sp,sp,16
     ecc:	8082                	ret
    return 0;
     ece:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
     ed0:	de65                	beqz	a2,ec8 <inet_addr+0x6c>
     ed2:	478d                	li	a5,3
     ed4:	fef81ae3          	bne	a6,a5,ec8 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
     ed8:	0085959b          	slliw	a1,a1,0x8
     edc:	8ecd                	or	a3,a3,a1
     ede:	0006851b          	sext.w	a0,a3
  return result;
     ee2:	b7dd                	j	ec8 <inet_addr+0x6c>
    return 0;
     ee4:	4501                	li	a0,0
     ee6:	b7cd                	j	ec8 <inet_addr+0x6c>
      return 0;
     ee8:	4501                	li	a0,0
     eea:	bff9                	j	ec8 <inet_addr+0x6c>
        return 0;
     eec:	4501                	li	a0,0
     eee:	bfe9                	j	ec8 <inet_addr+0x6c>
     ef0:	4501                	li	a0,0
     ef2:	bfd9                	j	ec8 <inet_addr+0x6c>

0000000000000ef4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ef4:	4885                	li	a7,1
 ecall
     ef6:	00000073          	ecall
 ret
     efa:	8082                	ret

0000000000000efc <exit>:
.global exit
exit:
 li a7, SYS_exit
     efc:	4889                	li	a7,2
 ecall
     efe:	00000073          	ecall
 ret
     f02:	8082                	ret

0000000000000f04 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f04:	488d                	li	a7,3
 ecall
     f06:	00000073          	ecall
 ret
     f0a:	8082                	ret

0000000000000f0c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f0c:	4891                	li	a7,4
 ecall
     f0e:	00000073          	ecall
 ret
     f12:	8082                	ret

0000000000000f14 <read>:
.global read
read:
 li a7, SYS_read
     f14:	4895                	li	a7,5
 ecall
     f16:	00000073          	ecall
 ret
     f1a:	8082                	ret

0000000000000f1c <write>:
.global write
write:
 li a7, SYS_write
     f1c:	48c1                	li	a7,16
 ecall
     f1e:	00000073          	ecall
 ret
     f22:	8082                	ret

0000000000000f24 <close>:
.global close
close:
 li a7, SYS_close
     f24:	48d5                	li	a7,21
 ecall
     f26:	00000073          	ecall
 ret
     f2a:	8082                	ret

0000000000000f2c <kill>:
.global kill
kill:
 li a7, SYS_kill
     f2c:	4899                	li	a7,6
 ecall
     f2e:	00000073          	ecall
 ret
     f32:	8082                	ret

0000000000000f34 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f34:	489d                	li	a7,7
 ecall
     f36:	00000073          	ecall
 ret
     f3a:	8082                	ret

0000000000000f3c <open>:
.global open
open:
 li a7, SYS_open
     f3c:	48bd                	li	a7,15
 ecall
     f3e:	00000073          	ecall
 ret
     f42:	8082                	ret

0000000000000f44 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f44:	48c5                	li	a7,17
 ecall
     f46:	00000073          	ecall
 ret
     f4a:	8082                	ret

0000000000000f4c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f4c:	48c9                	li	a7,18
 ecall
     f4e:	00000073          	ecall
 ret
     f52:	8082                	ret

0000000000000f54 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f54:	48a1                	li	a7,8
 ecall
     f56:	00000073          	ecall
 ret
     f5a:	8082                	ret

0000000000000f5c <link>:
.global link
link:
 li a7, SYS_link
     f5c:	48cd                	li	a7,19
 ecall
     f5e:	00000073          	ecall
 ret
     f62:	8082                	ret

0000000000000f64 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f64:	48d1                	li	a7,20
 ecall
     f66:	00000073          	ecall
 ret
     f6a:	8082                	ret

0000000000000f6c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f6c:	48a5                	li	a7,9
 ecall
     f6e:	00000073          	ecall
 ret
     f72:	8082                	ret

0000000000000f74 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f74:	48a9                	li	a7,10
 ecall
     f76:	00000073          	ecall
 ret
     f7a:	8082                	ret

0000000000000f7c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f7c:	48ad                	li	a7,11
 ecall
     f7e:	00000073          	ecall
 ret
     f82:	8082                	ret

0000000000000f84 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f84:	48b1                	li	a7,12
 ecall
     f86:	00000073          	ecall
 ret
     f8a:	8082                	ret

0000000000000f8c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f8c:	48b5                	li	a7,13
 ecall
     f8e:	00000073          	ecall
 ret
     f92:	8082                	ret

0000000000000f94 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f94:	48b9                	li	a7,14
 ecall
     f96:	00000073          	ecall
 ret
     f9a:	8082                	ret

0000000000000f9c <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
     f9c:	48d9                	li	a7,22
 ecall
     f9e:	00000073          	ecall
 ret
     fa2:	8082                	ret

0000000000000fa4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
     fa4:	48dd                	li	a7,23
 ecall
     fa6:	00000073          	ecall
 ret
     faa:	8082                	ret

0000000000000fac <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
     fac:	48e1                	li	a7,24
 ecall
     fae:	00000073          	ecall
 ret
     fb2:	8082                	ret

0000000000000fb4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
     fb4:	48e5                	li	a7,25
 ecall
     fb6:	00000073          	ecall
 ret
     fba:	8082                	ret

0000000000000fbc <socket>:
.global socket
socket:
 li a7, SYS_socket
     fbc:	48e9                	li	a7,26
 ecall
     fbe:	00000073          	ecall
 ret
     fc2:	8082                	ret

0000000000000fc4 <bind>:
.global bind
bind:
 li a7, SYS_bind
     fc4:	48ed                	li	a7,27
 ecall
     fc6:	00000073          	ecall
 ret
     fca:	8082                	ret

0000000000000fcc <accept>:
.global accept
accept:
 li a7, SYS_accept
     fcc:	48f5                	li	a7,29
 ecall
     fce:	00000073          	ecall
 ret
     fd2:	8082                	ret

0000000000000fd4 <listen>:
.global listen
listen:
 li a7, SYS_listen
     fd4:	48f1                	li	a7,28
 ecall
     fd6:	00000073          	ecall
 ret
     fda:	8082                	ret

0000000000000fdc <connect>:
.global connect
connect:
 li a7, SYS_connect
     fdc:	48f9                	li	a7,30
 ecall
     fde:	00000073          	ecall
 ret
     fe2:	8082                	ret

0000000000000fe4 <send>:
.global send
send:
 li a7, SYS_send
     fe4:	48fd                	li	a7,31
 ecall
     fe6:	00000073          	ecall
 ret
     fea:	8082                	ret

0000000000000fec <recv>:
.global recv
recv:
 li a7, SYS_recv
     fec:	02000893          	li	a7,32
 ecall
     ff0:	00000073          	ecall
 ret
     ff4:	8082                	ret

0000000000000ff6 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
     ff6:	02100893          	li	a7,33
 ecall
     ffa:	00000073          	ecall
 ret
     ffe:	8082                	ret

0000000000001000 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
    1000:	02200893          	li	a7,34
 ecall
    1004:	00000073          	ecall
 ret
    1008:	8082                	ret

000000000000100a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    100a:	1101                	addi	sp,sp,-32
    100c:	ec06                	sd	ra,24(sp)
    100e:	e822                	sd	s0,16(sp)
    1010:	1000                	addi	s0,sp,32
    1012:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1016:	4605                	li	a2,1
    1018:	fef40593          	addi	a1,s0,-17
    101c:	00000097          	auipc	ra,0x0
    1020:	f00080e7          	jalr	-256(ra) # f1c <write>
}
    1024:	60e2                	ld	ra,24(sp)
    1026:	6442                	ld	s0,16(sp)
    1028:	6105                	addi	sp,sp,32
    102a:	8082                	ret

000000000000102c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    102c:	7139                	addi	sp,sp,-64
    102e:	fc06                	sd	ra,56(sp)
    1030:	f822                	sd	s0,48(sp)
    1032:	f426                	sd	s1,40(sp)
    1034:	0080                	addi	s0,sp,64
    1036:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1038:	c299                	beqz	a3,103e <printint+0x12>
    103a:	0805cb63          	bltz	a1,10d0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    103e:	2581                	sext.w	a1,a1
  neg = 0;
    1040:	4881                	li	a7,0
    1042:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1046:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1048:	2601                	sext.w	a2,a2
    104a:	00001517          	auipc	a0,0x1
    104e:	85e50513          	addi	a0,a0,-1954 # 18a8 <digits>
    1052:	883a                	mv	a6,a4
    1054:	2705                	addiw	a4,a4,1
    1056:	02c5f7bb          	remuw	a5,a1,a2
    105a:	1782                	slli	a5,a5,0x20
    105c:	9381                	srli	a5,a5,0x20
    105e:	97aa                	add	a5,a5,a0
    1060:	0007c783          	lbu	a5,0(a5)
    1064:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1068:	0005879b          	sext.w	a5,a1
    106c:	02c5d5bb          	divuw	a1,a1,a2
    1070:	0685                	addi	a3,a3,1
    1072:	fec7f0e3          	bgeu	a5,a2,1052 <printint+0x26>
  if(neg)
    1076:	00088c63          	beqz	a7,108e <printint+0x62>
    buf[i++] = '-';
    107a:	fd070793          	addi	a5,a4,-48
    107e:	00878733          	add	a4,a5,s0
    1082:	02d00793          	li	a5,45
    1086:	fef70823          	sb	a5,-16(a4)
    108a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    108e:	02e05c63          	blez	a4,10c6 <printint+0x9a>
    1092:	f04a                	sd	s2,32(sp)
    1094:	ec4e                	sd	s3,24(sp)
    1096:	fc040793          	addi	a5,s0,-64
    109a:	00e78933          	add	s2,a5,a4
    109e:	fff78993          	addi	s3,a5,-1
    10a2:	99ba                	add	s3,s3,a4
    10a4:	377d                	addiw	a4,a4,-1
    10a6:	1702                	slli	a4,a4,0x20
    10a8:	9301                	srli	a4,a4,0x20
    10aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    10ae:	fff94583          	lbu	a1,-1(s2)
    10b2:	8526                	mv	a0,s1
    10b4:	00000097          	auipc	ra,0x0
    10b8:	f56080e7          	jalr	-170(ra) # 100a <putc>
  while(--i >= 0)
    10bc:	197d                	addi	s2,s2,-1
    10be:	ff3918e3          	bne	s2,s3,10ae <printint+0x82>
    10c2:	7902                	ld	s2,32(sp)
    10c4:	69e2                	ld	s3,24(sp)
}
    10c6:	70e2                	ld	ra,56(sp)
    10c8:	7442                	ld	s0,48(sp)
    10ca:	74a2                	ld	s1,40(sp)
    10cc:	6121                	addi	sp,sp,64
    10ce:	8082                	ret
    x = -xx;
    10d0:	40b005bb          	negw	a1,a1
    neg = 1;
    10d4:	4885                	li	a7,1
    x = -xx;
    10d6:	b7b5                	j	1042 <printint+0x16>

00000000000010d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10d8:	715d                	addi	sp,sp,-80
    10da:	e486                	sd	ra,72(sp)
    10dc:	e0a2                	sd	s0,64(sp)
    10de:	f84a                	sd	s2,48(sp)
    10e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10e2:	0005c903          	lbu	s2,0(a1)
    10e6:	1a090a63          	beqz	s2,129a <vprintf+0x1c2>
    10ea:	fc26                	sd	s1,56(sp)
    10ec:	f44e                	sd	s3,40(sp)
    10ee:	f052                	sd	s4,32(sp)
    10f0:	ec56                	sd	s5,24(sp)
    10f2:	e85a                	sd	s6,16(sp)
    10f4:	e45e                	sd	s7,8(sp)
    10f6:	8aaa                	mv	s5,a0
    10f8:	8bb2                	mv	s7,a2
    10fa:	00158493          	addi	s1,a1,1
  state = 0;
    10fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1100:	02500a13          	li	s4,37
    1104:	4b55                	li	s6,21
    1106:	a839                	j	1124 <vprintf+0x4c>
        putc(fd, c);
    1108:	85ca                	mv	a1,s2
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	efe080e7          	jalr	-258(ra) # 100a <putc>
    1114:	a019                	j	111a <vprintf+0x42>
    } else if(state == '%'){
    1116:	01498d63          	beq	s3,s4,1130 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    111a:	0485                	addi	s1,s1,1
    111c:	fff4c903          	lbu	s2,-1(s1)
    1120:	16090763          	beqz	s2,128e <vprintf+0x1b6>
    if(state == 0){
    1124:	fe0999e3          	bnez	s3,1116 <vprintf+0x3e>
      if(c == '%'){
    1128:	ff4910e3          	bne	s2,s4,1108 <vprintf+0x30>
        state = '%';
    112c:	89d2                	mv	s3,s4
    112e:	b7f5                	j	111a <vprintf+0x42>
      if(c == 'd'){
    1130:	13490463          	beq	s2,s4,1258 <vprintf+0x180>
    1134:	f9d9079b          	addiw	a5,s2,-99
    1138:	0ff7f793          	zext.b	a5,a5
    113c:	12fb6763          	bltu	s6,a5,126a <vprintf+0x192>
    1140:	f9d9079b          	addiw	a5,s2,-99
    1144:	0ff7f713          	zext.b	a4,a5
    1148:	12eb6163          	bltu	s6,a4,126a <vprintf+0x192>
    114c:	00271793          	slli	a5,a4,0x2
    1150:	00000717          	auipc	a4,0x0
    1154:	70070713          	addi	a4,a4,1792 # 1850 <ithread_join+0x1c0>
    1158:	97ba                	add	a5,a5,a4
    115a:	439c                	lw	a5,0(a5)
    115c:	97ba                	add	a5,a5,a4
    115e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1160:	008b8913          	addi	s2,s7,8
    1164:	4685                	li	a3,1
    1166:	4629                	li	a2,10
    1168:	000ba583          	lw	a1,0(s7)
    116c:	8556                	mv	a0,s5
    116e:	00000097          	auipc	ra,0x0
    1172:	ebe080e7          	jalr	-322(ra) # 102c <printint>
    1176:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1178:	4981                	li	s3,0
    117a:	b745                	j	111a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    117c:	008b8913          	addi	s2,s7,8
    1180:	4681                	li	a3,0
    1182:	4629                	li	a2,10
    1184:	000ba583          	lw	a1,0(s7)
    1188:	8556                	mv	a0,s5
    118a:	00000097          	auipc	ra,0x0
    118e:	ea2080e7          	jalr	-350(ra) # 102c <printint>
    1192:	8bca                	mv	s7,s2
      state = 0;
    1194:	4981                	li	s3,0
    1196:	b751                	j	111a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1198:	008b8913          	addi	s2,s7,8
    119c:	4681                	li	a3,0
    119e:	4641                	li	a2,16
    11a0:	000ba583          	lw	a1,0(s7)
    11a4:	8556                	mv	a0,s5
    11a6:	00000097          	auipc	ra,0x0
    11aa:	e86080e7          	jalr	-378(ra) # 102c <printint>
    11ae:	8bca                	mv	s7,s2
      state = 0;
    11b0:	4981                	li	s3,0
    11b2:	b7a5                	j	111a <vprintf+0x42>
    11b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    11b6:	008b8c13          	addi	s8,s7,8
    11ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    11be:	03000593          	li	a1,48
    11c2:	8556                	mv	a0,s5
    11c4:	00000097          	auipc	ra,0x0
    11c8:	e46080e7          	jalr	-442(ra) # 100a <putc>
  putc(fd, 'x');
    11cc:	07800593          	li	a1,120
    11d0:	8556                	mv	a0,s5
    11d2:	00000097          	auipc	ra,0x0
    11d6:	e38080e7          	jalr	-456(ra) # 100a <putc>
    11da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11dc:	00000b97          	auipc	s7,0x0
    11e0:	6ccb8b93          	addi	s7,s7,1740 # 18a8 <digits>
    11e4:	03c9d793          	srli	a5,s3,0x3c
    11e8:	97de                	add	a5,a5,s7
    11ea:	0007c583          	lbu	a1,0(a5)
    11ee:	8556                	mv	a0,s5
    11f0:	00000097          	auipc	ra,0x0
    11f4:	e1a080e7          	jalr	-486(ra) # 100a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11f8:	0992                	slli	s3,s3,0x4
    11fa:	397d                	addiw	s2,s2,-1
    11fc:	fe0914e3          	bnez	s2,11e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1200:	8be2                	mv	s7,s8
      state = 0;
    1202:	4981                	li	s3,0
    1204:	6c02                	ld	s8,0(sp)
    1206:	bf11                	j	111a <vprintf+0x42>
        s = va_arg(ap, char*);
    1208:	008b8993          	addi	s3,s7,8
    120c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1210:	02090163          	beqz	s2,1232 <vprintf+0x15a>
        while(*s != 0){
    1214:	00094583          	lbu	a1,0(s2)
    1218:	c9a5                	beqz	a1,1288 <vprintf+0x1b0>
          putc(fd, *s);
    121a:	8556                	mv	a0,s5
    121c:	00000097          	auipc	ra,0x0
    1220:	dee080e7          	jalr	-530(ra) # 100a <putc>
          s++;
    1224:	0905                	addi	s2,s2,1
        while(*s != 0){
    1226:	00094583          	lbu	a1,0(s2)
    122a:	f9e5                	bnez	a1,121a <vprintf+0x142>
        s = va_arg(ap, char*);
    122c:	8bce                	mv	s7,s3
      state = 0;
    122e:	4981                	li	s3,0
    1230:	b5ed                	j	111a <vprintf+0x42>
          s = "(null)";
    1232:	00000917          	auipc	s2,0x0
    1236:	5b690913          	addi	s2,s2,1462 # 17e8 <ithread_join+0x158>
        while(*s != 0){
    123a:	02800593          	li	a1,40
    123e:	bff1                	j	121a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1240:	008b8913          	addi	s2,s7,8
    1244:	000bc583          	lbu	a1,0(s7)
    1248:	8556                	mv	a0,s5
    124a:	00000097          	auipc	ra,0x0
    124e:	dc0080e7          	jalr	-576(ra) # 100a <putc>
    1252:	8bca                	mv	s7,s2
      state = 0;
    1254:	4981                	li	s3,0
    1256:	b5d1                	j	111a <vprintf+0x42>
        putc(fd, c);
    1258:	02500593          	li	a1,37
    125c:	8556                	mv	a0,s5
    125e:	00000097          	auipc	ra,0x0
    1262:	dac080e7          	jalr	-596(ra) # 100a <putc>
      state = 0;
    1266:	4981                	li	s3,0
    1268:	bd4d                	j	111a <vprintf+0x42>
        putc(fd, '%');
    126a:	02500593          	li	a1,37
    126e:	8556                	mv	a0,s5
    1270:	00000097          	auipc	ra,0x0
    1274:	d9a080e7          	jalr	-614(ra) # 100a <putc>
        putc(fd, c);
    1278:	85ca                	mv	a1,s2
    127a:	8556                	mv	a0,s5
    127c:	00000097          	auipc	ra,0x0
    1280:	d8e080e7          	jalr	-626(ra) # 100a <putc>
      state = 0;
    1284:	4981                	li	s3,0
    1286:	bd51                	j	111a <vprintf+0x42>
        s = va_arg(ap, char*);
    1288:	8bce                	mv	s7,s3
      state = 0;
    128a:	4981                	li	s3,0
    128c:	b579                	j	111a <vprintf+0x42>
    128e:	74e2                	ld	s1,56(sp)
    1290:	79a2                	ld	s3,40(sp)
    1292:	7a02                	ld	s4,32(sp)
    1294:	6ae2                	ld	s5,24(sp)
    1296:	6b42                	ld	s6,16(sp)
    1298:	6ba2                	ld	s7,8(sp)
    }
  }
}
    129a:	60a6                	ld	ra,72(sp)
    129c:	6406                	ld	s0,64(sp)
    129e:	7942                	ld	s2,48(sp)
    12a0:	6161                	addi	sp,sp,80
    12a2:	8082                	ret

00000000000012a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    12a4:	715d                	addi	sp,sp,-80
    12a6:	ec06                	sd	ra,24(sp)
    12a8:	e822                	sd	s0,16(sp)
    12aa:	1000                	addi	s0,sp,32
    12ac:	e010                	sd	a2,0(s0)
    12ae:	e414                	sd	a3,8(s0)
    12b0:	e818                	sd	a4,16(s0)
    12b2:	ec1c                	sd	a5,24(s0)
    12b4:	03043023          	sd	a6,32(s0)
    12b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    12bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    12c0:	8622                	mv	a2,s0
    12c2:	00000097          	auipc	ra,0x0
    12c6:	e16080e7          	jalr	-490(ra) # 10d8 <vprintf>
}
    12ca:	60e2                	ld	ra,24(sp)
    12cc:	6442                	ld	s0,16(sp)
    12ce:	6161                	addi	sp,sp,80
    12d0:	8082                	ret

00000000000012d2 <printf>:

void
printf(const char *fmt, ...)
{
    12d2:	711d                	addi	sp,sp,-96
    12d4:	ec06                	sd	ra,24(sp)
    12d6:	e822                	sd	s0,16(sp)
    12d8:	1000                	addi	s0,sp,32
    12da:	e40c                	sd	a1,8(s0)
    12dc:	e810                	sd	a2,16(s0)
    12de:	ec14                	sd	a3,24(s0)
    12e0:	f018                	sd	a4,32(s0)
    12e2:	f41c                	sd	a5,40(s0)
    12e4:	03043823          	sd	a6,48(s0)
    12e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12ec:	00840613          	addi	a2,s0,8
    12f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12f4:	85aa                	mv	a1,a0
    12f6:	4505                	li	a0,1
    12f8:	00000097          	auipc	ra,0x0
    12fc:	de0080e7          	jalr	-544(ra) # 10d8 <vprintf>
}
    1300:	60e2                	ld	ra,24(sp)
    1302:	6442                	ld	s0,16(sp)
    1304:	6125                	addi	sp,sp,96
    1306:	8082                	ret

0000000000001308 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1308:	1141                	addi	sp,sp,-16
    130a:	e422                	sd	s0,8(sp)
    130c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    130e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1312:	00001797          	auipc	a5,0x1
    1316:	d0e7b783          	ld	a5,-754(a5) # 2020 <freep>
    131a:	a02d                	j	1344 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    131c:	4618                	lw	a4,8(a2)
    131e:	9f2d                	addw	a4,a4,a1
    1320:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1324:	6398                	ld	a4,0(a5)
    1326:	6310                	ld	a2,0(a4)
    1328:	a83d                	j	1366 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    132a:	ff852703          	lw	a4,-8(a0)
    132e:	9f31                	addw	a4,a4,a2
    1330:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1332:	ff053683          	ld	a3,-16(a0)
    1336:	a091                	j	137a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1338:	6398                	ld	a4,0(a5)
    133a:	00e7e463          	bltu	a5,a4,1342 <free+0x3a>
    133e:	00e6ea63          	bltu	a3,a4,1352 <free+0x4a>
{
    1342:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1344:	fed7fae3          	bgeu	a5,a3,1338 <free+0x30>
    1348:	6398                	ld	a4,0(a5)
    134a:	00e6e463          	bltu	a3,a4,1352 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    134e:	fee7eae3          	bltu	a5,a4,1342 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1352:	ff852583          	lw	a1,-8(a0)
    1356:	6390                	ld	a2,0(a5)
    1358:	02059813          	slli	a6,a1,0x20
    135c:	01c85713          	srli	a4,a6,0x1c
    1360:	9736                	add	a4,a4,a3
    1362:	fae60de3          	beq	a2,a4,131c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1366:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    136a:	4790                	lw	a2,8(a5)
    136c:	02061593          	slli	a1,a2,0x20
    1370:	01c5d713          	srli	a4,a1,0x1c
    1374:	973e                	add	a4,a4,a5
    1376:	fae68ae3          	beq	a3,a4,132a <free+0x22>
    p->s.ptr = bp->s.ptr;
    137a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    137c:	00001717          	auipc	a4,0x1
    1380:	caf73223          	sd	a5,-860(a4) # 2020 <freep>
}
    1384:	6422                	ld	s0,8(sp)
    1386:	0141                	addi	sp,sp,16
    1388:	8082                	ret

000000000000138a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    138a:	7139                	addi	sp,sp,-64
    138c:	fc06                	sd	ra,56(sp)
    138e:	f822                	sd	s0,48(sp)
    1390:	f426                	sd	s1,40(sp)
    1392:	ec4e                	sd	s3,24(sp)
    1394:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1396:	02051493          	slli	s1,a0,0x20
    139a:	9081                	srli	s1,s1,0x20
    139c:	04bd                	addi	s1,s1,15
    139e:	8091                	srli	s1,s1,0x4
    13a0:	0014899b          	addiw	s3,s1,1
    13a4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    13a6:	00001517          	auipc	a0,0x1
    13aa:	c7a53503          	ld	a0,-902(a0) # 2020 <freep>
    13ae:	c915                	beqz	a0,13e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13b2:	4798                	lw	a4,8(a5)
    13b4:	08977e63          	bgeu	a4,s1,1450 <malloc+0xc6>
    13b8:	f04a                	sd	s2,32(sp)
    13ba:	e852                	sd	s4,16(sp)
    13bc:	e456                	sd	s5,8(sp)
    13be:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    13c0:	8a4e                	mv	s4,s3
    13c2:	0009871b          	sext.w	a4,s3
    13c6:	6685                	lui	a3,0x1
    13c8:	00d77363          	bgeu	a4,a3,13ce <malloc+0x44>
    13cc:	6a05                	lui	s4,0x1
    13ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13d6:	00001917          	auipc	s2,0x1
    13da:	c4a90913          	addi	s2,s2,-950 # 2020 <freep>
  if(p == (char*)-1)
    13de:	5afd                	li	s5,-1
    13e0:	a091                	j	1424 <malloc+0x9a>
    13e2:	f04a                	sd	s2,32(sp)
    13e4:	e852                	sd	s4,16(sp)
    13e6:	e456                	sd	s5,8(sp)
    13e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13ea:	00001797          	auipc	a5,0x1
    13ee:	cbe78793          	addi	a5,a5,-834 # 20a8 <base>
    13f2:	00001717          	auipc	a4,0x1
    13f6:	c2f73723          	sd	a5,-978(a4) # 2020 <freep>
    13fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1400:	b7c1                	j	13c0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1402:	6398                	ld	a4,0(a5)
    1404:	e118                	sd	a4,0(a0)
    1406:	a08d                	j	1468 <malloc+0xde>
  hp->s.size = nu;
    1408:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    140c:	0541                	addi	a0,a0,16
    140e:	00000097          	auipc	ra,0x0
    1412:	efa080e7          	jalr	-262(ra) # 1308 <free>
  return freep;
    1416:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    141a:	c13d                	beqz	a0,1480 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    141c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    141e:	4798                	lw	a4,8(a5)
    1420:	02977463          	bgeu	a4,s1,1448 <malloc+0xbe>
    if(p == freep)
    1424:	00093703          	ld	a4,0(s2)
    1428:	853e                	mv	a0,a5
    142a:	fef719e3          	bne	a4,a5,141c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    142e:	8552                	mv	a0,s4
    1430:	00000097          	auipc	ra,0x0
    1434:	b54080e7          	jalr	-1196(ra) # f84 <sbrk>
  if(p == (char*)-1)
    1438:	fd5518e3          	bne	a0,s5,1408 <malloc+0x7e>
        return 0;
    143c:	4501                	li	a0,0
    143e:	7902                	ld	s2,32(sp)
    1440:	6a42                	ld	s4,16(sp)
    1442:	6aa2                	ld	s5,8(sp)
    1444:	6b02                	ld	s6,0(sp)
    1446:	a03d                	j	1474 <malloc+0xea>
    1448:	7902                	ld	s2,32(sp)
    144a:	6a42                	ld	s4,16(sp)
    144c:	6aa2                	ld	s5,8(sp)
    144e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1450:	fae489e3          	beq	s1,a4,1402 <malloc+0x78>
        p->s.size -= nunits;
    1454:	4137073b          	subw	a4,a4,s3
    1458:	c798                	sw	a4,8(a5)
        p += p->s.size;
    145a:	02071693          	slli	a3,a4,0x20
    145e:	01c6d713          	srli	a4,a3,0x1c
    1462:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1464:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1468:	00001717          	auipc	a4,0x1
    146c:	baa73c23          	sd	a0,-1096(a4) # 2020 <freep>
      return (void*)(p + 1);
    1470:	01078513          	addi	a0,a5,16
  }
}
    1474:	70e2                	ld	ra,56(sp)
    1476:	7442                	ld	s0,48(sp)
    1478:	74a2                	ld	s1,40(sp)
    147a:	69e2                	ld	s3,24(sp)
    147c:	6121                	addi	sp,sp,64
    147e:	8082                	ret
    1480:	7902                	ld	s2,32(sp)
    1482:	6a42                	ld	s4,16(sp)
    1484:	6aa2                	ld	s5,8(sp)
    1486:	6b02                	ld	s6,0(sp)
    1488:	b7f5                	j	1474 <malloc+0xea>

000000000000148a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
    148a:	1141                	addi	sp,sp,-16
    148c:	e406                	sd	ra,8(sp)
    148e:	e022                	sd	s0,0(sp)
    1490:	0800                	addi	s0,sp,16
  thread_exit(status);
    1492:	2501                	sext.w	a0,a0
    1494:	00000097          	auipc	ra,0x0
    1498:	b20080e7          	jalr	-1248(ra) # fb4 <thread_exit>
}
    149c:	60a2                	ld	ra,8(sp)
    149e:	6402                	ld	s0,0(sp)
    14a0:	0141                	addi	sp,sp,16
    14a2:	8082                	ret

00000000000014a4 <free_stacks>:
int free_stacks() {
    14a4:	7179                	addi	sp,sp,-48
    14a6:	f406                	sd	ra,40(sp)
    14a8:	f022                	sd	s0,32(sp)
    14aa:	ec26                	sd	s1,24(sp)
    14ac:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
    14ae:	00001797          	auipc	a5,0x1
    14b2:	b827a783          	lw	a5,-1150(a5) # 2030 <num_threads>
    14b6:	04f05063          	blez	a5,14f6 <free_stacks+0x52>
    14ba:	e84a                	sd	s2,16(sp)
    14bc:	e44e                	sd	s3,8(sp)
    14be:	4481                	li	s1,0
    free(stacks[i]);
    14c0:	00001997          	auipc	s3,0x1
    14c4:	b6898993          	addi	s3,s3,-1176 # 2028 <stacks>
  for (int i = 0; i < num_threads; i++) {
    14c8:	00001917          	auipc	s2,0x1
    14cc:	b6890913          	addi	s2,s2,-1176 # 2030 <num_threads>
    free(stacks[i]);
    14d0:	0009b783          	ld	a5,0(s3)
    14d4:	00349713          	slli	a4,s1,0x3
    14d8:	97ba                	add	a5,a5,a4
    14da:	6388                	ld	a0,0(a5)
    14dc:	00000097          	auipc	ra,0x0
    14e0:	e2c080e7          	jalr	-468(ra) # 1308 <free>
  for (int i = 0; i < num_threads; i++) {
    14e4:	0485                	addi	s1,s1,1
    14e6:	00092703          	lw	a4,0(s2)
    14ea:	0004879b          	sext.w	a5,s1
    14ee:	fee7c1e3          	blt	a5,a4,14d0 <free_stacks+0x2c>
    14f2:	6942                	ld	s2,16(sp)
    14f4:	69a2                	ld	s3,8(sp)
  free(stacks);
    14f6:	00001497          	auipc	s1,0x1
    14fa:	b3248493          	addi	s1,s1,-1230 # 2028 <stacks>
    14fe:	6088                	ld	a0,0(s1)
    1500:	00000097          	auipc	ra,0x0
    1504:	e08080e7          	jalr	-504(ra) # 1308 <free>
  stacks = 0;
    1508:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
    150c:	00001797          	auipc	a5,0x1
    1510:	b207a223          	sw	zero,-1244(a5) # 2030 <num_threads>
  max_stacks = INIT_MAX_STACKS;
    1514:	47a1                	li	a5,8
    1516:	00001717          	auipc	a4,0x1
    151a:	aef72d23          	sw	a5,-1286(a4) # 2010 <max_stacks>
  threads_done = 0;
    151e:	00001797          	auipc	a5,0x1
    1522:	b007ab23          	sw	zero,-1258(a5) # 2034 <threads_done>
}
    1526:	4501                	li	a0,0
    1528:	70a2                	ld	ra,40(sp)
    152a:	7402                	ld	s0,32(sp)
    152c:	64e2                	ld	s1,24(sp)
    152e:	6145                	addi	sp,sp,48
    1530:	8082                	ret

0000000000001532 <expand_num_threads>:
int expand_num_threads() {
    1532:	1101                	addi	sp,sp,-32
    1534:	ec06                	sd	ra,24(sp)
    1536:	e822                	sd	s0,16(sp)
    1538:	e426                	sd	s1,8(sp)
    153a:	e04a                	sd	s2,0(sp)
    153c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
    153e:	00001797          	auipc	a5,0x1
    1542:	ad278793          	addi	a5,a5,-1326 # 2010 <max_stacks>
    1546:	4388                	lw	a0,0(a5)
    1548:	0015151b          	slliw	a0,a0,0x1
    154c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
    154e:	0035151b          	slliw	a0,a0,0x3
    1552:	00000097          	auipc	ra,0x0
    1556:	e38080e7          	jalr	-456(ra) # 138a <malloc>
    155a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
    155c:	00001617          	auipc	a2,0x1
    1560:	ad462603          	lw	a2,-1324(a2) # 2030 <num_threads>
    1564:	00001497          	auipc	s1,0x1
    1568:	ac448493          	addi	s1,s1,-1340 # 2028 <stacks>
    156c:	0036161b          	slliw	a2,a2,0x3
    1570:	608c                	ld	a1,0(s1)
    1572:	00000097          	auipc	ra,0x0
    1576:	840080e7          	jalr	-1984(ra) # db2 <memmove>
  free(stacks);
    157a:	6088                	ld	a0,0(s1)
    157c:	00000097          	auipc	ra,0x0
    1580:	d8c080e7          	jalr	-628(ra) # 1308 <free>
  stacks = new_stacks;
    1584:	0124b023          	sd	s2,0(s1)
}
    1588:	4501                	li	a0,0
    158a:	60e2                	ld	ra,24(sp)
    158c:	6442                	ld	s0,16(sp)
    158e:	64a2                	ld	s1,8(sp)
    1590:	6902                	ld	s2,0(sp)
    1592:	6105                	addi	sp,sp,32
    1594:	8082                	ret

0000000000001596 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
    1596:	7179                	addi	sp,sp,-48
    1598:	f406                	sd	ra,40(sp)
    159a:	f022                	sd	s0,32(sp)
    159c:	e84a                	sd	s2,16(sp)
    159e:	e44e                	sd	s3,8(sp)
    15a0:	1800                	addi	s0,sp,48
    15a2:	892a                	mv	s2,a0
    15a4:	89ae                	mv	s3,a1
  if (stacks == 0) {
    15a6:	00001797          	auipc	a5,0x1
    15aa:	a827b783          	ld	a5,-1406(a5) # 2028 <stacks>
    15ae:	c3d9                	beqz	a5,1634 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    15b0:	00001797          	auipc	a5,0x1
    15b4:	a607a783          	lw	a5,-1440(a5) # 2010 <max_stacks>
    15b8:	00001717          	auipc	a4,0x1
    15bc:	a7872703          	lw	a4,-1416(a4) # 2030 <num_threads>
    15c0:	0af71363          	bne	a4,a5,1666 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
    15c4:	04000713          	li	a4,64
    15c8:	08e78563          	beq	a5,a4,1652 <ithread_create+0xbc>
    15cc:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
    15ce:	00000097          	auipc	ra,0x0
    15d2:	f64080e7          	jalr	-156(ra) # 1532 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
    15d6:	6505                	lui	a0,0x1
    15d8:	00000097          	auipc	ra,0x0
    15dc:	db2080e7          	jalr	-590(ra) # 138a <malloc>
    15e0:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
    15e2:	00001717          	auipc	a4,0x1
    15e6:	a4e72703          	lw	a4,-1458(a4) # 2030 <num_threads>
    15ea:	070e                	slli	a4,a4,0x3
    15ec:	00001797          	auipc	a5,0x1
    15f0:	a3c7b783          	ld	a5,-1476(a5) # 2028 <stacks>
    15f4:	97ba                	add	a5,a5,a4
    15f6:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
    15f8:	00000697          	auipc	a3,0x0
    15fc:	e9268693          	addi	a3,a3,-366 # 148a <ithread_exit>
    1600:	862a                	mv	a2,a0
    1602:	85ce                	mv	a1,s3
    1604:	854a                	mv	a0,s2
    1606:	00000097          	auipc	ra,0x0
    160a:	99e080e7          	jalr	-1634(ra) # fa4 <create_thread>
    160e:	892a                	mv	s2,a0
  if (res != -1) {
    1610:	57fd                	li	a5,-1
    1612:	04f50c63          	beq	a0,a5,166a <ithread_create+0xd4>
    num_threads++;
    1616:	00001717          	auipc	a4,0x1
    161a:	a1a70713          	addi	a4,a4,-1510 # 2030 <num_threads>
    161e:	431c                	lw	a5,0(a4)
    1620:	2785                	addiw	a5,a5,1
    1622:	c31c                	sw	a5,0(a4)
    1624:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
    1626:	854a                	mv	a0,s2
    1628:	70a2                	ld	ra,40(sp)
    162a:	7402                	ld	s0,32(sp)
    162c:	6942                	ld	s2,16(sp)
    162e:	69a2                	ld	s3,8(sp)
    1630:	6145                	addi	sp,sp,48
    1632:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
    1634:	00001517          	auipc	a0,0x1
    1638:	9dc52503          	lw	a0,-1572(a0) # 2010 <max_stacks>
    163c:	0035151b          	slliw	a0,a0,0x3
    1640:	00000097          	auipc	ra,0x0
    1644:	d4a080e7          	jalr	-694(ra) # 138a <malloc>
    1648:	00001797          	auipc	a5,0x1
    164c:	9ea7b023          	sd	a0,-1568(a5) # 2028 <stacks>
    1650:	b785                	j	15b0 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
    1652:	00000517          	auipc	a0,0x0
    1656:	19e50513          	addi	a0,a0,414 # 17f0 <ithread_join+0x160>
    165a:	00000097          	auipc	ra,0x0
    165e:	c78080e7          	jalr	-904(ra) # 12d2 <printf>
      return -1;
    1662:	597d                	li	s2,-1
    1664:	b7c9                	j	1626 <ithread_create+0x90>
    1666:	ec26                	sd	s1,24(sp)
    1668:	b7bd                	j	15d6 <ithread_create+0x40>
    free(stack_ptr);
    166a:	8526                	mv	a0,s1
    166c:	00000097          	auipc	ra,0x0
    1670:	c9c080e7          	jalr	-868(ra) # 1308 <free>
    stacks[num_threads] = 0;
    1674:	00001717          	auipc	a4,0x1
    1678:	9bc72703          	lw	a4,-1604(a4) # 2030 <num_threads>
    167c:	070e                	slli	a4,a4,0x3
    167e:	00001797          	auipc	a5,0x1
    1682:	9aa7b783          	ld	a5,-1622(a5) # 2028 <stacks>
    1686:	97ba                	add	a5,a5,a4
    1688:	0007b023          	sd	zero,0(a5)
    168c:	64e2                	ld	s1,24(sp)
    168e:	bf61                	j	1626 <ithread_create+0x90>

0000000000001690 <ithread_join>:

int ithread_join(int thread_id) {
    1690:	1101                	addi	sp,sp,-32
    1692:	ec06                	sd	ra,24(sp)
    1694:	e822                	sd	s0,16(sp)
    1696:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
    1698:	ff040793          	addi	a5,s0,-16
    169c:	ffc7859b          	addiw	a1,a5,-4
    16a0:	00000097          	auipc	ra,0x0
    16a4:	90c080e7          	jalr	-1780(ra) # fac <join_thread>
  threads_done++;
    16a8:	00001717          	auipc	a4,0x1
    16ac:	98c70713          	addi	a4,a4,-1652 # 2034 <threads_done>
    16b0:	431c                	lw	a5,0(a4)
    16b2:	2785                	addiw	a5,a5,1
    16b4:	0007869b          	sext.w	a3,a5
    16b8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
    16ba:	00001797          	auipc	a5,0x1
    16be:	9767a783          	lw	a5,-1674(a5) # 2030 <num_threads>
    16c2:	00d78863          	beq	a5,a3,16d2 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
    16c6:	fec42503          	lw	a0,-20(s0)
    16ca:	60e2                	ld	ra,24(sp)
    16cc:	6442                	ld	s0,16(sp)
    16ce:	6105                	addi	sp,sp,32
    16d0:	8082                	ret
    free_stacks();
    16d2:	00000097          	auipc	ra,0x0
    16d6:	dd2080e7          	jalr	-558(ra) # 14a4 <free_stacks>
    16da:	b7f5                	j	16c6 <ithread_join+0x36>
