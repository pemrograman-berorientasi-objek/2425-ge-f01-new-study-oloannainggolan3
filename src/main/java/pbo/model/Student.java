package pbo.model;

import javax.persistence.*;

@Entity
@Table(name = "student")
public class Student {
    
    private static int nextId = 1;

    @Id
    @Column(name = "id", nullable = false, length = 25)
    private int id = 0;

    @Column(name = "nim", nullable = false, length = 25)
    private String nim;

    @Column(name = "nama", nullable = false, length = 50)
    private String nama;

    @Column(name = "prodi", nullable = false, length = 50)
    private String prodi;

    public Student() {
        // empty constructor
    }

    public Student(String nim, String nama, String prodi) {
        this.id = nextId++;
        this.nim = nim;
        this.nama = nama;
        this.prodi = prodi;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNim() {
        return nim;
    }

    public void setNim(String nim) {
        this.nim = nim;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getProdi() {
        return prodi;
    }

    public void setProdi(String prodi) {
        this.prodi = prodi;
    }
}
