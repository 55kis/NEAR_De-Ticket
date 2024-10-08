import { Column,Entity,JoinColumn,ManyToOne,PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Cliente{
    @PrimaryGeneratedColumn()
    id: number;

    @Column("name")
    name: string;

    @Column("age")
    age: number;

    @Column("email")
    email: string;

}