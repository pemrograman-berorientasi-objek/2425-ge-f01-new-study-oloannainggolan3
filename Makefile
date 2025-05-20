compile :
	mvn --quiet clean compile assembly:single

test_01 :
	java -jar ./target/f01-1.0-SNAPSHOT-jar-with-dependencies.jar

package pbo.model;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class drivApp {
    private static EntityManagerFactory factory;
    private static EntityManager entityManager;

    public static ArrayList<Student> containerStudents = new ArrayList<>();
    public static ArrayList<Course> containerCourses = new ArrayList<>();

    // Inisialisasi EntityManager
    public static void initializeEntityManager() {
        factory = Persistence.createEntityManagerFactory("study_plan_pu");
        entityManager = factory.createEntityManager();
    }

    // Bersihkan tabel Student
    public static void cleanTableStudent() {
        entityManager.getTransaction().begin();
        entityManager.createQuery("DELETE FROM Student s").executeUpdate();
        entityManager.flush();
        entityManager.getTransaction().commit();
    }

    // Bersihkan tabel Course
    public static void cleanTableCourse() {
        entityManager.getTransaction().begin();
        entityManager.createQuery("DELETE FROM Course c").executeUpdate();
        entityManager.flush();
        entityManager.getTransaction().commit();
    }

    // Bersihkan tabel Enrollment
    public static void cleanTableEnrollment() {
        entityManager.getTransaction().begin();
        entityManager.createQuery("DELETE FROM Enrollment e").executeUpdate();
        entityManager.flush();
        entityManager.getTransaction().commit();
    }

    // Tambah mahasiswa
    public static void CreateStudent(String studentId, String name, String studyProgram) {
        boolean exists = containerStudents.stream().anyMatch(s -> s.getStudentId().equals(studentId));
        if (!exists) {
            Student newStudent = new Student(studentId, name, studyProgram);
            containerStudents.add(newStudent);
            entityManager.getTransaction().begin();
            entityManager.persist(newStudent);
            entityManager.flush();
            entityManager.getTransaction().commit();
        }
    }

    // Tambah mata kuliah
    public static void createCourse(String courseId, String courseName, int semester, int credit) {
        boolean exists = containerCourses.stream().anyMatch(c -> c.getCourseId().equals(courseId));
        if (!exists) {
            Course newCourse = new Course(courseId, courseName, semester, credit);
            containerCourses.add(newCourse);
            entityManager.getTransaction().begin();
            entityManager.persist(newCourse);
            entityManager.flush();
            entityManager.getTransaction().commit();
        }
    }

    // Tampilkan semua mahasiswa
   public static void ShowStudent() {
    // Query untuk mengurutkan mahasiswa berdasarkan studentId (nim) secara ascending
    String query = "SELECT s FROM Student s ORDER BY s.studentId ASC";
    List<Student> students = entityManager.createQuery(query, Student.class)
            .getResultList();

    for (Student s : students) {
        System.out.println(s.toString());
    }
}


 public static void ShowCourse() {
    // Query untuk mengurutkan data mata kuliah berdasarkan semester dan courseId secara ascending
    String query = "SELECT c FROM Course c ORDER BY c.semester ASC, c.courseId ASC";
    List<Course> courses = entityManager.createQuery(query, Course.class)
            .getResultList();

    for (Course c : courses) {
        System.out.println(c.toString());
    }
}


    // Daftarkan mahasiswa ke mata kuliah (diperbaiki)
    public static void createEnroll(String studentId, String courseId) {
        // Cek apakah enrollment sudah ada
        String query = "SELECT e FROM Enrollment e WHERE e.studentId = :studentId AND e.courseId = :courseId";
        List<Enrollment> existingEnrollments = entityManager.createQuery(query, Enrollment.class)
                .setParameter("studentId", studentId)
                .setParameter("courseId", courseId)
                .getResultList();

        if (!existingEnrollments.isEmpty()) {
            return; // Enrollment sudah ada, tidak ditambahkan
        }

        boolean studentExists = containerStudents.stream().anyMatch(s -> s.getStudentId().equals(studentId));
        boolean courseExists = containerCourses.stream().anyMatch(c -> c.getCourseId().equals(courseId));

        if (studentExists && courseExists) {
            Enrollment newEnroll = new Enrollment(studentId, courseId);
            entityManager.getTransaction().begin();
            entityManager.persist(newEnroll);
            entityManager.flush();
            entityManager.getTransaction().commit();
        }
    }

    public static void ShowStudentDetail(String studentId) {
    // Menampilkan data mahasiswa
    String query = "SELECT s FROM Student s WHERE s.studentId = :studentId";
    Student student = entityManager.createQuery(query, Student.class)
            .setParameter("studentId", studentId)
            .getSingleResult();
    System.out.println(student.toString());

    // Query untuk mendapatkan mata kuliah yang diambil oleh mahasiswa
    String queryEnroll = "SELECT e FROM Enrollment e WHERE e.studentId = :studentId";
    List<Enrollment> enrollments = entityManager.createQuery(queryEnroll, Enrollment.class)
            .setParameter("studentId", studentId)
            .getResultList();

    List<Course> courses = new ArrayList<>();
    for (Enrollment e : enrollments) {
        String courseId = e.getCourseId();
        Course course = entityManager.find(Course.class, courseId);
        if (course != null) {
            courses.add(course);
        }
    }

    // Mengurutkan daftar kursus berdasarkan semester dan courseId secara ascending
    courses.sort(Comparator.comparing(Course::getSemester)
                          .thenComparing(Course::getCourseId));

    for (Course c : courses) {
        System.out.println(c.toString());
    }
}
}